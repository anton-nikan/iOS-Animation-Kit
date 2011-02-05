//
//  AKCCRandomDelayTime.h
//  AnimationKit
//
//  Created by nikan on 1/31/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AKCCRandomDelayTime : CCDelayTime {
    ccTime minDuration;
    ccTime maxDuration;
}

+ (id)actionWithMinDuration:(ccTime)minDur maxDuration:(ccTime)maxDur;
- (id)initWithMinDuration:(ccTime)minDur maxDuration:(ccTime)maxDur;

@end
