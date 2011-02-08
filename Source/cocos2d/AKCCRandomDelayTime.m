//
//  AKCCRandomDelayTime.m
//  AnimationKit
//
//  Created by nikan on 1/31/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import "AKCCRandomDelayTime.h"


@implementation AKCCRandomDelayTime

+ (id)actionWithMinDuration:(ccTime)minDur maxDuration:(ccTime)maxDur
{
    return [[[self alloc] initWithMinDuration:minDur maxDuration:maxDur] autorelease];
}

- (id)initWithMinDuration:(ccTime)minDur maxDuration:(ccTime)maxDur
{
    if ((self = [super initWithDuration:maxDur])) {
        minDuration = minDur;
        maxDuration = maxDur;
        self.duration = minDuration + CCRANDOM_0_1() * (maxDuration - minDuration);
    }
    return self;
}

-(void) startWithTarget:(id)aTarget
{
    self.duration = minDuration + CCRANDOM_0_1() * (maxDuration - minDuration);
	[super startWithTarget:aTarget];
}

-(id)reverse
{
	return [[self class] actionWithMinDuration:minDuration maxDuration:maxDuration];
}

@end
