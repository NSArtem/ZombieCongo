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

static inline CGFloat ScalarShortestAngleBetween(
                                                 const CGFloat a, const CGFloat b)
{
    CGFloat difference = b - a;
    CGFloat angle = fmodf(difference, M_PI * 2);
    if (angle >= M_PI) {
        angle -= M_PI * 2;
    }
    return angle;
}

@interface MainScene()


@end

@implementation MainScene
{
    NSTimeInterval _lastUpdate;
    NSTimeInterval _deltaTime;
    CGPoint _zombieVelocity;
    CGPoint _lastTapLocation;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        [self spawnZombie];
        [self addFrameTimeLabel];
        [self addBackground];
        _zombieVelocity = CGPointZero;
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
    
    [self moveZombieWithVelocity:_zombieVelocity];
    [self checkIfZombieReachedDestination:_lastTapLocation];
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

- (CGPoint)getVelocityOfNode:(SKNode*)node toward:(CGPoint)point
{
    CGPoint offset = CGPointMake(point.x - node.position.x,
                                 point.y - node.position.y);
    CGFloat length = sqrtf(pow(offset.x, 2) + pow(offset.y, 2));
    offset = CGPointMake(offset.x / length, offset.y / length);
    CGPoint velocity = CGPointMake(offset.x * kVelocityZombie,
                                   offset.y * kVelocityZombie);
    return velocity;
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

- (void)checkIfZombieReachedDestination:(CGPoint)point
{
    [self enumerateChildNodesWithName:kSpriteZombie1
                           usingBlock:^(SKNode *node, BOOL *stop)
    {
        CGFloat deltaX = fabsf(node.position.x - _lastTapLocation.x);
        CGFloat deltaY = fabsf(node.position.y - _lastTapLocation.y);
        if (deltaX <= kVelocityZombie * _deltaTime &&
            deltaY <= kVelocityZombie * _deltaTime)
            _zombieVelocity = CGPointZero;
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

- (void)moveZombieWithVelocity:(CGPoint)velocity
{
    [self enumerateChildNodesWithName:kSpriteZombie1
                           usingBlock:^(SKNode *node, BOOL *stop)
    {
        [self moveNode:node
            withVelocity:velocity];
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

static inline CGFloat ScalarSign(CGFloat a)
{
    return a >= 0 ? 1 : -1;
}

- (void)rotateSprite:(SKNode*)node
         toDirection:(CGPoint)direction
{
    CGFloat targetAngle = atan2f(direction.y, direction.x);
    NSLog(@"targetAngle: %g", targetAngle);
    CGFloat shortest = ScalarShortestAngleBetween(node.zRotation, targetAngle);
    CGFloat amountToRotate = (4 * M_PI) *_deltaTime;
    if (ABS(shortest) < amountToRotate)
        amountToRotate = ABS(shortest);
    else
        amountToRotate = amountToRotate;
    
    node.zRotation += ScalarSign(shortest) * amountToRotate;
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

#pragma mark - Touches
//TODO: DRY!
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    [self enumerateChildNodesWithName:kSpriteZombie1
                           usingBlock:^(SKNode *node, BOOL *stop)
    {
        _zombieVelocity = [self getVelocityOfNode:node
                                           toward:location];
        [self rotateSprite:node toDirection:_zombieVelocity];
    }];
}

//TODO: DRY!
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    [self enumerateChildNodesWithName:kSpriteZombie1
                           usingBlock:^(SKNode *node, BOOL *stop)
     {
         _zombieVelocity = [self getVelocityOfNode:node
                                            toward:location];
                 [self rotateSprite:node toDirection:_zombieVelocity];
     }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    [self enumerateChildNodesWithName:kSpriteZombie1
                           usingBlock:^(SKNode *node, BOOL *stop)
     {
         _zombieVelocity = [self getVelocityOfNode:node
                                            toward:location];
                 [self rotateSprite:node toDirection:_zombieVelocity];
     }];
    _lastTapLocation = location;
}

@end
