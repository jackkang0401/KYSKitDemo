//
//  KYSMediaTiming.m
//  KCoreAnimationDemo
//
//  Created by Liu Zhao on 16/3/3.
//  Copyright © 2016年 Liu Dehua. All rights reserved.
//

#import "KYSMediaTiming.h"

@implementation KYSMediaTiming

- (instancetype)init{
    self=[super init];
    if (self) {
        self.repeatCount=0;
        self.repeatDuration=0;
        self.timeOffset=0;
        self.beginTime=0;
        self.speed=1;
        self.autoreverses=NO;
        self.fillMode=@"removed";
    }
    return self;
}


@end
