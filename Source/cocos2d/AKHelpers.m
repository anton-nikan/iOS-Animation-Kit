//
//  AKHelpers.m
//  AnimationKit
//
//  Created by nikan on 12/1/10.
//  Copyright 2010 Anton Nikolaienko. All rights reserved.
//

#import "AKHelpers.h"
#import "AKCCRandomSpawn.h"
#import "AKCCRandomDelayTime.h"
#import "AKCCSoundEffect.h"


@implementation AKHelpers

static id tagDelegate_ = nil;

#pragma mark Animation Set Routines

+ (CCSpriteFrame*)frameFromFile:(NSString*)file
{
    CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
    if (!spriteFrame) {
        UIImage *img = [UIImage imageNamed:file];
        CCTexture2D *tex = [[CCTexture2D alloc] initWithImage:img];
        spriteFrame = [CCSpriteFrame frameWithTexture:tex
                            rect:CGRectMake(0, 0, tex.contentSize.width, tex.contentSize.height)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:spriteFrame name:file];
    }
    
    return spriteFrame;
}

+ (NSArray*)imageFramesFromArray:(NSArray*)array
{
    NSMutableArray *resArray = [NSMutableArray arrayWithCapacity:[array count]];
    for (NSString *imgName in array) {
        CCSpriteFrame *img = [self frameFromFile:imgName];
        [resArray addObject:img];
    }
    
    return resArray;
}

+ (NSArray*)imageFramesFromPattern:(NSDictionary*)patternDict
{
    NSString *patternString = [patternDict valueForKey:@"Format"];
    NSNumber *startIdx = [patternDict valueForKey:@"StartIndex"];
    NSNumber *endIdx = [patternDict valueForKey:@"EndIndex"];
    
    if (!patternString || !startIdx || !endIdx) return nil;
    
    NSMutableArray *resArray = [NSMutableArray array];
    for (int i = [startIdx intValue]; i <= [endIdx intValue]; ++i) {
        NSString *fileName = [NSString stringWithFormat:patternString, i];
        CCSpriteFrame *img = [self frameFromFile:fileName];
        [resArray addObject:img];
    }
    
    return resArray;
}

+ (NSArray*)imageFramesFromPlist:(NSString*)plistFile
{
    NSString *localizedPath = [[NSBundle mainBundle] pathForResource:plistFile ofType:nil];
    NSData *plistData = [NSData dataWithContentsOfFile:localizedPath];
    
    NSString *error;
    NSPropertyListFormat format;
    NSArray *plist = [NSPropertyListSerialization propertyListFromData:plistData
                                                      mutabilityOption:NSPropertyListImmutable
                                                                format:&format
                                                      errorDescription:&error];
    if (!plist) return nil;
    return [self imageFramesFromArray:plist];
}

+ (NSDictionary*)animationSetFromDictionary:(NSDictionary*)animSetDict
{
    NSMutableDictionary *resDict = [NSMutableDictionary dictionaryWithCapacity:animSetDict.count];
    for (NSString *animName in animSetDict) {
        NSDictionary *animSet = [animSetDict objectForKey:animName];
        
        // Preloading atlases
        NSString *atlas = [animSet objectForKey:@"Atlas"];
        if (atlas) {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:atlas];
        }
        
        NSArray *atlasList = [animSet objectForKey:@"Atlases"];
        for (NSString *atlasFile in atlasList) {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:atlasFile];
        }
        
        // Loading frames
        NSArray *imageList = nil;

        NSString *singleFrame = [animSet valueForKey:@"Frame"];
        if (singleFrame) {
            imageList = [NSArray arrayWithObject:[self frameFromFile:singleFrame]];
        } else {
            id frameList = [animSet objectForKey:@"Frames"];
            if ([frameList isKindOfClass:[NSArray class]]) {
                imageList = [self imageFramesFromArray:frameList];
            } else if ([frameList isKindOfClass:[NSDictionary class]]) {
                imageList = [self imageFramesFromPattern:frameList];
            }
        }
        if (!imageList) return nil;
        
        // Defaults
        NSNumber *durationNum = [animSet valueForKey:@"Duration"];
        if (!durationNum) {
            durationNum = [NSNumber numberWithDouble:0.033 * imageList.count];
        }
        
        NSNumber *repeatNum = [animSet valueForKey:@"RepeatCount"];
        if (!repeatNum) {
            repeatNum = [NSNumber numberWithInt:1];
        }
        
        // Cocos2d anim objects:
        CCAnimation *anim = [CCAnimation animationWithFrames:imageList delay:[durationNum doubleValue] / imageList.count];
        [resDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            anim, @"Animation",
                            repeatNum, @"RepeatCount",
                            nil]
                    forKey:animName];
    }
    
    return resDict;
}

