//
//  SKNode+Dimensions.m
//  ZombieCongo
//
//  Created by Artem Abramov on 30/03/14.
//  Copyright (c) 2014 Artem Abramov. All rights reserved.
//

#import "SKScene+Dimensions.h"

@implementation SKScene (Dimensions)

- (CGPoint)CGPointMakeCenter
{
    return CGPointMake(self.size.width / 2,
                       self.size.height /2);
}

@end
