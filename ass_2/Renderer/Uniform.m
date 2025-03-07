//
//  Uniform].m
//  ABC
//
//  Created by Choy on 2019-02-17.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Uniform.h"

@implementation Uniform

- (id)initWithName:(const char *)name location:(unsigned int)location {
    if (self == [super init]) {
        self._name = name;
        self._location = location;
    }
    return self;
}

@end
