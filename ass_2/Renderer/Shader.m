//
//  Shader.m
//  ABC
//
//  Created by Choy on 2019-02-17.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Shader.h"
#import "../Utility.h"

@implementation Shader

- (void)printInfoLog {
    GLsizei logLen = 0;
    GLsizei charsWritten = 0;
    GLchar *message;
    
    glGetShaderiv(self._id, GL_INFO_LOG_LENGTH, &logLen);
    
    if (logLen > 0) {
        message = (GLchar *)malloc(logLen);
        glGetShaderInfoLog(self._id, logLen, &charsWritten, message);
        [[Utility getInstance] log:message];
        free(message);
    }
}

- (id)initWithFilename:(const char *)filename shaderType:(GLenum)shaderType {
    if (self == [super init]) {
        self._id = glCreateShader(shaderType);
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:filename] ofType:nil inDirectory:@"Assets/shaders/"];
        const char *shaderSource = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] UTF8String];
        glShaderSource(self._id, 1, &shaderSource, NULL);
        [self compile];
    }
    return self;
}

- (void)compile {
    GLsizei success;
    
    glCompileShader(self._id);
    
    glGetShaderiv(self._id, GL_COMPILE_STATUS, &success);
    
    if (!success) {
        [self printInfoLog];
    }
}

@end
