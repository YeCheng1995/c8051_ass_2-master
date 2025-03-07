//
//  Renderer.m
//  ass_2
//
//  Created by Choy on 2019-02-16.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Renderer.h"
#import "GLProgram.h"
#import "../Utility.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>
#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface Renderer() {
    NSMutableDictionary<NSString *, GLProgram *> *_programs;
    
    GLKMatrix4 _viewMatrix;
    GLKMatrix4 _projectionMatrix;
    
    GLuint framebuffer;
    GLuint colorRenderbuffer;
    GLuint depthRenderbuffer;
}

@end

@implementation Renderer

- (void)initWithView:(GLKView *)view {
    self._context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self._context) {
        [[Utility getInstance] log:"Failed to create GLES context."];
    }
    
    view.context = self._context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self._context];
    
    _programs = [NSMutableDictionary<NSString *, GLProgram *> dictionary];
    
    if (![self loadShaders]) {
        [[Utility getInstance] log:"Failed to setup shaders."];
    }
    
    self._dirLight = [[DirectionalLight alloc] init];
    self._spotLight = [[SpotLight alloc] init];
    self.renderMinimap = false;
    self.fogStart = 0.0f;
    self.fogEnd = 25.0f;
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_TEXTURE_2D);
    
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glViewport(0, 0, (GLsizei)view.bounds.size.width, (GLsizei)view.bounds.size.height);
    
    self._camera = [[Camera alloc] init];
    self._topCamera = [[Camera alloc] initWithPosition:GLKVector3Make(0.0f, 12.0f, 0.0f)];
    self._topCamera._pitch = -90.0f;
    [self._topCamera update];
    self._meshes = [[NSMutableArray<Mesh *> alloc] init];
    
    float aspect = fabsf((float)(view.bounds.size.width / view.bounds.size.height));
    _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(ZOOM), aspect, 0.01f, 100.0f);
    
    // generate fbo
    glGenFramebuffers(1, &framebuffer);
    // generate texture
    glGenTextures(1, &_texture);
    // generate render buffer
    glGenRenderbuffers(1, &colorRenderbuffer);
    // bind frame buffer
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    // bind texture
    glBindTexture(GL_TEXTURE_2D, _texture);
    // define texture parameters
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, view.bounds.size.width, view.bounds.size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // bind render buffer and define buffer dimension
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, view.bounds.size.width, view.bounds.size.height);
    // attach texture fbo color attachment
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _texture, 0);
    // attach render buffer to depth attachment
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, colorRenderbuffer);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object %x", status);
    }
    // done creating the fbo
    glBindTexture(GL_TEXTURE_2D, 0);
    glBindRenderbuffer(GL_RENDERBUFFER, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

- (void)cleanUp {
    [EAGLContext setCurrentContext:self._context];
    if (self._cube) {
        [self._cube cleanUp];
    }
    if (self._player) {
        [self._player cleanUp];
    }
    // Clean up meshes here
    for (Mesh *mesh in self._meshes) {
        [mesh cleanUp];
    }
    
    if (framebuffer) {
        glDeleteFramebuffers(1, &framebuffer);
        framebuffer = 0;
    }
    
    if (colorRenderbuffer) {
        glDeleteRenderbuffers(1, &colorRenderbuffer);
        colorRenderbuffer = 0;
    }
    
    if (_texture) {
        glDeleteTextures(1, &_texture);
        _texture = 0;
    }
    
    if (depthRenderbuffer) {
        glDeleteRenderbuffers(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}

- (void)update:(float)deltaTime {
    self._topCamera._position = GLKVector3Make(self._camera._position.x, 12.0f, self._camera._position.z);
    
    self._player._position = self._camera._position;
    self._player._rotation = GLKVector3Make(0.0f, -GLKMathDegreesToRadians(self._camera._yaw), 0.0f);
    
    self._spotLight._position = self._camera._position;
    self._spotLight._direction = self._camera._front;
    
    if (self._cube) {
        self._cube._rotation = GLKVector3AddScalar(self._cube._rotation, 0.01f);
    }
    
    if (self._topCameraView) {
        self._topCameraView._position = GLKVector3MultiplyScalar(self._camera._front, 1.0001f);
        self._topCameraView._rotation = GLKVector3Make(0.0f, -GLKMathDegreesToRadians(self._camera._yaw), 0.0f);
    }
}

- (void)render:(float)deltaTime drawInRect:(CGRect)rect {
    GLint oldFBO, width, height;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &oldFBO);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    
    /* Render the top camera to a texture */
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glViewport(0, 0, width, height);
    glClear(GL_COLOR_BUFFER_BIT |  GL_DEPTH_BUFFER_BIT);
    
    [_programs[[NSString stringWithUTF8String:"basic"]] bind];
    
    // material properties
    [_programs[[NSString stringWithUTF8String:"basic"]] set3fv:self._camera._position.v uniformName:"viewPos"];
    
    [self._dirLight draw:_programs[[NSString stringWithUTF8String:"basic"]]];
    [self._spotLight draw:_programs[[NSString stringWithUTF8String:"basic"]]];
    
    _viewMatrix = [self._topCamera getViewMatrix];

    [_programs[[NSString stringWithUTF8String:"basic"]] set4fvm:_projectionMatrix.m uniformName:"projection"];
    [_programs[[NSString stringWithUTF8String:"basic"]] set4fvm:_viewMatrix.m uniformName:"view"];
    
    if (self._player) {
        GLKMatrix4 modelMatrix = GLKMatrix4Identity;
        modelMatrix = GLKMatrix4Translate(modelMatrix, self._player._position.x,  self._player._position.y, self._player._position.z);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self._player._rotation.x, 1.0f, 0.0f, 0.0f);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self._player._rotation.y, 0.0f, 1.0f, 0.0f);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self._player._rotation.z, 0.0f, 0.0f, 1.0f);
        modelMatrix = GLKMatrix4Scale(modelMatrix, self._player._scale.x, self._player._scale.y, self._player._scale.z);
        GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(GLKMatrix4Multiply(_viewMatrix, modelMatrix)), NULL);
        [_programs[[NSString stringWithUTF8String:"basic"]] set3fvm:normalMatrix.m uniformName:"normalMatrix"];
        [_programs[[NSString stringWithUTF8String:"basic"]] set4fvm:modelMatrix.m uniformName:"model"];
        [self._player draw:_programs[[NSString stringWithUTF8String:"basic"]]];
    }
    
    if (self._cube) {
        GLKMatrix4 modelMatrix = GLKMatrix4Identity;
        modelMatrix = GLKMatrix4Translate(modelMatrix, self._cube._position.x,  self._cube._position.y, self._cube._position.z);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self._cube._rotation.x, 1.0f, 0.0f, 0.0f);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self._cube._rotation.y, 0.0f, 1.0f, 0.0f);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self._cube._rotation.z, 0.0f, 0.0f, 1.0f);
        modelMatrix = GLKMatrix4Scale(modelMatrix, self._cube._scale.x, self._cube._scale.y, self._cube._scale.z);
        GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(GLKMatrix4Multiply(_viewMatrix, modelMatrix)), NULL);
        [_programs[[NSString stringWithUTF8String:"basic"]] set3fvm:normalMatrix.m uniformName:"normalMatrix"];
        [_programs[[NSString stringWithUTF8String:"basic"]] set4fvm:modelMatrix.m uniformName:"model"];
        [self._cube draw:_programs[[NSString stringWithUTF8String:"basic"]]];
    }
    
    // Render stuff
    for (Mesh *mesh in self._meshes) {
        GLKMatrix4 modelMatrix = GLKMatrix4Identity;
        modelMatrix = GLKMatrix4Translate(modelMatrix, mesh._position.x,  mesh._position.y, mesh._position.z);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, mesh._rotation.x, 1.0f, 0.0f, 0.0f);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, mesh._rotation.y, 0.0f, 1.0f, 0.0f);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, mesh._rotation.z, 0.0f, 0.0f, 1.0f);
        modelMatrix = GLKMatrix4Scale(modelMatrix, mesh._scale.x, mesh._scale.y, mesh._scale.z);
        GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(GLKMatrix4Multiply(_viewMatrix, modelMatrix)), NULL);
        [_programs[[NSString stringWithUTF8String:"basic"]] set3fvm:normalMatrix.m uniformName:"normalMatrix"];
        [_programs[[NSString stringWithUTF8String:"basic"]] set4fvm:modelMatrix.m uniformName:"model"];
        [mesh draw:_programs[[NSString stringWithUTF8String:"basic"]]];
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, oldFBO);
     
    /* RENDER WHAT THE PLAYER SEES NOW */
    glViewport(0, 0, width, height);
    glClear(GL_COLOR_BUFFER_BIT |  GL_DEPTH_BUFFER_BIT);
    
    [_programs[[NSString stringWithUTF8String:"fog"]] bind];
    
    [_programs[[NSString stringWithUTF8String:"fog"]] set1f:_fogStart uniformName:"fogStart"];
    [_programs[[NSString stringWithUTF8String:"fog"]] set1f:_fogEnd uniformName:"fogEnd"];
    
    // material properties
    [_programs[[NSString stringWithUTF8String:"fog"]] set3fv:self._camera._position.v uniformName:"viewPos"];
    
    [self._dirLight draw:_programs[[NSString stringWithUTF8String:"fog"]]];
    [self._spotLight draw:_programs[[NSString stringWithUTF8String:"fog"]]];
    
    _viewMatrix = [self._camera getViewMatrix];
    
    [_programs[[NSString stringWithUTF8String:"fog"]] set4fvm:_projectionMatrix.m uniformName:"projection"];
    [_programs[[NSString stringWithUTF8String:"fog"]] set4fvm:_viewMatrix.m uniformName:"view"];
    
    if (self._cube) {
        GLKMatrix4 modelMatrix = GLKMatrix4Identity;
        modelMatrix = GLKMatrix4Translate(modelMatrix, self._cube._position.x,  self._cube._position.y, self._cube._position.z);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self._cube._rotation.x, 1.0f, 0.0f, 0.0f);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self._cube._rotation.y, 0.0f, 1.0f, 0.0f);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self._cube._rotation.z, 0.0f, 0.0f, 1.0f);
        modelMatrix = GLKMatrix4Scale(modelMatrix, self._cube._scale.x, self._cube._scale.y, self._cube._scale.z);
        GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(GLKMatrix4Multiply(_viewMatrix, modelMatrix)), NULL);
        [_programs[[NSString stringWithUTF8String:"fog"]] set3fvm:normalMatrix.m uniformName:"normalMatrix"];
        [_programs[[NSString stringWithUTF8String:"fog"]] set4fvm:modelMatrix.m uniformName:"model"];
        [self._cube draw:_programs[[NSString stringWithUTF8String:"fog"]]];
    }
    
    // Render stuff
    for (Mesh *mesh in self._meshes) {
        GLKMatrix4 modelMatrix = GLKMatrix4Identity;
        modelMatrix = GLKMatrix4Translate(modelMatrix, mesh._position.x,  mesh._position.y, mesh._position.z);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, mesh._rotation.x, 1.0f, 0.0f, 0.0f);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, mesh._rotation.y, 0.0f, 1.0f, 0.0f);
        modelMatrix = GLKMatrix4Rotate(modelMatrix, mesh._rotation.z, 0.0f, 0.0f, 1.0f);
        modelMatrix = GLKMatrix4Scale(modelMatrix, mesh._scale.x, mesh._scale.y, mesh._scale.z);
        GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(GLKMatrix4Multiply(_viewMatrix, modelMatrix)), NULL);
        [_programs[[NSString stringWithUTF8String:"fog"]] set3fvm:normalMatrix.m uniformName:"normalMatrix"];
        [_programs[[NSString stringWithUTF8String:"fog"]] set4fvm:modelMatrix.m uniformName:"model"];
        [mesh draw:_programs[[NSString stringWithUTF8String:"fog"]]];
    }
    
    /* Render the minimap */
    if (self.renderMinimap) {
        if (self._topCameraView) {
            [_programs[[NSString stringWithUTF8String:"passthrough"]] bind];
            glDisable(GL_DEPTH_TEST);
            [self._topCameraView draw:_programs[[NSString stringWithUTF8String:"fog"]]];
            glEnable(GL_DEPTH_TEST);
        }
    }
}

