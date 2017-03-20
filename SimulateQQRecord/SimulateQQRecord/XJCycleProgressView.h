//
//  XJCycleProgressView.h
//  SimulateQQVoiceRecord
//
//  Created by trq on 17/3/16.
//  Copyright © 2017年 Jean. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCircleColor UIColorFromRGB(0xe0a34c)

@interface XJCycleProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat lineWidth;

+ (instancetype)createCycleProgressViewWithCenter:(CGPoint)center sideLength:(CGFloat)length;

@end
