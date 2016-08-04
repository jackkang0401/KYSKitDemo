//
//  KYSMediaTiming.h
//  KCoreAnimationDemo
//
//  Created by Liu Zhao on 16/3/3.
//  Copyright © 2016年 Liu Dehua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KYSMediaTiming : NSObject

@property(nonatomic,assign) float repeatCount;

@property(nonatomic,assign) CFTimeInterval repeatDuration;

@property(nonatomic,assign) CFTimeInterval timeOffset;

@property(nonatomic,assign) CFTimeInterval beginTime;

@property(nonatomic,assign) float speed;

@property(nonatomic,assign) BOOL autoreverses;

/* Defines how the timed object behaves outside its active duration.
 * Local time may be clamped to either end of the active duration, or
 * the element may be removed from the presentation. The legal values
 * are `backwards', `forwards', `both' and `removed'. Defaults to
 * `removed'. */
@property(nonatomic,copy) NSString *fillMode;

@end
