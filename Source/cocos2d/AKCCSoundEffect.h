//
//  AKCCSoundEffect.h
//  AnimationKit
//
//  Created by nikan on 2/18/11.
//  Copyright 2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AKCCSoundEffect : CCActionInterval <NSCopying> {
    NSString *effectName;
    CDSoundSource *effect;
}

+ (id)actionWithEffectName:(NSString*)name;
- (id)initWithEffectName:(NSString*)name;

@end
