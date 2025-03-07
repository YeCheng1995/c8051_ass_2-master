//
//  DirectionalLight.m
//  ass_2
//
//  Created by Choy on 2019-02-18.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "DirectionalLight.h"

@implementation DirectionalLight

-  (id)init {
    if (self == [super init]) {
        self._direction = GLKVector3Make(-0.2f, -1.0f, -0.3f);
        self._ambient = GLKVector3Make(0.2f, 0.2f, 0.2f);
        self._diffuse = GLKVector3Make(0.5f, 0.5f, 0.5f);
        self._specular = GLKVector3Make(1.0f, 1.0f, 1.0f);
    }
    return self;
}

- (void)draw:(GLProgram *)program {
    [program set3fv:self._direction.v uniformName:"dirLight.direction"];
    [program set3fv:self._ambient.v uniformName:"dirLight.ambient"];
    [program set3fv:self._diffuse.v uniformName:"dirLight.diffuse"];
    [program set3fv:self._specular.v uniformName:"dirLight.specular"];
}

@end
