//
//  Texture.h
//  ass_2
//
//  Created by Choy on 2019-02-18.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Texture : NSObject

@property (nonatomic) GLuint _id;
@property const char *_type;

- (id)initWithFilename:(const char *)filename;
- (id)initWithFilename:(const char *)filename type:(const char *)type;
- (id)initWithTexture:(GLuint)texture;
- (void)cleanUp;

@end

NS_ASSUME_NONNULL_END
