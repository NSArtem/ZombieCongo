//
//  ViewController.m
//  ZombieCongo
//
//  Created by Artem Abramov on 30/03/14.
//  Copyright (c) 2014 Artem Abramov. All rights reserved.
//

#import "ViewController.h"
#import "MainScene.h"

@implementation ViewController

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    SKView *skView = (SKView*)self.view;
    if (!skView.scene)
    {
#ifdef DEBUG
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
#endif
        SKScene *scene = [MainScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
}

@end
