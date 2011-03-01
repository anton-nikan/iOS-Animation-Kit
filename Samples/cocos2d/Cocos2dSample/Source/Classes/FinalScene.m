//
//  FinalScene.m
//  Cocos2dSample
//
//  Created by nikan on 2/22/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import "FinalScene.h"


@implementation FinalScene

+ (FinalScene*)nodeWithLevelIndex:(int)idx
{
    return [[[self alloc] initWithIndex:idx] autorelease];
}

- (FinalScene*)initWithIndex:(int)idx
{
    if ((self = [super initWithIndex:idx description:@"Copyright 2011 Anton Nikolaienko"])) {
        CGSize ws = [CCDirector sharedDirector].winSize;
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"iOS Animation Kit" fontName:@"Marker Felt" fontSize:32];
        label.position = ccp(0.5 * ws.width, 0.8 * ws.height);
        [self.layer addChild:label];
        
        label = [CCLabelTTF labelWithString:@"http://github.com/anton-nikan/iOS-Animation-Kit" fontName:@"Marker Felt" fontSize:22];
        label.position = ccp(0.5 * ws.width, 0.6 * ws.height);
        [self.layer addChild:label];
        
        label = [CCLabelTTF labelWithString:@"More use-cases to come!" fontName:@"Marker Felt" fontSize:32];
        label.position = ccp(0.5 * ws.width, 0.4 * ws.height);
        [self.layer addChild:label];
    }
    return self;    
}

@end