+ (NSDictionary*)animationSetFromPlist:(NSString*)plistFile
{
    NSString *filePath = plistFile;
    if (![filePath isAbsolutePath]) {
        filePath = [[NSBundle mainBundle] pathForResource:plistFile ofType:nil];
    }
    
    NSDictionary *animSetDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (!animSetDict) return nil;
    
    return [self animationSetFromDictionary:animSetDict];
}

+ (CCAction*)actionForAnimation:(NSDictionary*)anim
{
    CCAction *res = nil;
    int repeatCount = [[anim valueForKey:@"RepeatCount"] intValue];
    CCAnimation *animation = [anim objectForKey:@"Animation"];
    if (repeatCount != 0) {
        res = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO]
                                   times:repeatCount];
    } else {
        res = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO]];
    }
    
    return res;
}

+ (CCAction*)actionForAnimationWithName:(NSString*)animName fromSet:(NSDictionary*)animSet
{
    NSDictionary *anim = [animSet objectForKey:animName];
    if (!anim) return nil;
    
    return [self actionForAnimation:anim];
}

+ (void)applyAnimation:(NSDictionary*)anim toNode:(CCNode*)node
{
    CCAction *action = [self actionForAnimation:anim];
    if (action) {
        [node runAction:action];
    }
}

+ (void)applyAnimationWithName:(NSString*)animName fromSet:(NSDictionary*)animSet toNode:(CCNode*)node
{
    NSDictionary *anim = [animSet objectForKey:animName];
    if (!anim) return;
    
    [self applyAnimation:anim toNode:node];
}

+ (CCSpriteFrame*)initialFrameForAnimation:(NSDictionary*)anim
{
    CCAnimation *ccanim = [anim objectForKey:@"Animation"];
    if (!ccanim || ccanim.frames.count == 0) return nil;
    
    return [ccanim.frames objectAtIndex:0];
}

+ (CCSpriteFrame*)initialFrameForAnimationWithName:(NSString*)animName fromSet:(NSDictionary*)animSet
{
    NSDictionary *anim = [animSet objectForKey:animName];
    if (!anim) return nil;
 
    return [self initialFrameForAnimation:anim];
}

+ (CCSpriteFrame*)finalFrameForAnimation:(NSDictionary*)anim
{
    CCAnimation *ccanim = [anim objectForKey:@"Animation"];
    if (!ccanim || ccanim.frames.count == 0) return nil;
    
    return [ccanim.frames lastObject];
}

+ (CCSpriteFrame*)finalFrameForAnimationWithName:(NSString*)animName fromSet:(NSDictionary*)animSet
{
    NSDictionary *anim = [animSet objectForKey:animName];
    if (!anim) return nil;
    
    return [self finalFrameForAnimation:anim];
}

+ (NSTimeInterval)durationOfAnimation:(NSDictionary*)anim
{
    int repeatCount = [[anim valueForKey:@"RepeatCount"] intValue];
    CCAnimation *animation = [anim objectForKey:@"Animation"];
    
    if (repeatCount > 0) {
        return animation.frames.count * animation.delay * repeatCount;
    } else {
        return INFINITY;
    }
}

+ (NSTimeInterval)durationOfAnimationWithName:(NSString*)animName fromSet:(NSDictionary*)animSet
{
    NSDictionary *anim = [animSet objectForKey:animName];
    if (!anim) return 0.0;
    
    return [self durationOfAnimation:anim];
}


#pragma mark Animation Clip: Loading

