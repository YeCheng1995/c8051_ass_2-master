//
//  Utility.h
//  ass_2
//
//  Created by Choy on 2019-02-16.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utility : NSObject

+ (id)getInstance;

- (void)log:(const char *)str;

@end

NS_ASSUME_NONNULL_END
