//
//  Scene05.m
//  Cocos2dSample
//
//  Created by nikan on 2/22/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import "Scene05.h"


@implementation Scene05

- (id)init
{
    if ((self = [super initWithIndex:5 description:@"Sequencing clips require to get animation duration (tap it!)"])) {
        CGSize ws = [CCDirector sharedDirector].winSize;
        
        idleClip = [[AKHelpers animationClipFromPlist:@"scene05-idle-clip.plist"] retain];
        NSDictionary *animSet = [AKHelpers animationSetOfClip:idleClip];
        
        sprite = [CCSprite spriteWithSpriteFrame:[AKHelpers initialFrameForAnimationWithName:@"ribbit"
                                                                                     fromSet:animSet]];
        sprite.position = ccp(0.5 * ws.width, 0.5 * ws.height);
        [self.layer addChild:sprite];

        popClip = [[AKHelpers animationClipFromPlist:@"scene05-pop-clip.plist"] retain];
        
        touchTracker = [[TouchTracker alloc] initWithSpriteRect:sprite];
        touchTracker.delegate = self;

        [self runIdle];
    }
    return self;
}

- (void)dealloc
{
    [idleClip release];
    [popClip release];
    [touchTracker release];

    [super dealloc];
}

- (void)onEnter
{
    [super onEnter];
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:touchTracker priority:0 swallowsTouches:YES];
}

- (void)onExit
{
    [super onExit];
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:touchTracker];
}


#pragma mark -

- (void)runIdle
{
    [sprite stopAllActions];
    NSDictionary *animSet = [AKHelpers animationSetOfClip:idleClip];
    [sprite setDisplayFrame:[AKHelpers initialFrameForAnimationWithName:@"ribbit"
                                                                fromSet:animSet]];
    
    [AKHelpers applyAnimationClip:idleClip toNode:sprite];
    touchTracker.active = YES;
}


#pragma mark -

- (void)touchTrackerDidTouch:(TouchTracker *)tracker
{
    [sprite stopAllActions];
    [AKHelpers applyAnimationClip:popClip toNode:sprite];
    
    NSDictionary *animSet = [AKHelpers animationSetOfClip:popClip];
    NSTimeInterval popDuration = [AKHelpers durationOfAnimationWithName:@"pop" fromSet:animSet];
    
    [sprite runAction:[CCSequence actions:
                       [CCDelayTime actionWithDuration:popDuration],
                       [CCCallFunc actionWithTarget:self selector:@selector(runIdle)],
                       nil]];
    
    tracker.active = NO;
}

@end