+ (NSDictionary*)spawnClipItemWithDictionary:(NSDictionary*)dict
{
    NSArray *items = [dict objectForKey:@"Items"];
    if (!items || items.count == 0) return nil;
    
    // Confluent spawn
    if (items.count == 1) {
        return [self clipItemWithDictionary:[items lastObject]];
    }
    
    NSMutableArray *resItems = [NSMutableArray arrayWithCapacity:items.count];
    for (NSDictionary *itemDict in items) {
        NSDictionary *item = [self clipItemWithDictionary:itemDict];
        if (item) {
            [resItems addObject:item];
        }
    }
    
    NSDictionary *resDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Spawn", @"Type",
                             resItems, @"Items",
                             nil];
    return resDict;
}

+ (NSDictionary*)randomSpawnClipItemWithDictionary:(NSDictionary*)dict
{
    NSArray *items = [dict objectForKey:@"Items"];
    if (!items || items.count == 0) return nil;

    NSMutableArray *resItems = [NSMutableArray arrayWithCapacity:items.count];
    for (NSDictionary *chanceDict in items) {
        NSDictionary *itemDict = [chanceDict objectForKey:@"Item"];
        NSDictionary *item = [self clipItemWithDictionary:itemDict];
        if (item) {
            NSMutableDictionary *newChanceItem = [NSMutableDictionary dictionaryWithDictionary:chanceDict];
            [newChanceItem setObject:item forKey:@"Item"];
            [resItems addObject:newChanceItem];
        }
    }
    
    NSDictionary *resDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"RandomSpawn", @"Type",
                             resItems, @"Items",
                             nil];
    return resDict;
}

+ (NSDictionary*)sequenceClipItemWithDictionary:(NSDictionary*)sequenceDict
{
    NSArray *items = [sequenceDict objectForKey:@"Items"];
    if (!items || items.count == 0) return nil;
    
    // Confluent sequence
    if (items.count == 1) {
        return [self clipItemWithDictionary:[items lastObject]];
    }
    
    NSMutableArray *resItems = [NSMutableArray arrayWithCapacity:items.count];
    for (NSDictionary *itemDict in items) {
        NSDictionary *sequenceItem = [self clipItemWithDictionary:itemDict];
        if (sequenceItem) {
            [resItems addObject:sequenceItem];
        }
    }

    NSDictionary *resDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Sequence", @"Type",
                             resItems, @"Items",
                             nil];
    return resDict;
}

+ (NSDictionary*)loopClipItemWithDictionary:(NSDictionary*)loopDict
{
    NSDictionary *loopItemDict = [loopDict objectForKey:@"Item"];
    if (!loopItemDict) return nil;
    
    NSDictionary *loopItem = [self clipItemWithDictionary:loopItemDict];
    if (!loopItem) return nil;
    
    NSNumber *count = [loopDict valueForKey:@"Count"];
    if (!count) {
        count = [NSNumber numberWithInt:0];
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Loop", @"Type",
            count, @"Count",
            loopItem, @"Item",
            nil];
}

+ (NSDictionary*)clipItemWithDictionary:(NSDictionary*)clipItemDict
{
    NSString *itemType = [clipItemDict valueForKey:@"Type"];
    if (!itemType) return nil;
    
    NSDictionary *newItem = nil;
    if ([itemType isEqualToString:@"Sequence"]) {
        newItem = [self sequenceClipItemWithDictionary:clipItemDict];
    } else if ([itemType isEqualToString:@"Spawn"]) {
        newItem = [self spawnClipItemWithDictionary:clipItemDict];
    } else if ([itemType isEqualToString:@"Loop"] || [itemType isEqualToString:@"Repeat"]) {
        newItem = [self loopClipItemWithDictionary:clipItemDict];
    } else if ([itemType isEqualToString:@"RandomSpawn"] || [itemType isEqualToString:@"RandomItem"]) {
        newItem = [self randomSpawnClipItemWithDictionary:clipItemDict];
    } else {
        newItem = [NSDictionary dictionaryWithDictionary:clipItemDict];
    }
    
    return newItem;
}

