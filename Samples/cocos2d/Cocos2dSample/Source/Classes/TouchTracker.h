//
//  TouchTracker.h
//  WorshipBox
//
//  Created by nikan on 6/4/10.
//  Copyright 2010 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TouchTrackerDelegate;

@interface TouchTracker : NSObject <CCTargetedTouchDelegate> {
    id<TouchTrackerDelegate> delegate;
    CGRect rect;
    CGPoint point;
    
    BOOL active;
}

- (id)initWithRect:(CGRect)r;
- (id)initWithSpriteRect:(CCSprite*)sprite;

- (void)updateRectFromSprite:(CCSprite*)sprite;

@property (nonatomic, assign) id<TouchTrackerDelegate> delegate;
@property (nonatomic, readonly) CGPoint point;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) BOOL active;

@end


@protocol TouchTrackerDelegate <NSObject>
@optional
- (void)touchTrackerDidTouch:(TouchTracker*)tracker;
- (void)touchTrackerTouchDidBegin:(TouchTracker*)tracker;
- (void)touchTrackerTouchDidMove:(TouchTracker*)tracker;
- (void)touchTrackerTouchDidEnd:(TouchTracker*)tracker;
@end

