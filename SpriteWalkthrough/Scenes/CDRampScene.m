//
//  CDRampScene.m
//  SpriteWalkthrough
//
//  Created by Luke McDonald and Angel Rodriguez on 01 Aug 2013.
//  Copyright (c) 2013 Luke McDonald and Angel Rodriguez. All rights reserved.
//

#import "CDRampScene.h"

@interface CDRampScene ()
@property (strong, nonatomic) SKSpriteNode *milkGlass;
@property (assign, nonatomic) NSUInteger lastSelectedIndex;
@property (assign, nonatomic) CGPoint lastPosition;
@property (assign, nonatomic) SKSpriteNode *rampNode;
@property (assign, nonatomic) SKSpriteNode *areaNode;
@property (assign, nonatomic) SKSpriteNode *headerNode;
@end

@implementation CDRampScene


- (void)setup
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    // self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    SKSpriteNode *milkCup = [self newSprite:@"Milk-Glass"];
    SKSpriteNode *rampNode = [self newSprite:@"Ramp"];
    SKSpriteNode *areaNode = [self newSprite:@"Area"];
    SKSpriteNode *headerNode = [self newSprite:@"Header"];
    
    // CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    
    rampNode.position = CGPointMake(0.0f, 150.0f);
    [self addChild:rampNode];
    rampNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rampNode.frame.size];
    [rampNode.physicsBody setDynamic:NO];
    //rampNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rampNode.frame.size.width];
//    self.rampNode = Ramp; =
    areaNode.position = CGPointMake(150.0f, 400.0f);
    [self addChild:areaNode];
    areaNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:areaNode.frame.size];
    [areaNode.physicsBody setDynamic:NO];
//    self.areaNode = Area;
    headerNode.position = CGPointMake(400.0f, 500.0f);
    [self addChild:headerNode];
    headerNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:headerNode.frame.size];
    [areaNode.physicsBody setDynamic:NO];
//    self.headerNode = Header;
    milkCup.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:milkCup];
    self.milkGlass = milkCup;
    
//    SKAction *makeRocks = [SKAction sequence:@[[SKAction performSelector:@selector(addRock) onTarget:self],
//                                               [SKAction waitForDuration:0.50 withRange:2.15]]];
//    [self runAction:[SKAction repeatActionForever:makeRocks]];
    
    SKAction *moveGlass = [SKAction sequence:@[[SKAction performSelector:@selector(newPos) onTarget:self], [SKAction waitForDuration:2.0f]]];
    
    [self.milkGlass runAction:[SKAction repeatActionForever:moveGlass]];
}

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        [self setup];
    }
    
    return self;
}

- (void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"Cookie" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
        {
            [node removeFromParent];
        }
    }];
}

- (SKSpriteNode *)newSprite:(NSString *)spriteName
{
    //    SKSpriteNode *hull = [SKSpriteNode spriteNodeWithImageNamed:spriteName];
    SKTexture *texture = [SKTexture textureWithImageNamed:spriteName];              // width, height
    SKSpriteNode *hull = [SKSpriteNode spriteNodeWithTexture:texture size:CGSizeMake(150.0f, 190.0f)];
    hull.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(hull.size.width/3, hull.size.height/3)];
    hull.physicsBody.dynamic = NO;
    
    //Created a Call action for the Dictionary
    return hull;
}

- (void)newPos
{
    if (CGPointEqualToPoint(self.lastPosition, self.milkGlass.position)) {
        self.milkGlass.position = self.lastPosition;
        
    }

    NSDictionary *dict = [self createPositionDict];
    if (dict) {
        CGFloat x = 0.0f;
        CGFloat y = 0.0f;
        CGFloat zoom = 1.0f;
        NSNumber *xValue = nil;
        NSNumber *yValue = nil;
        
        
        if ((NSNumber *)dict[@"X"] > [NSNumber numberWithFloat:0.0f]) {
            xValue = (NSNumber *)dict[@"X"];
            x = [xValue floatValue];
        }
        else if ((NSNumber *)dict[@"X"] < [NSNumber numberWithFloat:0.0f]) {
            x = [xValue floatValue] + [xValue floatValue];
            
        }
        if ((NSNumber *)dict[@"Y"] > [NSNumber numberWithFloat:0.0f]) {
            yValue = (NSNumber *)dict[@"Y"];
            y = [yValue floatValue];
        }
        else if ((NSNumber *)dict[@"Y"] < [NSNumber numberWithFloat:0.0f]) {
            y = [yValue floatValue] - [yValue floatValue];
        }
        
        if (dict[@"zoomLevel"]) {
            NSNumber *zoomValue = (NSNumber *)dict[@"zoomLevel"];
            zoom = [zoomValue floatValue];
        }
        
        
        SKAction *movePositionAction = [SKAction moveByX:x y:y duration:1.5];
        SKAction *zoomAction = [SKAction scaleTo:zoom duration:1.25];
        SKAction *groupActions = [SKAction group:@[[SKAction waitForDuration:1.0f],movePositionAction, zoomAction]];
        
        
        [self.milkGlass runAction:groupActions];
        self.lastPosition = self.milkGlass.position;
        //    }];
        //    SKAction *group2 = [SKAction group:@[executeBlock, [SKAction waitForDuration:0.1f]]];
        //    [hull runAction:[SKAction repeatActionForever: group2]];
    }
    else
    {
        [self newPos];
    }
    
}

