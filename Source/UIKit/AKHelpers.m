//
//  AKHelpers.m
//  AnimationKit
//
//  Created by nikan on 12/1/10.
//  Copyright 2010 Anton Nikolaienko. All rights reserved.
//

#import "AKHelpers.h"


@implementation AKHelpers

+ (UIImage*)frameFromFile:(NSString*)file
{
    UIImage *img = [UIImage imageNamed:file];
    return img;
}

+ (NSArray*)imageFramesFromArray:(NSArray*)array
{
    NSMutableArray *resArray = [NSMutableArray arrayWithCapacity:[array count]];
    for (NSString *imgName in array) {
        UIImage *img = [self frameFromFile:imgName];
        [resArray addObject:img];
    }
    
    return resArray;
}

+ (NSArray*)imageFramesFromPlist:(NSString*)plistFile
{
    NSString *localizedPath = [[NSBundle mainBundle] pathForResource:plistFile ofType:nil];
    NSData *plistData = [NSData dataWithContentsOfFile:localizedPath];
    
    NSString *error;
    NSPropertyListFormat format;
    NSArray *plist = [NSPropertyListSerialization propertyListFromData:plistData
                                                      mutabilityOption:NSPropertyListImmutable
                                                                format:&format
                                                      errorDescription:&error];
    if (!plist) return nil;
    return [self imageFramesFromArray:plist];
}

+ (NSDictionary*)animationSetFromPlist:(NSString*)plistFile
{
    NSString *filePath = plistFile;
    if (![filePath isAbsolutePath]) {
        filePath = [[NSBundle mainBundle] pathForResource:plistFile ofType:nil];
    }
    
    NSDictionary *animSetDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (!animSetDict) return nil;
    
    NSMutableDictionary *resDict = [NSMutableDictionary dictionaryWithCapacity:animSetDict.count];
    for (NSString *animName in animSetDict) {
        NSDictionary *animSet = [animSetDict objectForKey:animName];

        NSArray *frameList = [animSet objectForKey:@"Frames"];
        NSArray *imageList = [self imageFramesFromArray:frameList];
        
        NSMutableDictionary *imageSet = [NSMutableDictionary dictionaryWithDictionary:animSet];
        [imageSet setObject:imageList forKey:@"Frames"];
        
        // Defaults
        NSNumber *durationNum = [imageSet valueForKey:@"Duration"];
        if (!durationNum) {
            [imageSet setValue:[NSNumber numberWithDouble:0.033 * imageList.count] forKey:@"Duration"];
        }
        
        NSNumber *repeatNum = [imageSet valueForKey:@"RepeatCount"];
        if (!repeatNum) {
            [imageSet setValue:[NSNumber numberWithInt:0] forKey:@"RepeatCount"];
        }

        [resDict setObject:imageSet forKey:animName];
    }
    
    return resDict;
}

+ (void)applyAnimation:(NSDictionary*)anim toView:(UIImageView*)view
{
    view.animationImages = nil;
    [view stopAnimating];
    view.animationImages = [anim objectForKey:@"Frames"];
    view.animationDuration = [[anim valueForKey:@"Duration"] doubleValue];
    view.animationRepeatCount = [[anim valueForKey:@"RepeatCount"] intValue];
    [view startAnimating];
}

@end
