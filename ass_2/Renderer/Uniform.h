//
//  Uniform.h
//  ABC
//
//  Created by Choy on 2019-02-17.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Uniform : NSObject

@property const char *_name;
@property unsigned int _location;

- (id)initWithName:(const char *)name location:(unsigned int)location;

@end

NS_ASSUME_NONNULL_END
