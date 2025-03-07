//
//  SpotLight.m
//  ass_2
//
//  Created by Choy on 2019-02-18.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "SpotLight.h"

@implementation SpotLight

-  (id)init {
    if (self == [super init]) {
        self._position = GLKVector3Make(0.0f, 0.0f, 0.0f);
        self._direction = GLKVector3Make(0.0f, 0.0f, 0.0f);
        self._ambient = GLKVector3Make(0.0f, 0.0f, 0.0f);
        self._diffuse = GLKVector3Make(0.0f, 0.0f, 0.0f);
        self._specular = GLKVector3Make(0.0f, 0.0f, 0.0f);
        self._constant = 1.0f;
        self._linear = 0.22f;
        self._quadratic = 0.0019f;
        self._cutOff = cosf(GLKMathDegreesToRadians(2.5f));
        self._outerCutOff = cosf(GLKMathDegreesToRadians(7.5f));
    }
    return self;
}

- (void)draw:(GLProgram *)program {
    [program set3fv:self._position.v uniformName:"spotLight.position"];
    [program set3fv:self._direction.v uniformName:"spotLight.direction"];
    [program set3fv:self._ambient.v uniformName:"spotLight.ambient"];
    [program set3fv:self._diffuse.v uniformName:"spotLight.diffuse"];
    [program set3fv:self._specular.v uniformName:"spotLight.specular"];
    [program set1f:self._constant uniformName:"spotLight.constant"];
    [program set1f:self._linear uniformName:"spotLight.linear"];
    [program set1f:self._quadratic uniformName:"spotLight.quadratic"];
    [program set1f:self._cutOff uniformName:"spotLight.cutOff"];
    [program set1f:self._outerCutOff uniformName:"spotLight.outerCutOff"];
}

@end
