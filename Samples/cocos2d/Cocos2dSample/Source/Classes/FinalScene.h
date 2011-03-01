//
//  FinalScene.h
//  Cocos2dSample
//
//  Created by nikan on 2/22/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SceneBase.h"


@interface FinalScene : SceneBase {

}

+ (FinalScene*)nodeWithLevelIndex:(int)idx;
- (FinalScene*)initWithIndex:(int)idx;

@end