- (SKSpriteNode *)newLight
{
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor whiteColor] size:CGSizeMake(8, 8)];
    SKAction *blink = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.25],
                                           [SKAction fadeInWithDuration:0.25]]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [light runAction:blinkForever];
    return light;
}

//Created a Dictionary to Use for the Call action

- (NSDictionary *)createPositionDict
{
    NSDictionary *selectedDictionary = [NSDictionary new];
    NSDictionary *dictOne = @{@"X": [NSNumber numberWithFloat:150.0f], @"Y": [NSNumber numberWithFloat:200.0f], @"zoomLevel": [NSNumber numberWithFloat:0.85f]};
    NSDictionary *dictTwo = @{@"X": [NSNumber numberWithFloat:-150.0f], @"Y": [NSNumber numberWithFloat:-200.0f], @"zoomLevel": [NSNumber numberWithFloat:0.70f]};
    NSDictionary *dictThree = @{@"X": [NSNumber numberWithFloat:-150.0f], @"Y": [NSNumber numberWithFloat:200.0f], @"zoomLevel": [NSNumber numberWithFloat:0.55f]};
    NSDictionary *dictFour = @{@"X": [NSNumber numberWithFloat:150.0f], @"Y": [NSNumber numberWithFloat:-200.0f], @"zoomLevel": [NSNumber numberWithFloat:1.0f]};
    NSMutableArray *positionArray = [NSMutableArray arrayWithObjects:dictOne, dictTwo, dictThree, dictFour, nil];
    NSUInteger randomIndex = arc4random() % [positionArray count];
    
    selectedDictionary = [positionArray objectAtIndex:randomIndex];
    
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    CGFloat zoom = 1.0f;
    
    if (selectedDictionary[@"X"]) {
        NSNumber *xValue = (NSNumber *)selectedDictionary[@"X"];
        x = [xValue floatValue];
    }
    
    if (selectedDictionary[@"Y"]) {
        NSNumber *yValue = (NSNumber *)selectedDictionary[@"Y"];
        y = [yValue floatValue];
    }
    
    if (selectedDictionary[@"zoomLevel"]) {
        NSNumber *zoomValue = (NSNumber *)selectedDictionary[@"zoomLevel"];
        zoom = [zoomValue floatValue];
    }
    NSLog(@"milk Glass frame : %@", NSStringFromCGRect(self.milkGlass.frame));
    CGRect rect = self.milkGlass.frame;
    rect.origin.x = rect.origin.x+x;
    rect.origin.y = rect.origin.y+y;
    NSLog(@"Test frame : %@", NSStringFromCGRect(rect));
    NSLog(@"The window frame : %@", NSStringFromCGRect(self.frame));
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    NSLog(@"The screenRect frame : %@", NSStringFromCGRect(screenRect));
    
    if (self.milkGlass.frame.origin.x+x <  self.frame.origin.x || self.milkGlass.frame.origin.x+x+self.milkGlass.frame.size.width > self.frame.size.width) {
        
        return nil;
        
    }
    //
    if (self.milkGlass.frame.origin.y+y < self.frame.origin.y || self.milkGlass.frame.origin.y+y+self.milkGlass.frame.size.height > self.frame.size.height) {
        
        return nil;
    }
    

    
//    CGPoint position;
//    position.x = [NSNumber numberWithFloat:selectedDictionary[@"X"]];
//    position.y = selectedDictionary[@"Y"];
    
    
    
    return selectedDictionary;
    
}

static inline CGFloat skRandf()
{
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high)
{
    return skRandf() * (high - low) + low;
}

- (void)addRock
{
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(8, 8)];
    rock.position = CGPointMake(skRand(0, self.size.width), self.size.height-50);
    rock.name = @"Cookie";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:rock];
}


@end
