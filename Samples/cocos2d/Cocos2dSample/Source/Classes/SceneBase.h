//
//  SceneBase.h
//  Cocos2dSample
//
//  Created by nikan on 2/22/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SceneBase : CCScene {
    CCLayer *layer;
    NSUInteger index;
}

- (id)initWithIndex:(NSUInteger)idx description:(NSString*)desc;

@property (nonatomic, readonly) CCLayer *layer;
@property (nonatomic, readonly) NSUInteger index;

@end
