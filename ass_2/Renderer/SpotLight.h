//
//  SpotLight.h
//  ass_2
//
//  Created by Choy on 2019-02-18.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Light.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpotLight : Light

@property GLKVector3 _position;
@property GLKVector3 _direction;
@property GLfloat _constant;
@property GLfloat _linear;
@property GLfloat _quadratic;
@property GLfloat _cutOff;
@property GLfloat _outerCutOff;

- (id)init;
- (void)draw:(GLProgram *)program;

@end

NS_ASSUME_NONNULL_END
