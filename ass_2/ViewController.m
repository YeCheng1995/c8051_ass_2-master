//
//  ViewController.m
//  ass_2
//
//  Created by Choy on 2019-02-09.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "ViewController.h"
#import "Renderer/Primitives.h"
#import "Renderer/Texture.h"

const int TICKS_PER_SECOND = 25;
const int SKIP_TICKS = 1000 / TICKS_PER_SECOND;
const int MAX_FRAMESKIP = 5;

@interface ViewController () {
    // The time for the previous frame
    NSDate *lastTime;
    // The time between each frame in seconds
    NSTimeInterval deltaTime;
    
    Renderer *renderer;
    
    UIPanGestureRecognizer *singleFingerPan;
    CGPoint singleFingerPanPosition;
    UITapGestureRecognizer *singleFingerDoubleTap;
    UITapGestureRecognizer *twoFingerDoubleTap;
    UILongPressGestureRecognizer *longPress;
    
    bool fogEnabled;
    bool nightTimeEnabled;
    bool flashlightEnabled;
    
    bool moving;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    lastTime = [NSDate date];
    
    GLKView *view = (GLKView *)self.view;
    
    renderer = [[Renderer alloc] init];
    
    [renderer initWithView:view];
    
    [self loadResources];
    
    fogEnabled = false;
    nightTimeEnabled = false;
    flashlightEnabled = false;
    moving = false;
    
    singleFingerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerPan:)];
    [self.view addGestureRecognizer:singleFingerPan];
    singleFingerPanPosition = CGPointZero;
    singleFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerDoubleTap:)];
    singleFingerDoubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:singleFingerDoubleTap];
    twoFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerDoubleTap:)];
    twoFingerDoubleTap.numberOfTapsRequired = 2;
    twoFingerDoubleTap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:twoFingerDoubleTap];
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:longPress];
    
    [self.fogSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)dealloc {
    [renderer cleanUp];
    
    if ([EAGLContext currentContext] == renderer._context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [renderer cleanUp];
        
        if ([EAGLContext currentContext] == renderer._context) {
            [EAGLContext setCurrentContext:nil];
        }
    }
}

- (void)update {
    deltaTime = [lastTime timeIntervalSinceNow];
    lastTime = [NSDate date];
    
    if (moving) {
        [renderer._camera processMove:false deltaTime:deltaTime];
    }
    
    [renderer update:deltaTime];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [renderer render:deltaTime drawInRect:rect];
}

