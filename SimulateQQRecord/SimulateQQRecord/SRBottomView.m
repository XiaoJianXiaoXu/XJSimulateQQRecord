//
//  SRBottomView.m
//  SimulateQQVoiceRecord
//
//  Created by trq on 17/3/14.
//  Copyright © 2017年 Jean. All rights reserved.
//

#import "SRBottomView.h"
#import <Masonry.h>
#define kScaleHeight ScreenHeight/667
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define kSRBottomViewTextColor UIColorFromRGB(0xe0a34c)
#define kSRBottomViewLineColor UIColorFromRGB(0xdcdedd)

#define kSRBottomViewLineWidth 1.0
#define kSRBottomViewTextFont [UIFont systemFontOfSize:15.0]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface SRBottomView ()

/**
 *  button cancle
 */
@property (nonatomic, strong) UIButton *buttonCancle;
/**
 *  button conform
 */
@property (nonatomic, strong) UIButton *buttonConform;
/**
 *  delegate
 */
@property (nonatomic, assign) id <SRBottomViewDelegate> delegate;

@end

@implementation SRBottomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    /*
        我在这里要画线，，，一横 一竖
        横在顶部 宽1
        竖贯穿 中部
     */
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 setLineWidth:kSRBottomViewLineWidth];
    [kSRBottomViewLineColor setStroke];
    
    [path1 moveToPoint:CGPointMake(0, 0)];
    [path1 addLineToPoint:CGPointMake(ScreenWidth, 0)];
    
    [path1 moveToPoint:CGPointMake(ScreenWidth/2-kSRBottomViewLineWidth/2.0, 1)];
    [path1 addLineToPoint:CGPointMake(ScreenWidth/2-kSRBottomViewLineWidth/2.0, kSRBottomViewHeight)];
    
    [path1 stroke];
    
}

+ (instancetype)createSRBottomViewWithDelegate:(id <SRBottomViewDelegate>)delegate {
    
    return [[self alloc] initWithDelegate:delegate];
}

- (instancetype)initWithDelegate:(id <SRBottomViewDelegate>)delegate {
    if (self = [super init]) {
        
        self.delegate = delegate;
        
        [self addSubview:self.buttonCancle];
        [self addSubview:self.buttonConform];
        
        self.backgroundColor = [UIColor whiteColor];
//        self.buttonConform.backgroundColor = [UIColor yellowColor];
//        self.buttonCancle.backgroundColor = [UIColor cyanColor];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [self.buttonCancle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.mas_equalTo(0);
        
    }];
    [self.buttonConform mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.bottom.mas_equalTo(0);
        make.left.equalTo(self.buttonCancle.mas_right);
        make.width.equalTo(self.buttonCancle.mas_width);
        
    }];
}

#pragma mark - setter && getter
- (UIButton *)buttonCancle {
    if (!_buttonCancle) {
        _buttonCancle = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonCancle setTitle:@"取消" forState:UIControlStateNormal];
        _buttonCancle.tag = 10;
        
        [_buttonCancle setTitleColor:kSRBottomViewTextColor forState:UIControlStateNormal];
        
        [_buttonCancle addTarget:self action:@selector(btnClickedHandle:) forControlEvents:UIControlEventTouchUpInside];
        _buttonCancle.titleLabel.font = kSRBottomViewTextFont;
    }
    return _buttonCancle;
}

- (UIButton *)buttonConform {
    if (!_buttonConform) {
        _buttonConform = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonConform.tag = 20;
        [_buttonConform setTitle:@"发送" forState:UIControlStateNormal];
        [_buttonConform setTitleColor:kSRBottomViewTextColor forState:UIControlStateNormal];
        
        [_buttonConform addTarget:self action:@selector(btnClickedHandle:) forControlEvents:UIControlEventTouchUpInside];
        _buttonConform.titleLabel.font = kSRBottomViewTextFont;
    }
    return _buttonConform;
}

- (void)btnClickedHandle:(UIButton *)sender {
    
    SRBottomButtonFunction function = SRBottomButtonFunctionCancle;
    if (sender.tag == 10) {
        //点击的取消按钮
    }
    else {
        //点击的确定按钮
        function = SRBottomButtonFunctionConform;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:buttonDidClicked:)]) {
        
        [self.delegate bottomView:self buttonDidClicked:function];
        
    }
    
}

@end
