//
//  MyScene.m
//  ZombieCongo
//
//  Created by Artem Abramov on 30/03/14.
//  Copyright (c) 2014 Artem Abramov. All rights reserved.
//

#import "MainScene.h"
#import "SKScene+Dimensions.h"

//Sprites
static NSString* const kSpriteBackground = @"background";
static NSString* const kSpriteZombie1 = @"zombie1";

//Labels
static NSString* const kLabelFrameTime = @"kLabelFrameTime";

static const CGFloat kVelocityZombie = 120.0f;

typedef NS_ENUM(NSUInteger, MainSceneZ)
{
    MainSceneZ_MostBottom = 0,
    MainSceneZ_Background = 10,
    MainSceneZ_Monsters = 80,
    MainSceneZ_UI = 90,
    MainSceneZ_MostTop = 100
};

@interface MainScene()


@end

@implementation MainScene
{
    NSTimeInterval _lastUpdate;
    NSTimeInterval _deltaTime;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        [self spawnZombie];
        [self addFrameTimeLabel];
        [self addBackground];
    }
    return self;
}

- (void)update:(NSTimeInterval)currentTime
{
    if (_lastUpdate)
        _deltaTime = currentTime - _lastUpdate;
    else
        _deltaTime = 0;
    _lastUpdate = currentTime;
    [self updateFrameTimeLabel:_deltaTime];
    
    [self moveZombie];
}

- (void)addFrameTimeLabel
{
    SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    labelNode.position = CGPointMake(20, 10.);
    labelNode.name = kLabelFrameTime;
    labelNode.zPosition = MainSceneZ_UI;
    [self addChild:labelNode];
}

- (void)updateFrameTimeLabel:(NSTimeInterval)timeInterval
{
    [self enumerateChildNodesWithName:kLabelFrameTime
                           usingBlock:^(SKNode *node, BOOL *stop)
    {
        SKLabelNode* label = (SKLabelNode*)node;
        NSString* string = [NSString stringWithFormat:@"%gms", timeInterval*1000];
        label.text = string;
    }];
}

- (void)spawnZombie
{
    SKSpriteNode *zombie = [SKSpriteNode spriteNodeWithImageNamed:kSpriteZombie1];
    zombie.position = CGPointMake(100., 100.);
    zombie.name = kSpriteZombie1;
    zombie.zPosition = MainSceneZ_Monsters;
    [self addChild:zombie];
}

- (void)moveZombie
{
    [self enumerateChildNodesWithName:kSpriteZombie1
                           usingBlock:^(SKNode *node, BOOL *stop)
    {
        [self moveNode:node
            withVelocity:CGPointMake(kVelocityZombie, 0)];
    }];
}

- (void)moveNode:(SKNode*)sprite
      withVelocity:(CGPoint)velocity
{
    CGPoint amountToMove = CGPointMake(velocity.x * _deltaTime,
                                       velocity.y * _deltaTime);
    sprite.position = CGPointMake(sprite.position.x + amountToMove.x,
                                  sprite.position.y + amountToMove.y);
}

- (void)addBackground
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:kSpriteBackground];
    background.anchorPoint = CGPointZero;
    background.name = kSpriteBackground;
    background.zPosition = MainSceneZ_Background;
    [self addChild:background];
    background.position = CGPointZero;
}

@end
