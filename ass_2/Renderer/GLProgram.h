//
//  GLProgram.h
//  ABC
//
//  Created by Choy on 2019-02-17.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "Shader.h"
#import "Attribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLProgram : NSObject

@property GLuint programId;

- (id)initWithShaders:(NSMutableArray<Shader *> **)shaders attributes:(NSMutableArray<Attribute *> **)attributes;
- (void)bind;
- (void)unbind;
- (GLuint)getUniform:(const char *)name;
- (void)set1i:(int)value uniformName:(const char *)name;
- (void)set1f:(float)value uniformName:(const char *)name;
- (void)set2f:(float)f1 f2:(float)f2 uniformName:(const char *)name;
- (void)set3f:(float)f1 f2:(float)f2 f3:(float)f3 uniformName:(const char *)name;
- (void)set4f:(float)f1 f2:(float)f2 f3:(float)f3 f4:(float)f4 uniformName:(const char *)name;
- (void)set3fv:(GLfloat *)vector uniformName:(const char *)name;
- (void)set4fv:(GLfloat *)vector uniformName:(const char *)name;
- (void)set3fvm:(GLfloat *)matrix uniformName:(const char *)name;
- (void)set4fvm:(GLfloat *)matrix uniformName:(const char *)name;

@end

NS_ASSUME_NONNULL_END
