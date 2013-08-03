//
//  HelloScene.m
//  SpriteWalkthrough
//
//  Created by Luke McDonald and Angel Rodriguez on 01 Aug 2013.
//  Copyright (c) 2013 Luke McDonald and Angel Rodriguez. All rights reserved.
//

#import "HelloScene.h"
#import "CDRampScene.h"

//Hello scene will be changed to RampChamp scene

@interface HelloScene ()
@property BOOL contentCreated;
@end

@implementation HelloScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKNode *RampChampNode = [self childNodeWithName:@"RampChampNode"];
    if (RampChampNode != nil)
    {
        RampChampNode.name = nil;
        SKAction *moveUp = [SKAction moveByX:0 y:100.0 duration:0.5];
        SKAction *zoom = [SKAction scaleTo:2.0 duration:0.25];
        SKAction *pause = [SKAction waitForDuration:0.5];
        SKAction *fadeAway = [SKAction fadeOutWithDuration:0.5];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, remove]];
        [RampChampNode runAction:moveSequence completion:^{
            SKScene *rampScene = [[CDRampScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            [self.view presentScene:rampScene transition:doors];
        }];
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    SKSpriteNode *sprite = [self titleImageNode:@"RampChamp"];
    [self addChild:sprite];
    SKLabelNode *subTitleNode = [self newRampChampNode];
    subTitleNode.position = CGPointMake(CGRectGetMidX(self.frame), sprite.frame.origin.y-subTitleNode.frame.size.height-10);
    [self addChild:subTitleNode];
}
//make Hello node to Ramp Champ node to call upon image

- (SKLabelNode *)newRampChampNode
{
    SKLabelNode *rampChampNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    rampChampNode.name = @"RampChampNode";
    rampChampNode.text = @"Also on the App Store";
    rampChampNode.fontSize = 24;
    rampChampNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    return rampChampNode;
}

- (SKSpriteNode *)titleImageNode:(NSString *)spriteName
{
   // SKTexture *texture = [SKTexture textureWithImageNamed:spriteName];
    SKSpriteNode *titleImageNode = [SKSpriteNode spriteNodeWithImageNamed:spriteName];
    titleImageNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    titleImageNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:titleImageNode.frame.size];
    titleImageNode.physicsBody.dynamic = NO;
    
    return titleImageNode;
}

@end
