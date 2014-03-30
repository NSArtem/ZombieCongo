//
//  MyScene.m
//  ZombieCongo
//
//  Created by Artem Abramov on 30/03/14.
//  Copyright (c) 2014 Artem Abramov. All rights reserved.
//

#import "MainScene.h"
#import "SKScene+Dimensions.h"

static NSString* const kSpriteBackground = @"background";
static NSString* const kSpriteZombie1 = @"zombie1";

typedef NS_ENUM(NSUInteger, MainSceneZ)
{
    MainSceneZ_MostBottom = 0,
    MainSceneZ_Background = 10,
    MainSceneZ_Monsters = 80,
    MainSceneZ_MostTop = 100
};

@interface MainScene()


@end

@implementation MainScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        [self spawnZombie];

        [self addBackground];
    }
    return self;
}

- (void)update:(NSTimeInterval)currentTime
{
    
}

- (void)spawnZombie
{
    SKSpriteNode *zombie = [SKSpriteNode spriteNodeWithImageNamed:kSpriteZombie1];
    zombie.position = CGPointMake(100., 100.);
    zombie.name = kSpriteZombie1;
    zombie.zPosition = MainSceneZ_Monsters;
    [self addChild:zombie];
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
