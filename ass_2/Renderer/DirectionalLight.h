//
//  DirectionalLight.h
//  ass_2
//
//  Created by Choy on 2019-02-18.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Light.h"

NS_ASSUME_NONNULL_BEGIN

@interface DirectionalLight : Light

@property GLKVector3 _direction;

- (id)init;
- (void)draw:(GLProgram *)program;

@end

NS_ASSUME_NONNULL_END
