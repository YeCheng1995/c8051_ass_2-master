//
//  Shader.h
//  ABC
//
//  Created by Choy on 2019-02-17.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Shader : NSObject

@property unsigned int _id;

- (id)initWithFilename:(const char *)filename shaderType:(GLenum)shaderType;

@end

NS_ASSUME_NONNULL_END
