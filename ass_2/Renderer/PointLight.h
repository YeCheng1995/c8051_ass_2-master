//
//  PointLight.h
//  ass_2
//
//  Created by Choy on 2019-02-18.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Light.h"

NS_ASSUME_NONNULL_BEGIN

@interface PointLight : Light

@property GLKVector3 _position;
@property GLfloat _constant;
@property GLfloat _linear;
@property GLfloat _quadratic;

- (id)init;
- (void)draw:(GLProgram *)program;

@end

NS_ASSUME_NONNULL_END
