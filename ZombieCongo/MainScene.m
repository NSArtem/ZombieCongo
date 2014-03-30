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

@interface MainScene()


@end

@implementation MainScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        [self addBackground];
    }
    return self;
}

- (void)update:(NSTimeInterval)currentTime
{
    
}

- (void)addBackground
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:kSpriteBackground];
    background.anchorPoint = CGPointZero;
    background.name = kSpriteBackground;
    [self addChild:background];
    background.position = CGPointZero;
}

@end
