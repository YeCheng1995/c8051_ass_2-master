//
//  Attribute.h
//  ABC
//
//  Created by Choy on 2019-02-17.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Attribute : NSObject

@property const char *_name;
@property unsigned int _index;

- (id)initWithName:(const char *)name index:(unsigned int)index;

@end

NS_ASSUME_NONNULL_END