+ (NSDictionary*)animationClipFromPlist:(NSString*)plistFile
{
    NSString *filePath = plistFile;
    if (![filePath isAbsolutePath]) {
        filePath = [[NSBundle mainBundle] pathForResource:plistFile ofType:nil];
    }
    
    NSDictionary *animClipDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (!animClipDict) return nil;

    NSDictionary *animSet = nil;
    id animationSet = [animClipDict objectForKey:@"AnimationSet"];
    if ([animationSet isKindOfClass:[NSDictionary class]]) {
        animSet = [self animationSetFromDictionary:animationSet];
        if (!animSet) return nil;
    } else if ([animationSet isKindOfClass:[NSString class]]) {
        animSet = [self animationSetFromPlist:animationSet];
        if (!animSet) return nil;
    }
    if (!animSet) return nil;
    
    NSDictionary *rootClipItemDict = [animClipDict objectForKey:@"Clip"];
    if (!rootClipItemDict) return nil;
    
    NSDictionary *rootClipItem = [self clipItemWithDictionary:rootClipItemDict];
    if (!rootClipItem) return nil;

    NSMutableDictionary *resDict = [NSMutableDictionary dictionary];
    [resDict setObject:animSet forKey:@"AnimationSet"];
    [resDict setObject:rootClipItem forKey:@"Clip"];
    return resDict;
}


#pragma mark Animation Clip: Applying

+ (CCAction*)soundEffectActionWithDictionary:(NSDictionary*)clipItemDict
{
    NSString *soundFile = [clipItemDict valueForKey:@"File"];
    return [AKCCSoundEffect actionWithEffectName:soundFile];
}

+ (CCAction*)animationActionWithDictionary:(NSDictionary*)clipItemDict andAnimationSet:(NSDictionary*)animSet
{
    NSString *animName = [clipItemDict valueForKey:@"Name"];
    return [self actionForAnimationWithName:animName fromSet:animSet];
}

+ (CCAction*)spawnActionWithDictionary:(NSDictionary*)clipItemDict andAnimationSet:(NSDictionary*)animSet
{
    NSArray *items = [clipItemDict objectForKey:@"Items"];
    
    CCAction *rootAction = nil;
    CCAction *prevAction = nil;
    for (NSDictionary *itemDict in items) {
        CCAction *itemAction = [self actionForAnimationClipItem:itemDict withAnimationSet:animSet];
        if (itemAction) {
            if (prevAction) {
                prevAction = [CCSpawn actionOne:(CCFiniteTimeAction*)prevAction two:(CCFiniteTimeAction*)itemAction];
            } else {
                prevAction = itemAction;
            }
            rootAction = prevAction;
        }
    }
    
    return rootAction;
}

+ (CCAction*)sequenceActionWithDictionary:(NSDictionary*)clipItemDict andAnimationSet:(NSDictionary*)animSet
{
    NSArray *items = [clipItemDict objectForKey:@"Items"];
    
    CCAction *rootAction = nil;
    CCAction *prevAction = nil;
    for (NSDictionary *itemDict in items) {
        CCAction *itemAction = [self actionForAnimationClipItem:itemDict withAnimationSet:animSet];
        if (itemAction) {
            if (prevAction) {
                prevAction = [CCSequence actionOne:(CCFiniteTimeAction*)prevAction two:(CCFiniteTimeAction*)itemAction];
            } else {
                prevAction = itemAction;
            }
            rootAction = prevAction;
        }
    }
        
    return rootAction;
}

+ (CCAction*)loopActionWithDictionary:(NSDictionary*)clipItemDict andAnimationSet:(NSDictionary*)animSet
{
    NSNumber *repeatCount = [clipItemDict valueForKey:@"Count"];
    NSDictionary *itemDict = [clipItemDict objectForKey:@"Item"];
    
    CCAction *loopAction = [self actionForAnimationClipItem:itemDict withAnimationSet:animSet];
    if (!loopAction) return nil;
    
    if ([repeatCount intValue] > 0) {
        return [CCRepeat actionWithAction:(CCFiniteTimeAction*)loopAction
                                    times:[repeatCount intValue]];
    } else {
        return [CCRepeatForever actionWithAction:(CCActionInterval*)loopAction];
    }
}

+ (CCAction*)randomDelayActionWithDictionary:(NSDictionary*)clipItemDict
{
    NSNumber *minValue = [clipItemDict valueForKey:@"MinValue"];
    NSNumber *maxValue = [clipItemDict valueForKey:@"MaxValue"];
    
    return [AKCCRandomDelayTime actionWithMinDuration:[minValue doubleValue] maxDuration:[maxValue doubleValue]];
}

