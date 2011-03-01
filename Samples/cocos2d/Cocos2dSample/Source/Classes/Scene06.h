//
//  Scene06.h
//  Cocos2dSample
//
//  Created by nikan on 3/1/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SceneBase.h"


@interface Scene06 : SceneBase {
    CCSprite *sprite;
    NSDictionary *idleClip;
    NSDictionary *popClip;
    
    CCLabelTTF *infoLabel;
}

@end
