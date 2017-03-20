//
//  SRButton.m
//  SimulateQQVoiceRecord
//
//  Created by trq on 17/3/13.
//  Copyright © 2017年 Jean. All rights reserved.
//

#import "SRRecordButton.h"
#import "XJCycleProgressView.h"

#define kScaleHeight ScreenHeight/667
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface SRRecordButton ()

@property (nonatomic, strong) UIButton *buttonMask;

@end

@implementation SRRecordButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)createSRButton {
    
//    SRRecordButton *button = [super buttonWithType:buttonType];
//    button.stateA = SRStateDefault;
//    
//    button.viewProgress = [XJCycleProgressView createCycleProgressViewWithCenter:CGPointMake(50, 50) sideLength:100];
//    
//    return button;
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.stateA = SRStateDefault;
        [self addSubview:self.viewProgress];
        [self addSubview:self.buttonMask];
        
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    
    [self.buttonMask addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setStateA:(SRState)stateA {
    _stateA = stateA;
    UIImage *imageBG = NULL;
    switch (stateA) {
        case SRStateDefault:
        {
            /*
             录音还未开始
             */
            imageBG = [UIImage imageNamed:@"SR_default"];
//            self.backgroundColor = [UIColor whiteColor];
        }
            break;
        case SRStateReadying:
        {
            /*
             准备阶段，录音按钮不做变化
             */
        }
            break;
        case SRStateIng:
        {
            /*
             正在录音
             */
            imageBG = [UIImage imageNamed:@"SR_ing"];
//            self.backgroundColor = [UIColor redColor];
        }
            break;
        case SRStateStop:
        {
            /*
             录音处在暂停状态
             */
            imageBG = [UIImage imageNamed:@"SR_stop"];
//            self.backgroundColor = [UIColor greenColor];
        }
            break;
        case SRStateFinish:
        {
            /*
             录音结束
             */
            imageBG = [UIImage imageNamed:@"SR_finish"];
//            self.backgroundColor = [UIColor blueColor];
        }
            break;
        case SRStatePlaying:
        {
            /*
             录音结束
             */
            imageBG = [UIImage imageNamed:@"SR_playing"];
//            self.backgroundColor = [UIColor orangeColor];
        }
            break;
        case SRStatePlayFinish:
        {
            imageBG = [UIImage imageNamed:@"SR_finish"];
//            self.backgroundColor = [UIColor redColor];
        }
            break;
        default:
            break;
    }
    
    [self setBackgroundImage:imageBG forState:UIControlStateNormal];
    
}

- (XJCycleProgressView *)viewProgress {
    if (!_viewProgress) {
        _viewProgress = [XJCycleProgressView createCycleProgressViewWithCenter:CGPointMake(kSRButtonWidth/2.0, kSRButtonWidth/2.0) sideLength:kSRButtonWidth];
        _viewProgress.lineWidth = 1.0;
//        _viewProgress.backgroundColor = [UIColor purpleColor];
    }
    return _viewProgress;
}

- (UIButton *)buttonMask {
    if (!_buttonMask) {
        _buttonMask = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonMask.center = CGPointMake(kSRButtonWidth/2.0, kSRButtonWidth/2.0);
        _buttonMask.bounds = CGRectMake(0, 0, kSRButtonWidth, kSRButtonWidth);
        
    }
    return _buttonMask;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    self.viewProgress.progress = progress;
}

@end
