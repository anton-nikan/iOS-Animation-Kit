//
//  Scene05.h
//  Cocos2dSample
//
//  Created by nikan on 2/22/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchTracker.h"
#import "SceneBase.h"


@interface Scene05 : SceneBase <TouchTrackerDelegate> {
    CCSprite *sprite;
    
    NSDictionary *idleClip;
    NSDictionary *popClip;
    
    TouchTracker *touchTracker;
}

- (void)runIdle;

@end
