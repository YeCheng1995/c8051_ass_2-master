//
//  ViewController.h
//  ass_2
//
//  Created by Choy on 2019-02-09.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Renderer/Renderer.h"
#import "MyMaze.h"

@interface ViewController : GLKViewController

- (IBAction)lightingPressed:(id)sender;
- (IBAction)flashlightPressed:(id)sender;
- (IBAction)fogPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *fogSlider;

@end

