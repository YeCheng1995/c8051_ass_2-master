//
//  Utility.m
//  ass_2
//
//  Created by Choy on 2019-02-16.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (id)getInstance {
    static Utility *INSTANCE = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        INSTANCE = [[self alloc] init];
    });
    return INSTANCE;
}

- (id)init {
    if (self = [super init]) {
        // Initialize any Utility variables here
    }
    return self;
}

- (void)log:(const char *)str {
    NSLog(@"%s", str);
}

@end
