//
//  AKCCSoundEffect.m
//  AnimationKit
//
//  Created by nikan on 2/18/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import "AKCCSoundEffect.h"


@implementation AKCCSoundEffect

+ (id)actionWithEffectName:(NSString*)name
{
    return [[[self alloc] initWithEffectName:name] autorelease];
}

- (id)initWithEffectName:(NSString*)name
{
    effectName = [NSString stringWithString:name];
    effect = [[SimpleAudioEngine sharedEngine] soundSourceForFile:effectName];
    if (effect && (self = [super initWithDuration:effect.durationInSeconds])) {
        [effectName retain];
        [effect retain];
    }
    return self;
}

- (void)dealloc 
{
    [effectName release];
    [effect release];
    [super dealloc];
}

- (id)copyWithZone: (NSZone*)zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithEffectName:effectName];
	return copy;
}

- (CCActionInterval *) reverse
{
	return [[self class] actionWithEffectName:effectName];
}

-(void) startWithTarget:(id)aTarget
{
    [effect play];
}

- (void)stop
{
    [effect stop];
}

-(void) update: (ccTime) t
{
    
}

@end
