//
//  TouchTracker.m
//  WorshipBox
//
//  Created by nikan on 6/4/10.
//  Copyright 2010 Anton Nikolaienko. All rights reserved.
//

#import "TouchTracker.h"


@implementation TouchTracker

@synthesize delegate, point, rect, active;

- (id)initWithRect:(CGRect)r
{
    if ((self = [super init])) {
        rect = r;
        point = CGPointZero;
        active = YES;
    }
    return self;
}

- (id)initWithSpriteRect:(CCSprite*)sprite
{
    return [self initWithRect:CGRectMake(sprite.position.x - sprite.anchorPoint.x * sprite.contentSize.width,
                                         sprite.position.y - sprite.anchorPoint.y * sprite.contentSize.height,
                                         sprite.contentSize.width, sprite.contentSize.height)];
}


#pragma mark -

- (void)updateRectFromSprite:(CCSprite*)sprite
{
    self.rect = CGRectMake(sprite.position.x - sprite.anchorPoint.x * sprite.contentSize.width,
                           sprite.position.y - sprite.anchorPoint.y * sprite.contentSize.height,
                           sprite.contentSize.width, sprite.contentSize.height);
}


#pragma mark -

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!active) return NO;
    
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint convertedPoint = [[CCDirector sharedDirector] convertToGL:location];
    if (CGRectContainsPoint(rect, convertedPoint)) {
        point = convertedPoint;
        
        if ([delegate respondsToSelector:@selector(touchTrackerTouchDidBegin:)]) {
            [delegate touchTrackerTouchDidBegin:self];
        }
        
        return YES;
    }
    
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!active) return;

    CGPoint location = [touch locationInView:[touch view]];
    CGPoint convertedPoint = [[CCDirector sharedDirector] convertToGL:location];
    point = convertedPoint;
    
    if ([delegate respondsToSelector:@selector(touchTrackerTouchDidMove:)]) {
        [delegate touchTrackerTouchDidMove:self];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!active) return;

    CGPoint location = [touch locationInView:[touch view]];
    CGPoint convertedPoint = [[CCDirector sharedDirector] convertToGL:location];
    point = convertedPoint;
    
    if ([delegate respondsToSelector:@selector(touchTrackerTouchDidEnd:)]) {
        [delegate touchTrackerTouchDidEnd:self];
    }

    if (CGRectContainsPoint(rect, convertedPoint)) {
        if ([delegate respondsToSelector:@selector(touchTrackerDidTouch:)]) {
            [delegate touchTrackerDidTouch:self];
        }
    }
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!active) return;
    [self ccTouchEnded:touch withEvent:event];
}

@end
