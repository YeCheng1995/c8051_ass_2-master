//
//  Camera.h
//  Adapted from Joey DeVries LearnOpenGL tutorials found at
//  https://learnopengl.com/
//  ass_2
//
//  Created by Choy on 2019-02-17.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

extern const float YAW;
extern const float PITCH;
extern const float SPEED;
extern const float SENSITIVITY;
extern const float ZOOM;

@interface Camera : NSObject

/* Camera attributes */
@property GLKVector3 _position;
@property GLKVector3 _front;
@property GLKVector3 _up;
@property GLKVector3 _right;
@property GLKVector3 _worldUp;
/* Euler angles */
@property GLfloat _yaw;
@property GLfloat _pitch;
/* Camera options */
@property GLfloat _movementSpeed;
@property GLfloat _lookSensitivity;
@property GLfloat _zoom;

- (id)init;
- (id)initWithPosition:(GLKVector3)position;
- (id)initWithPosition:(GLKVector3)position up:(GLKVector3)up;
- (id)initWithPosition:(GLKVector3)position up:(GLKVector3)up yaw:(GLfloat)yaw;
- (id)initWithPosition:(GLKVector3)position up:(GLKVector3)up yaw:(GLfloat)yaw pitch:(GLfloat)pitch;
- (id)initWithPosition:(GLfloat)posX posY:(GLfloat)posY posZ:(GLfloat)posZ upX:(GLfloat)upX upY:(GLfloat)upY upZ:(GLfloat)upZ yaw:(GLfloat)yaw pitch:(GLfloat)pitch;
- (void)processMove:(bool)movingForward deltaTime:(float)deltaTime;
- (void)processLook:(float)x;
- (void)update;
- (GLKMatrix4)getViewMatrix;

@end

NS_ASSUME_NONNULL_END
