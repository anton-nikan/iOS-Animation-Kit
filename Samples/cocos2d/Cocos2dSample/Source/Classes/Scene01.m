//
//  Scene01.m
//  Cocos2dSample
//
//  Created by nikan on 2/22/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import "Scene01.h"


@implementation Scene01

- (id)init
{
    if ((self = [super initWithIndex:1 description:@"Clip with simple repeating animation"])) {
        CGSize ws = [CCDirector sharedDirector].winSize;
        
        NSDictionary *clip = [AKHelpers animationClipFromPlist:@"scene01-simpleclip.plist"];
        NSDictionary *animSet = [AKHelpers animationSetOfClip:clip];
        
        CCSprite *sprite = [CCSprite spriteWithSpriteFrame:[AKHelpers initialFrameForAnimationWithName:@"ribbit"
                                                                                               fromSet:animSet]];
        sprite.position = ccp(0.5 * ws.width, 0.5 * ws.height);
        [self.layer addChild:sprite];
        
        [AKHelpers applyAnimationClip:clip toNode:sprite];
    }
    return self;
}

@end
