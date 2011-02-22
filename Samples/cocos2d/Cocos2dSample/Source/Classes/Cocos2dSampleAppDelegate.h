//
//  Cocos2dSampleAppDelegate.h
//  Cocos2dSample
//
//  Created by nikan on 2/22/11.
//  Copyright Anton Nikolaienko 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface Cocos2dSampleAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
