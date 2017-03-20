//
//  SpectrumView.h
//  GYSpectrum
//
//  Created by 黄国裕 on 16/8/19.
//  Copyright © 2016年 黄国裕. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kItemColor UIColorFromRGB(0xe0a34c)

@interface SpectrumView : UIView

@property (nonatomic, copy) void (^itemLevelCallback)();

@property (nonatomic) NSUInteger numberOfItems;

@property (nonatomic) UIColor * itemColor;

@property (nonatomic) CGFloat level;

@property (nonatomic) UILabel *timeLabel;

@property (nonatomic) NSString *text;


@end
