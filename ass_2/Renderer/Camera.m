//
//  Camera.m
//  Adapted from Joey DeVries LearnOpenGL tutorials found at
//  https://learnopengl.com/
//  ass_2
//
//  Created by Choy on 2019-02-17.
//

#import "Camera.h"

const float YAW = 90.0f;
const float PITCH = 0.0f;
const float SPEED = 0.5f;
const float SENSITIVITY = 0.1f;
const float ZOOM = 45.0f;

@implementation Camera

- (id)init {
    return [self initWithPosition:GLKVector3Make(0.0f, 0.0f, 0.0f) up:GLKVector3Make(0.0f, 1.0f, 0.0f) yaw:YAW pitch:PITCH];
}

- (id)initWithPosition:(GLKVector3)position {
    return [self initWithPosition:position up:GLKVector3Make(0.0f, 1.0f, 0.0f) yaw:YAW pitch:PITCH];
}

- (id)initWithPosition:(GLKVector3)position up:(GLKVector3)up {
    return [self initWithPosition:position up:up yaw:YAW pitch:PITCH];
}

- (id)initWithPosition:(GLKVector3)position up:(GLKVector3)up yaw:(GLfloat)yaw {
    return [self initWithPosition:position up:up yaw:yaw pitch:PITCH];
}

- (id)initWithPosition:(GLKVector3)position up:(GLKVector3)up yaw:(GLfloat)yaw pitch:(GLfloat)pitch {
    return [self initWithPosition:position.x posY:position.y posZ:position.z upX:up.x upY:up.y upZ:up.z yaw:yaw pitch:pitch];
}

- (id)initWithPosition:(GLfloat)posX posY:(GLfloat)posY posZ:(GLfloat)posZ upX:(GLfloat)upX upY:(GLfloat)upY upZ:(GLfloat)upZ yaw:(GLfloat)yaw pitch:(GLfloat)pitch {
    if (self == [super init]) {
        self._position = GLKVector3Make(posX, posY, posZ);
        self._up = GLKVector3Make(upX, upY, upZ);
        self._front = GLKVector3Make(0.0f, 0.0f, -1.0f);
        self._worldUp = self._up;
        self._yaw = yaw;
        self._pitch = pitch;
        self._zoom = ZOOM;
        self._movementSpeed = SPEED;
        self._lookSensitivity = SENSITIVITY;
        
        [self update];
    }
    return self;
}

- (void)processMove:(bool)movingForward deltaTime:(float)deltaTime {
    float velocity = self._movementSpeed * deltaTime;
    
    if (movingForward) {
        self._position = GLKVector3Add(self._position, GLKVector3MultiplyScalar(self._front, velocity));
    } else {
        self._position = GLKVector3Subtract(self._position, GLKVector3MultiplyScalar(self._front, velocity));
    }
}

- (void)processLook:(float)x {
    x *= self._lookSensitivity;
    
    self._yaw += x;
    
    [self update];
}

- (void)update {
    GLKVector3 front;
    front.x = cosf(GLKMathDegreesToRadians(self._yaw)) * cosf(GLKMathDegreesToRadians(self._pitch));
    front.y = sinf(GLKMathDegreesToRadians(self._pitch));
    front.z = sinf(GLKMathDegreesToRadians(self._yaw)) * cosf(GLKMathDegreesToRadians(self._pitch));
    self._front = GLKVector3Normalize(front);
    self._right = GLKVector3Normalize(GLKVector3CrossProduct(self._front, self._worldUp));
    self._up = GLKVector3Normalize(GLKVector3CrossProduct(self._right, self._front));
}

- (GLKMatrix4)getViewMatrix {
    return GLKMatrix4MakeLookAt(self._position.x, self._position.y, self._position.z, self._position.x + self._front.x, self._position.y + self._front.y, self._position.z + self._front.z, self._up.x, self._up.y, self._up.z);
}

@end
