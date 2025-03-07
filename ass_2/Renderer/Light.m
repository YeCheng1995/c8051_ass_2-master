//
//  Light.m
//  ass_2
//
//  Created by Choy on 2019-02-18.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Light.h"

@implementation Light

-  (id)init {
    if (self == [super init]) {
        self._ambient = GLKVector3Make(0.05f, 0.05f, 0.05f);
        self._diffuse = GLKVector3Make(0.5f, 0.5f, 0.5f);
        self._specular = GLKVector3Make(0.5f, 0.5f, 0.5f);
    }
    return self;
}

- (void)draw:(GLProgram *)program {
    [program set3fv:self._ambient.v uniformName:"light.ambient"];
    [program set3fv:self._diffuse.v uniformName:"light.diffuse"];
    [program set3fv:self._specular.v uniformName:"light.specular"];
}

@end
