//
//  Material.h
//  ass_2
//
//  Created by Choy on 2019-03-08.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Material : NSObject

@property GLKVector3 ambient;
@property GLKVector3 diffuse;
@property GLKVector3 specular;
@property GLfloat shininess;

@end

NS_ASSUME_NONNULL_END
