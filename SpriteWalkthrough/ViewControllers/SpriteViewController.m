//
//  SpriteViewController.m
//  SpriteWalkthrough
//
//  Created by Luke McDonald and Angel Rodriguez 01 Aug 2013.
//  Copyright (c) 2013 Luke McDonald and Angel Rodriguez. All rights reserved.
//

#import "SpriteViewController.h"
#import "HelloScene.h"
#import "CDRampScene.h"

@interface SpriteViewController ()

@end

@implementation SpriteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	SKView *spriteView = (SKView *)self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    HelloScene *scene = [[HelloScene alloc] initWithSize:CGSizeMake(640, 1152)];
    SKView *spriteView = (SKView *)self.view;
    [spriteView presentScene:scene];
}

@end
