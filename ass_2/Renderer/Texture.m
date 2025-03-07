//
//  Texture.m
//  ass_2
//
//  Created by Choy on 2019-02-18.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Texture.h"
#import "../Utility.h"

@implementation Texture

- (id)initWithFilename:(const char *)filename {
    return [self initWithFilename:filename type:"texture_diffuse"];
}

- (id)initWithFilename:(const char *)filename type:(const char *)type {
    if (self == [super init]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:filename] ofType:nil inDirectory:@"Assets/textures/"];
        CGImageRef imageRef = [[UIImage imageWithContentsOfFile:filePath] CGImage];
        if (!imageRef) {
            [[Utility getInstance] log:"Failed to load the image."];
            self = nil;
            return self;
        }
        
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        
        GLubyte *spriteData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));
        
        CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(imageRef), kCGImageAlphaPremultipliedLast);
        CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), imageRef);
        CGContextRelease(spriteContext);
        
        GLuint texture;
        glGenTextures(1, &texture);
        glBindTexture(GL_TEXTURE_2D, texture);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
        
        free(spriteData);
        self._id = texture;
        self._type = type;
    }
    return self;
}

- (id)initWithTexture:(GLuint)texture {
    if (self == [super init]) {
        self._id = texture;
        self._type = "texture_diffuse";
    }
    return self;
}

- (void)cleanUp {
    if (self._id) {
        glDeleteTextures(1, &__id);
        self._id = 0;
    }
}

- (void)dealloc {
    [self cleanUp];
}

@end
