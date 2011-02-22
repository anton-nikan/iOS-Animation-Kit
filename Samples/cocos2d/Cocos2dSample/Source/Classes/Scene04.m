//
//  Scene04.m
//  Cocos2dSample
//
//  Created by nikan on 2/22/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import "Scene04.h"


@implementation Scene04

- (id)init
{
    if ((self = [super initWithIndex:4 description:@"Frames could be as separate files and from atlases"])) {
        CGSize ws = [CCDirector sharedDirector].winSize;
        
        NSDictionary *clip = [AKHelpers animationClipFromPlist:@"scene04-atlasclip.plist"];
        NSDictionary *animSet = [AKHelpers animationSetOfClip:clip];
        
        CCSprite *sprite = [CCSprite spriteWithSpriteFrame:[AKHelpers initialFrameForAnimationWithName:@"ribbit"
                                                                                               fromSet:animSet]];
        sprite.position = ccp(0.75 * ws.width, 0.5 * ws.height);
        [self.layer addChild:sprite];
        
        [AKHelpers applyAnimationClip:clip toNode:sprite];
        
        // Atlas sprite
        CCSprite *atlasSprite = [CCSprite spriteWithFile:@"character-atlas.pvr.ccz"];
        atlasSprite.scale = 0.2;
        atlasSprite.position = ccp(0.3 * ws.width, 0.5 * ws.height);
        [self.layer addChild:atlasSprite];
    }
    return self;
}

@end
