//
//  PointLight.m
//  ass_2
//
//  Created by Choy on 2019-02-18.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "PointLight.h"

@implementation PointLight

-  (id)init {
    if (self == [super init]) {
        self._position = GLKVector3Make(0.0f, 0.0f, 0.0f);
        self._ambient = GLKVector3Make(0.05f, 0.05f, 0.05f);
        self._diffuse = GLKVector3Make(0.8f, 0.8f, 0.8f);
        self._specular = GLKVector3Make(1.0f, 1.0f, 1.0f);
        self._constant = 1.0f;
        self._linear = 0.09f;
        self._quadratic = 0.032f;
    }
    return self;
}

- (void)draw:(GLProgram *)program {
    [program set3fv:self._position.v uniformName:"pointLight.position"];
    [program set3fv:self._ambient.v uniformName:"pointLight.ambient"];
    [program set3fv:self._diffuse.v uniformName:"pointLight.diffuse"];
    [program set3fv:self._specular.v uniformName:"pointLight.specular"];
    [program set1f:self._constant uniformName:"pointLight.constant"];
    [program set1f:self._linear uniformName:"pointLight.linear"];
    [program set1f:self._quadratic uniformName:"pointLight.quadratic"];
}

@end