- (void)loadResources {
    Texture *diffuse = [[Texture alloc] initWithFilename:"container2.png"];
    Texture *specular = [[Texture alloc] initWithFilename:"container2_specular.png" type:"texture_specular"];
    Texture *floorTexture = [[Texture alloc] initWithFilename:"floor.jpg"];
    Texture *northTexture = [[Texture alloc] initWithFilename:"north.jpg"];
    Texture *eastTexture = [[Texture alloc] initWithFilename:"east.jpg"];
    Texture *southTexture = [[Texture alloc] initWithFilename:"south.jpg"];
    Texture *westTexture = [[Texture alloc] initWithFilename:"west.jpg"];
    
    Mesh *cube = [[Primitives getInstance]
                  //square
                  cube
                  // sphere:50 radius:1
                  ];
    cube._scale = GLKVector3Make(0.05f, 0.05f, 0.05f);
    [cube addTexture:diffuse];
    [cube addTexture:specular];
    renderer._cube = cube;
    
    Mesh *player = [[Primitives getInstance] cube];
    player._scale = GLKVector3Make(0.2f, 0.2f, 0.2f);
    [cube addTexture:diffuse];
    renderer._player = player;
    
    Mesh *topCameraView = [[Primitives getInstance] square];
    topCameraView._scale = GLKVector3Make(0.1f, 0.1f, 0.1f);
    Texture *texture = [[Texture alloc] initWithTexture:renderer.texture];
    [topCameraView addTexture:texture];
    renderer._topCameraView = topCameraView;
    
    MyMaze *maze = [[MyMaze alloc] init];
    
    for (int row = 0; row < [maze numRows]; row++) {
        for (int col = 0; col < [maze numCols]; col++) {
            // floor
            // Always create a floor
            Mesh *floorMesh = [[Primitives getInstance] square];
            floorMesh._position = GLKVector3Make(col, -0.5f, row);
            floorMesh._rotation = GLKVector3Make(M_PI * 1.5f, 0, 0);
            [floorMesh addTexture:floorTexture];
            [renderer addMesh:floorMesh];
            
            // north wall
            if ([maze hasNorthWall:row col:col]) {
                Mesh *northMesh = [[Primitives getInstance] square];
                northMesh._position = GLKVector3Make(col, 0.0f, row - 0.49f);
                [northMesh addTexture:northTexture];
                [renderer addMesh:northMesh];
            }
            
            // east wall
            if ([maze hasEastWall:row col:col]) {
                Mesh *eastMesh = [[Primitives getInstance] square];
                eastMesh._position = GLKVector3Make(col + 0.49f, 0.0f, row);
                eastMesh._rotation = GLKVector3Make(0.0f, M_PI * 1.5f, 0.0f);
                [eastMesh addTexture:eastTexture];
                [renderer addMesh:eastMesh];
            }
            
            // south wall
            if ([maze hasSouthWall:row col:col]) {
                Mesh *southMesh = [[Primitives getInstance] square];
                southMesh._position = GLKVector3Make(col, 0.0f, row + 0.49f);
                southMesh._rotation = GLKVector3Make(0.0f, M_PI, 0.0f);
                [southMesh addTexture:southTexture];
                [renderer addMesh:southMesh];
            }
            
            // west wall
            if ([maze hasWestWall:row col:col]) {
                Mesh *westMesh = [[Primitives getInstance] square];
                westMesh._position = GLKVector3Make(col - 0.49f, 0.0f, row);
                westMesh._rotation = GLKVector3Make(0.0f, M_PI * 0.5f, 0.0f);
                [westMesh addTexture:westTexture];
                [renderer addMesh:westMesh];
            }
        }
    }
}

- (void)handleSingleFingerPan:(UIPanGestureRecognizer *)panRecognizer {
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        singleFingerPanPosition = [panRecognizer locationInView:self.view];
    } else if (panRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint newPosition = [panRecognizer locationInView:self.view];
        CGPoint offset = CGPointMake(newPosition.x - singleFingerPanPosition.x, newPosition.y - singleFingerPanPosition.y);
       
        [renderer._camera processLook:offset.x];
        singleFingerPanPosition = newPosition;
    }
}

- (void)handleSingleFingerDoubleTap:(UITapGestureRecognizer *)tapRecognizer {
    renderer._camera._position = GLKVector3Make(0.0f, 0.0f, 0.0f);
    renderer._camera._yaw = YAW;
    [renderer._camera update];
}

- (void)handleTwoFingerDoubleTap:(UITapGestureRecognizer *)tapRecognizer {
    renderer.renderMinimap = !renderer.renderMinimap;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer {
    if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
        moving = true;
    } else if (longPressRecognizer.state == UIGestureRecognizerStateEnded) {
        moving = false;
    }
}

- (IBAction)lightingPressed:(id)sender {
    nightTimeEnabled = !nightTimeEnabled;
    if (nightTimeEnabled) {
        renderer._dirLight._ambient = GLKVector3Make(0.05f, 0.05f, 0.05f);
    } else {
        renderer._dirLight._ambient = GLKVector3Make(0.5f, 0.5f, 0.5f);
    }
}

- (IBAction)flashlightPressed:(id)sender {
    flashlightEnabled = !flashlightEnabled;
    if (flashlightEnabled) {
        renderer._spotLight._diffuse = GLKVector3Make(1.0f, 1.0f, 1.0f);
        renderer._spotLight._specular = GLKVector3Make(1.0f, 1.0f, 1.0f);
    } else {
        renderer._spotLight._diffuse = GLKVector3Make(0.0f, 0.0f, 0.0f);
        renderer._spotLight._specular = GLKVector3Make(0.0f, 0.0f, 0.0f);
    }
}

- (IBAction)fogPressed:(id)sender {
    fogEnabled = !fogEnabled;
    
    if (fogEnabled) {
        self.fogSlider.enabled = true;
        renderer.fogStart = 1.0f;
    } else {
        self.fogSlider.enabled = false;
        renderer.fogStart = 10.0f;
    }
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    renderer.fogStart = sender.value;
}
@end
