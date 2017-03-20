//
//  QQAlertView.m
//  wuya
//
//  Created by trq on 17/3/20.
//  Copyright © 2017年 chengcheng. All rights reserved.
//

#import "QQAlertView.h"

#define kAnimationTime 0.5
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kTextColor UIColorFromRGB(0x945700)
#define kTextFont [UIFont systemFontOfSize:14]

@interface QQAlertView ()

@property (nonatomic, strong) UILabel *labelMessage;
@property (nonatomic, strong) UIImageView *imgViewAlert;

@end

@implementation QQAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init {
    if (self = [super init]) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, -kQQAlertViewHeight, CGRectGetWidth([UIScreen mainScreen].bounds), kQQAlertViewHeight);
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
        
        [self addSubview:self.labelMessage];
        [self addSubview:self.imgViewAlert];
        
        self.imgViewAlert.backgroundColor = [UIColor yellowColor];
        self.labelMessage.backgroundColor = [UIColor redColor];
        
    }
    return self;
}

+ (instancetype)createQQAlertView {
    return [[self alloc] init];
}

- (void)layoutSubviews {
    
//    [self.imgViewAlert mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.bottom.mas_equalTo(-20+5);
//        make.left.mas_equalTo(12);
//        
//    }];
    
    self.imgViewAlert.frame = CGRectMake(12, 24, 25, 25);
    self.labelMessage.frame = CGRectMake(CGRectGetMaxX(self.imgViewAlert.frame), CGRectGetMinY(self.imgViewAlert.frame), 200, 25);
    
//    [self.labelMessage mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerY.equalTo(self.imgViewAlert.mas_centerY);
//        make.left.equalTo(self.imgViewAlert.mas_right).offset(9);
//        
//    }];
    
}

#pragma mark - setter and getter
- (UILabel *)labelMessage {
    if (!_labelMessage) {
        _labelMessage = [[UILabel alloc] init];
        _labelMessage.textAlignment = NSTextAlignmentCenter;
        _labelMessage.numberOfLines = 1;
        _labelMessage.text = kTextRecordMaxTime;
        _labelMessage.textColor = kTextColor;
        _labelMessage.font = kTextFont;
    }
    return _labelMessage;
}

- (UIImageView *)imgViewAlert {
    if (!_imgViewAlert) {
        _imgViewAlert = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SR_QQAlert"]];
        
    }
    return _imgViewAlert;
}

- (void)showQQAlert {

//    [UIApplication sharedApplication].statusBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), kQQAlertViewHeight);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(dismissQQAlert) withObject:nil afterDelay:kQQAlertViewShowTime];
    }];
    
}

- (void)dismissQQAlert {
    
//    [self removeFromSuperview];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.frame = CGRectMake(0, -kQQAlertViewHeight, CGRectGetWidth([UIScreen mainScreen].bounds), kQQAlertViewHeight);
    }];
}

@end
