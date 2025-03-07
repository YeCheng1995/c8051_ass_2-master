//
//  Light.h
//  ass_2
//
//  Created by Choy on 2019-02-18.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "GLProgram.h"

NS_ASSUME_NONNULL_BEGIN

@interface Light : NSObject

@property GLKVector3 _ambient;
@property GLKVector3 _diffuse;
@property GLKVector3 _specular;

- (id)init;
- (void)draw:(GLProgram *)program;

@end

NS_ASSUME_NONNULL_END
