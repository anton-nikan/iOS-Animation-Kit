//
//  AKCCRandomSpawn.m
//  AnimationKit
//
//  Created by nikan on 1/31/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import "AKCCRandomSpawn.h"


@implementation AKCCRandomSpawn

+ (id)actionWithItems:(NSArray*)items
{
    return [[[self alloc] initWithItems:items] autorelease];
}

- (id)initWithItems:(NSArray*)items
{
	NSAssert( items!=nil, @"RandomSpawn: argument must be non-nil");

    ccTime maxDuration = 0;
    for (NSDictionary *item in items) {
        CCFiniteTimeAction *action = [item objectForKey:@"Item"];
        ccTime dur = [action duration];
        if (dur > maxDuration) {
            maxDuration = dur;
        }
    }
    
    if ((self = [super initWithDuration:maxDuration])) {
        spawnItems = [items retain];
    }
    return self;
}

- (id)copyWithZone: (NSZone*)zone
{
    // Deep copy
    NSArray *copiedItems = [spawnItems copyWithZone:zone];
    [copiedItems autorelease];
    
	CCAction *copy = [[[self class] allocWithZone: zone] initWithItems:copiedItems];
	return copy;
}

-(void) dealloc
{
    currentAction = nil;
	[spawnItems release];
	[super dealloc];
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
    
    float roll = CCRANDOM_0_1();
    float sum = 0;
    currentAction = nil;    
    for (NSDictionary *item in spawnItems) {
        sum += [[item valueForKey:@"Chance"] floatValue];
        if (sum >= roll) {
            currentAction = [item objectForKey:@"Item"];
            self.duration = currentAction.duration;
            break;
        }
    }

    [currentAction startWithTarget:aTarget];
}

-(void) stop
{
    [currentAction stop];
    currentAction = nil;

	[super stop];
}

-(void) update: (ccTime) t
{
    [currentAction update:t];
}

- (CCActionInterval *) reverse
{
    NSMutableArray *copiedItems = [spawnItems mutableCopyWithZone:nil];
    for (NSMutableDictionary *item in copiedItems) {
        CCFiniteTimeAction *act = [item objectForKey:@"Action"];
        CCFiniteTimeAction *revAct = [act reverse];
        [item setObject:revAct forKey:@"Action"];
    }
    [copiedItems autorelease];
    
	return [[self class] actionWithItems:copiedItems];
}

@end
