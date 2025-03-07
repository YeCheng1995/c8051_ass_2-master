//
//  Primitives.h
//  Adapted from the code given by Borna Noureddin from BCIT
//  ass_2
//
//  Created by Choy on 2019-02-17.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mesh.h"

NS_ASSUME_NONNULL_BEGIN

@interface Primitives : NSObject

+ (id)getInstance;

- (Mesh *)triangle;
- (Mesh *)square;
- (Mesh *)cube;
- (Mesh *)sphere:(GLint)numSlices radius:(GLfloat)radius;

@end

NS_ASSUME_NONNULL_END
