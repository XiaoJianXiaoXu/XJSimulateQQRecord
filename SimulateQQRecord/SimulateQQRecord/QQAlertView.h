//
//  QQAlertView.h
//  wuya
//
//  Created by trq on 17/3/20.
//  Copyright © 2017年 chengcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kQQAlertViewHeight 64
#define kQQAlertViewShowTime 3

#define kTextRecordMaxTime @"录音超过最大时长"

@interface QQAlertView : UIView

+ (instancetype)createQQAlertView;
- (void)showQQAlert;
- (void)dismissQQAlert;

@end
