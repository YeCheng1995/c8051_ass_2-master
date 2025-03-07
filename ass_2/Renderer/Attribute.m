//
//  Attribute.m
//  ABC
//
//  Created by Choy on 2019-02-17.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Attribute.h"

@implementation Attribute

- (id)initWithName:(const char *)name index:(unsigned int)index {
    if (self == [super init]) {
        self._name = name;
        self._index = index;
    }
    return self;
}

@end
