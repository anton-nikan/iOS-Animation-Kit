//
//  AKHelpers.h
//  AnimationKit
//
//  Created by nikan on 12/1/10.
//  Copyright 2010 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AKHelpers : NSObject {

}

+ (UIImage*)frameFromFile:(NSString*)file;
+ (NSArray*)imageFramesFromArray:(NSArray*)array;
+ (NSArray*)imageFramesFromPlist:(NSString*)plistFile;
+ (NSDictionary*)animationSetFromPlist:(NSString*)plistFile;
+ (void)applyAnimation:(NSDictionary*)anim toView:(UIImageView*)view;

@end
