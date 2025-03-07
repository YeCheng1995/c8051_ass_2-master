//
//  Material.m
//  ass_2
//
//  Created by Choy on 2019-03-08.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Material.h"

@implementation Material

- (id)init {
    if (self == [super init]) {
        self.ambient = GLKVector3Make(0.0f, 0.0f, 0.0f);
        self.diffuse = GLKVector3Make(0.0f, 0.0f, 0.0f);
        self.specular = GLKVector3Make(1.0f, 1.0f, 1.0f);
        self.shininess = 4.0f;
    }
    return self;
}

@end
