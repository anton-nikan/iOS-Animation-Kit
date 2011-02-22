//
//  Scene03.m
//  Cocos2dSample
//
//  Created by nikan on 2/22/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import "Scene03.h"


@implementation Scene03

- (id)init
{
    if ((self = [super initWithIndex:3 description:@"Using random elements makes idle look natural"])) {
        CGSize ws = [CCDirector sharedDirector].winSize;
        
        NSDictionary *clip = [AKHelpers animationClipFromPlist:@"scene03-rndclip.plist"];
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
