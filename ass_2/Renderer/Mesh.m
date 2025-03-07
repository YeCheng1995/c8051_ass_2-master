//
//  Mesh.m
//  Adapted from Joey DeVries LearnOpenGL tutorials found at
//  https://learnopengl.com/
//  ass_2
//
//  Created by Choy on 2019-02-17.
//

#import "Mesh.h"
#import <OpenGLES/ES2/glext.h>

@interface Mesh() {
    GLuint _vbo[3];
    GLuint _vao;
    GLuint _ebo;
}
@end

@implementation Mesh

- (id)initWithVertexData:(GLfloat *)vertexData numVertices:(GLsizei)numVertices normals:(GLfloat *)normals uvs:(GLfloat *)uvs numUvs:(GLsizei)numUvs indices:(GLuint *)indices numIndices:(GLsizei)numIndices {
    if (self == [super init]) {
        self._numVertices = numVertices;
        self._numIndices = numIndices;
        self._numUvs = numUvs;
        self._vertices = malloc(sizeof(GLfloat) * numVertices);
        if (vertexData != NULL) {
            memcpy(self._vertices, vertexData, sizeof(GLfloat) * numVertices);
        }
        self._indices = malloc(sizeof(GLuint) * numIndices);
        if (indices != NULL) {
            memcpy(self._indices, indices, sizeof(GLuint) * numIndices);
        }
        self._normals = malloc(sizeof(GLfloat) * numVertices);
        if (normals != NULL) {
            memcpy(self._normals, normals, sizeof(GLfloat) * numVertices);
        }
        self._uvs = malloc(sizeof(GLfloat) * numUvs);
        if (self._uvs != NULL) {
            memcpy(self._uvs, uvs, sizeof(GLfloat) * numUvs);
        }
        
        self._position = GLKVector3Make(0.0f, 0.0f, 0.0f);
        self._rotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
        self._scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
        self._textures = [[NSMutableArray<Texture *> alloc] init];
        self._material = [[Material alloc] init];
        
        [self setup];
    }
    return self;
}

- (void)cleanUp {
    if (_vao) {
        glDeleteVertexArraysOES(1, &_vao);
        _vao = 0;
    }
    
    if (_vbo) {
        glDeleteBuffers(3, _vbo);
        _vbo[0] = 0;
        _vbo[1] = 0;
        _vbo[2] = 0;
    }
    
    if (_ebo) {
        glDeleteBuffers(1, &_ebo);
        _ebo = 0;
    }
    
    if (self._vertices) {
        free(self._vertices);
    }
    
    if (self._normals) {
        free(self._normals);
    }
    
    if (self._uvs) {
        free(self._uvs);
    }
    
    if (self._indices) {
        free(self._indices);
    }
}

- (void)dealloc {
    [self cleanUp];
}

- (void)setup {
    glGenVertexArraysOES(1, &_vao);
    glGenBuffers(3, _vbo);
    glGenBuffers(1, &_ebo);
    
    glBindVertexArrayOES(_vao);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vbo[0]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 3 * self._numVertices, self._vertices, GL_STATIC_DRAW);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (const GLvoid *)0);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vbo[1]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 3 * self._numVertices, self._normals, GL_STATIC_DRAW
                 );
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (const GLvoid *)0);
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vbo[2]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 2 * self._numUvs, self._uvs, GL_STATIC_DRAW);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(GLfloat), (const GLvoid *)0);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ebo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLuint) * self._numIndices, self._indices, GL_STATIC_DRAW);
    
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArrayOES(0);
}

- (void)draw:(GLProgram *)program {
    unsigned int diffuseNr = 1;
    unsigned int specularNr = 1;
    unsigned int normalNr = 1;
    unsigned int heightNr = 1;
    
    [program set1f:self._material.shininess uniformName:"material.shininess"];
    
    for (unsigned int i = 0; i < [self._textures count]; i++) {
        glActiveTexture(GL_TEXTURE0 + i);
        unsigned int number = 0;
        const char *name = self._textures[i]._type;
        if (strncmp(name, "texture_diffuse", 64)) {
            number = diffuseNr++;
        } else if (strncmp(name, "texture_specular", 64)) {
            number = specularNr++;
        } else if (strncmp(name, "texture_normal", 64)) {
            number = normalNr++;
        } else if (strncmp(name, "texture_height", 64)) {
            number = heightNr++;
        }
        [program set1i:i uniformName:[[NSString stringWithFormat:@"%s%u", name, number] UTF8String]];
        glBindTexture(GL_TEXTURE_2D, self._textures[i]._id);
    }
    
    glBindVertexArrayOES(_vao);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ebo);
    glDrawElements(GL_TRIANGLES, self._numIndices, GL_UNSIGNED_INT, 0);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, 0);
}

- (void)addTexture:(Texture *)texture {
    [self._textures addObject:texture];
}

@end
