//
//  Scene06.m
//  Cocos2dSample
//
//  Created by nikan on 3/1/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import "Scene06.h"


@implementation Scene06

- (id)init
{
    if ((self = [super initWithIndex:6 description:@"Using tags allows to respond on different clip states"])) {
        CGSize ws = [CCDirector sharedDirector].winSize;
        
        popClip = [[AKHelpers animationClipFromPlist:@"scene06-pop-clip.plist"] retain];
        idleClip = [[AKHelpers animationClipFromPlist:@"scene06-idle-clip.plist"] retain];
        NSDictionary *animSet = [AKHelpers animationSetOfClip:idleClip];
        
        sprite = [CCSprite spriteWithSpriteFrame:[AKHelpers initialFrameForAnimationWithName:@"ribbit"
                                                                                     fromSet:animSet]];
        sprite.position = ccp(0.65 * ws.width, 0.5 * ws.height);
        [self.layer addChild:sprite];
        
        infoLabel = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:36];
        infoLabel.position = ccp(0.3 * ws.width, 0.5 * ws.height);
        [self.layer addChild:infoLabel];
    }
    return self;
}

- (void)dealloc
{
    [popClip release];
    [idleClip release];
    [super dealloc];
}

- (void)onEnter
{
    [super onEnter];

    [AKHelpers setTagDelegate:self];
    [AKHelpers applyAnimationClip:idleClip toNode:sprite];
}

- (void)onExit
{
    [super onExit];
    [AKHelpers setTagDelegate:nil];
}


#pragma mark -

- (void)animationClipOnNode:(CCNode*)node reachedTagWithName:(NSString*)tagName
{
    // Responding on tag "popit" in idle: popping the frog
    if ([tagName isEqualToString:@"popit"]) {
        [node stopAllActions];
        [AKHelpers applyAnimationClip:popClip toNode:node];
        
        [infoLabel stopAllActions];
        infoLabel.opacity = 255;
        [infoLabel setString:@"Pop"];
        [infoLabel runAction:[CCFadeOut actionWithDuration:1.5]];
    }
    // and on tag "respawn" in pop clip we return to idle
    else if ([tagName isEqualToString:@"respawn"]) {
        [node stopAllActions];
        
        NSDictionary *animSet = [AKHelpers animationSetOfClip:idleClip];
        [(CCSprite*)node setDisplayFrame:[AKHelpers initialFrameForAnimationWithName:@"ribbit"
                                                                             fromSet:animSet]];

        [AKHelpers applyAnimationClip:idleClip toNode:node];

        [infoLabel stopAllActions];
        infoLabel.opacity = 255;
        [infoLabel setString:@"Respawn"];
        [infoLabel runAction:[CCFadeOut actionWithDuration:1.5]];
    }
}

@end
