//
//  SceneBase.m
//  Cocos2dSample
//
//  Created by nikan on 2/22/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import "SceneBase.h"
#import "FinalScene.h"


@implementation SceneBase

@synthesize layer, index;

- (CCLayer*)layer
{
    if (!layer) {
        layer = [CCLayer node];
        [self addChild:layer];
    }
    return layer;
}


#pragma mark -

- (id)initWithIndex:(NSUInteger)idx description:(NSString*)desc
{
    if ((self = [super init])) {
        index = idx;
        
        CGSize ws = [CCDirector sharedDirector].winSize;
        
        if ([self class] != [FinalScene class]) {
            CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Scene %d", self.index]
                                                        fontName:@"Marker Felt"
                                                        fontSize:32];
            titleLabel.position = ccp(0.5 * ws.width, ws.height - 0.5 * titleLabel.contentSize.height);
            [self.layer addChild:titleLabel];
        }
        
        CCLabelTTF *descriptionLabel = [CCLabelTTF labelWithString:desc fontName:@"Marker Felt" fontSize:20];
        descriptionLabel.position = ccp(0.5 * ws.width, descriptionLabel.contentSize.height);
        [self.layer addChild:descriptionLabel];
        
        CCMenuItem *prevItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"<" fontName:@"Marker Felt" fontSize:54]
                                                       target:self selector:@selector(prevAction:)];
        prevItem.position = ccp(0.7 * prevItem.contentSize.width, 0.5 * ws.height);

        CCMenuItem *nextItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@">" fontName:@"Marker Felt" fontSize:54]
                                                       target:self selector:@selector(nextAction:)];
        nextItem.position = ccp(ws.width - 0.7 * nextItem.contentSize.width, 0.5 * ws.height);
        
        CCMenu *menu = [CCMenu menuWithItems:
                        prevItem,
                        nextItem,
                        nil];
        menu.position = ccp(0, 0);
        [self.layer addChild:menu];
        
        if (self.index == 0 || !NSClassFromString([NSString stringWithFormat:@"Scene%02d", self.index - 1])) {
            prevItem.visible = NO;
        }
        if ([self class] == [FinalScene class]) {
            nextItem.visible = NO;
        }
    }
    return self;
}


#pragma mark -

- (void)cleanSceneResources
{
    [self removeChild:layer cleanup:YES];
    layer = nil;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
}


#pragma mark -

- (void)prevAction:(id)sender
{
    if (self.index == 0) return;
    Class sceneClass = NSClassFromString([NSString stringWithFormat:@"Scene%02d", self.index - 1]);
    if (sceneClass) {
        // Need to clean caches before the next scene
        [self cleanSceneResources];
        
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[sceneClass node]]];
    }
}

- (void)nextAction:(id)sender
{
    Class sceneClass = NSClassFromString([NSString stringWithFormat:@"Scene%02d", self.index + 1]);
    if (sceneClass) {
        // Need to clean caches before the next scene
        [self cleanSceneResources];

        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[sceneClass node]]];
    } else {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[FinalScene node]]];
    }
}

@end
