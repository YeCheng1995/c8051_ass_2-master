//
//  GLProgram.m
//  ABC
//
//  Created by Choy on 2019-02-17.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "GLProgram.h"
#import <OpenGLES/ES2/glext.h>

#import "Uniform.h"
#import "../Utility.h"

@interface GLProgram() {
    // A reference to the program id on the GPU
    // GLuint _programId;
    NSMutableArray<Uniform *> *_uniforms;
}

@end

@implementation GLProgram

- (void)printInfoLog {
    GLsizei logLen = 0;
    GLsizei charsWritten = 0;
    GLchar *message;
    
    glGetProgramiv(_programId, GL_INFO_LOG_LENGTH, &logLen);
    
    if (logLen > 0) {
        message = (GLchar *)malloc(logLen);
        glGetProgramInfoLog(_programId, logLen, &charsWritten, message);
        [[Utility getInstance] log:message];
        free(message);
    }
}

- (id)initWithShaders:(NSMutableArray<Shader *> *__autoreleasing *)shaders attributes:(NSMutableArray<Attribute *> **)attributes {
    if (self == [super init]) {
        _programId = glCreateProgram();
        for (Shader *shader in *shaders) {
            glAttachShader(_programId, shader._id);
        }
        for (Attribute *attribute in *attributes) {
            glBindAttribLocation(_programId, attribute._index, attribute._name);
        }
        [self compile];
        for (Shader *shader in *shaders) {
            glDetachShader(_programId, shader._id);
            glDeleteShader(shader._id);
        }
        _uniforms = [[NSMutableArray<Uniform *> alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_programId) {
        glDeleteProgram(_programId);
    }
}

- (void)compile {
    GLsizei success;
    
    glLinkProgram(_programId);
    
    glGetProgramiv(_programId, GL_LINK_STATUS, &success);
    
    if (!success) {
        [self printInfoLog];
    }
}

- (void)bind {
    glUseProgram(_programId);
}

- (void)unbind {
    glUseProgram(0);
}

- (GLuint)getUniform:(const char *)name {
    for (Uniform *uniform in _uniforms) {
        if (uniform._name == name) {
            return uniform._location;
        }
    }
    
    GLuint location = glGetUniformLocation(_programId, name);
    Uniform *uniform = [[Uniform alloc] initWithName:name location:location];
    [_uniforms addObject:uniform];
    return [_uniforms lastObject]._location;
}

- (void)set1i:(int)value uniformName:(const char *)name {
    glUniform1i([self getUniform:name], value);
}

- (void)set1f:(float)value uniformName:(const char *)name {
    glUniform1f([self getUniform:name], value);
}

- (void)set2f:(float)f1 f2:(float)f2 uniformName:(const char *)name {
    glUniform2f([self getUniform:name], f1, f2);
}

- (void)set3f:(float)f1 f2:(float)f2 f3:(float)f3 uniformName:(const char *)name {
    glUniform3f([self getUniform:name], f1, f2, f3);
}

- (void)set4f:(float)f1 f2:(float)f2 f3:(float)f3 f4:(float)f4 uniformName:(const char *)name {
    glUniform4f([self getUniform:name], f1, f2, f3, f4);
}

- (void)set3fv:(GLfloat *)value uniformName:(const char *)name {
    glUniform3fv([self getUniform:name], 1, value);
}

- (void)set4fv:(GLfloat *)value uniformName:(const char *)name {
    glUniform4fv([self getUniform:name], 1, value);
}

- (void)set3fvm:(GLfloat *)value uniformName:(const char *)name {
    glUniformMatrix3fv([self getUniform:name], 1, 0, value);
}

- (void)set4fvm:(GLfloat *)value uniformName:(const char *)name {
    glUniformMatrix4fv([self getUniform:name], 1, 0, value);
}

@end