+ (CCAction*)delayActionWithDictionary:(NSDictionary*)clipItemDict
{
    NSNumber *duration = [clipItemDict valueForKey:@"Duration"];
    return [CCDelayTime actionWithDuration:[duration doubleValue]];
}

+ (CCAction*)randomSpawnActionWithDictionary:(NSDictionary*)clipItemDict andAnimationSet:(NSDictionary*)animSet
{
    NSArray *items = [clipItemDict objectForKey:@"Items"];
    NSMutableArray *procItems = [NSMutableArray arrayWithCapacity:items.count];
    for (NSDictionary *item in items) {
        NSDictionary *actionItemDict = [item objectForKey:@"Item"];
        CCAction *actionItem = [self actionForAnimationClipItem:actionItemDict withAnimationSet:animSet];
        if (actionItem) {
            NSMutableDictionary *mutedItem = [NSMutableDictionary dictionaryWithDictionary:item];
            [mutedItem setObject:actionItem forKey:@"Item"];
            [procItems addObject:mutedItem];
        }
    }
    
    return [AKCCRandomSpawn actionWithItems:procItems];
}

+ (CCAction*)tagActionWithDictionary:(NSDictionary*)dict
{
    if (!tagDelegate_) return nil;
    
    NSString *tagName = [dict valueForKey:@"Name"];
    return [CCCallFuncND actionWithTarget:tagDelegate_ selector:@selector(animationClipOnNode:reachedTagWithName:) data:tagName];
}

+ (CCAction*)actionForAnimationClipItem:(NSDictionary*)clipItemDict withAnimationSet:(NSDictionary*)animSet
{
    NSString *itemType = [clipItemDict valueForKey:@"Type"];
    CCAction *newAction = nil;
    if ([itemType isEqualToString:@"Sequence"]) {
        newAction = [self sequenceActionWithDictionary:clipItemDict andAnimationSet:animSet];
    } else if ([itemType isEqualToString:@"Spawn"]) {
        newAction = [self spawnActionWithDictionary:clipItemDict andAnimationSet:animSet];
    } else if ([itemType isEqualToString:@"SoundEffect"]) {
        newAction = [self soundEffectActionWithDictionary:clipItemDict];
    } else if ([itemType isEqualToString:@"Animation"]) {
        newAction = [self animationActionWithDictionary:clipItemDict andAnimationSet:animSet];
    } else if ([itemType isEqualToString:@"Loop"]) {
        newAction = [self loopActionWithDictionary:clipItemDict andAnimationSet:animSet];
    } else if ([itemType isEqualToString:@"Delay"]) {
        newAction = [self delayActionWithDictionary:clipItemDict];
    } else if ([itemType isEqualToString:@"RandomDelay"]) {
        newAction = [self randomDelayActionWithDictionary:clipItemDict];
    } else if ([itemType isEqualToString:@"RandomSpawn"]) {
        newAction = [self randomSpawnActionWithDictionary:clipItemDict andAnimationSet:animSet];
    } else if ([itemType isEqualToString:@"Tag"]) {
        newAction = [self tagActionWithDictionary:clipItemDict];
    }
    
    return newAction;
}

+ (CCAction*)actionForAnimationClip:(NSDictionary*)clip
{
    NSDictionary *rootClipItem = [clip objectForKey:@"Clip"];
    NSDictionary *animSet = [clip objectForKey:@"AnimationSet"];
    
    return [self actionForAnimationClipItem:rootClipItem withAnimationSet:animSet];
}

+ (void)applyAnimationClip:(NSDictionary*)clip toNode:(CCNode*)node
{
    CCAction *resultAction = [self actionForAnimationClip:clip];
    if (resultAction) {
        [node runAction:resultAction];
    }
}

+ (NSDictionary*)animationSetOfClip:(NSDictionary*)animClip
{
    return [animClip objectForKey:@"AnimationSet"];
}


#pragma mark -

+ (void)setTagDelegate:(id)tagDelegate
{
    [tagDelegate_ release];
    tagDelegate_ = [tagDelegate retain];
}

@end