- (bool)loadShaders {
    GLProgram *basicProgram;
    NSMutableArray<Shader *> *shaders = [[NSMutableArray<Shader *> alloc] init];
    NSMutableArray<Attribute *> *attributes = [[NSMutableArray<Attribute *> alloc] init];
    
    Shader *vertexShader = [[Shader alloc] initWithFilename:"basic.vsh" shaderType:GL_VERTEX_SHADER];
    Shader *fragmentShader = [[Shader alloc] initWithFilename:"basic.fsh" shaderType:GL_FRAGMENT_SHADER];
    
    Attribute *position = [[Attribute alloc] initWithName:"aPos" index:GLKVertexAttribPosition];
    Attribute *normal = [[Attribute alloc] initWithName:"aNormal" index:GLKVertexAttribNormal];
    Attribute *texCoordIn = [[Attribute alloc] initWithName:"aTexCoords" index:GLKVertexAttribTexCoord0];
    
    [shaders addObject:vertexShader];
    [shaders addObject:fragmentShader];
    [attributes addObject:position];
    [attributes addObject:normal];
    [attributes addObject:texCoordIn];
    basicProgram = [[GLProgram alloc] initWithShaders:&shaders attributes:&attributes];
    
    if (!basicProgram) {
        return false;
    }
    
    [_programs setValue:basicProgram forKey:[NSString stringWithUTF8String:"basic"]];
    
    [shaders removeAllObjects];
    [attributes removeAllObjects];
    
    GLProgram *passthroughProgram;
    
    vertexShader = [[Shader alloc] initWithFilename:"passthrough.vsh" shaderType:GL_VERTEX_SHADER];
    fragmentShader = [[Shader alloc] initWithFilename:"passthrough.fsh" shaderType:GL_FRAGMENT_SHADER];
    
    [shaders addObject:vertexShader];
    [shaders addObject:fragmentShader];
    [attributes addObject:position];
    [attributes addObject:texCoordIn];
    passthroughProgram = [[GLProgram alloc] initWithShaders:&shaders attributes:&attributes];
    
    if (!passthroughProgram) {
        return false;
    }
    
    [_programs setValue:passthroughProgram forKey:[NSString stringWithUTF8String:"passthrough"]];
    
    [shaders removeAllObjects];
    [attributes removeAllObjects];
    
    GLProgram *fogProgram;
    
    vertexShader = [[Shader alloc] initWithFilename:"fog.vsh" shaderType:GL_VERTEX_SHADER];
    fragmentShader = [[Shader alloc] initWithFilename:"fog.fsh" shaderType:GL_FRAGMENT_SHADER];
    
    [shaders addObject:vertexShader];
    [shaders addObject:fragmentShader];
    [attributes addObject:position];
    [attributes addObject:normal];
    [attributes addObject:texCoordIn];
    fogProgram = [[GLProgram alloc] initWithShaders:&shaders attributes:&attributes];
    
    if (!fogProgram) {
        return false;
    }
    
    [_programs setValue:fogProgram forKey:[NSString stringWithUTF8String:"fog"]];
    
    return true;
}

- (void)setMeshes:(NSMutableArray<Mesh *> *)meshes {
    [self._meshes setArray:meshes];
}

- (void)addMesh:(Mesh *)mesh {
    [self._meshes addObject:mesh];
}

@end
