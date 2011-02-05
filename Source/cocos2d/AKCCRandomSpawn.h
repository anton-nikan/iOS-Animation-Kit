//
//  AKCCRandomSpawn.h
//  AnimationKit
//
//  Created by nikan on 1/31/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AKCCRandomSpawn : CCActionInterval <NSCopying>
{
    NSArray *spawnItems;
    CCFiniteTimeAction *currentAction;
}

+ (id)actionWithItems:(NSArray*)items;
- (id)initWithItems:(NSArray*)items;

@end
