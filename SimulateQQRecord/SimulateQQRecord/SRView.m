//
//  SRView.m
//  SimulateQQVoiceRecord
//
//  Created by trq on 17/3/13.
//  Copyright © 2017年 Jean. All rights reserved.
//

#import "SRView.h"
#import "SRRecordButton.h"
#import <Masonry.h>
#import "SRBottomView.h"
#import "SRRecordManager.h"
#import "SpectrumView.h"
#import "QQAlertView.h"

#define kScaleHeight ScreenHeight/667
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define kSRViewBackgroundColor UIColorFromRGB(0xf4f4f4)
#define kSRViewTextLabelTextColor UIColorFromRGB(0x6d6d6d)
#define kSRViewTextLabelFont [UIFont systemFontOfSize:12]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kScaleHeight ScreenHeight/667
@interface SRView ()<
SRBottomViewDelegate
>
{
    NSString *_recordPath;
    NSString *_recordDuration;
}

@property (nonatomic, assign) SRState state;//表示录音所处的状态
@property (nonatomic, strong) UILabel *labelText;
@property (nonatomic, strong) SRRecordButton *buttonSR;
@property (nonatomic, strong) SRBottomView *bottomView;
@property (nonatomic, strong) SRRecordManager *recordManager;
@property (nonatomic, strong) SpectrumView *viewVoiceFrequency;
@property (nonatomic, strong) UIView *viewMask;

@property (nonatomic, strong) QQAlertView *viewQQAlert;

@end

@implementation SRView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)createSRView {
    
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.state = SRStateDefault;
        
        self.backgroundColor = kSRViewBackgroundColor;
        
        self.clipsToBounds = NO;
        
        [self addSubview:self.labelText];
        [self addSubview:self.buttonSR];
        [self addSubview:self.bottomView];
        
        
        /* 并没有用到 */
//        [self.buttonSR addObserver:self forKeyPath:@"stateA" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
//        self.bottomView.backgroundColor = [UIColor orangeColor];
//        self.labelText.backgroundColor = [UIColor orangeColor];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [self.labelText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(52*kScaleHeight);
        
    }];
    
    [self.buttonSR mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
//        make.centerY.mas_equalTo(0);
        make.top.equalTo(self.labelText.mas_bottom).offset(12*kScaleHeight);
        make.height.width.mas_equalTo(kSRButtonWidth);
        
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(kSRBottomViewHeight);
    }];
}

#pragma mark - setter && getter
- (SRRecordButton *)buttonSR {
    if (!_buttonSR) {
        _buttonSR = [SRRecordButton createSRButton];
        [_buttonSR addTarget:self action:@selector(btnRecordClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _buttonSR;
}

- (SRBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [SRBottomView createSRBottomViewWithDelegate:self];
        _bottomView.hidden = YES;
        
    }
    return _bottomView;
}

- (UILabel *)labelText {
    if (!_labelText) {
        _labelText = [[UILabel alloc] init];
        _labelText.textColor = kSRViewTextLabelTextColor;
        _labelText.text = @"点击录音";
        _labelText.font = kSRViewTextLabelFont;
        
    }
    return _labelText;
}

- (SRRecordManager *)recordManager {
    if (!_recordManager) {
        _recordManager = [SRRecordManager soundRecordManager];
        
        __weak SRView *weakSelf = self;
        _recordManager.maxTimeCompletion = ^(NSString *recordPath,NSString *recordDuration) {
            
            NSLog(@"这里到了最大时长");
            weakSelf.state = SRStateFinish;
            weakSelf.buttonSR.stateA = SRStateFinish;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.viewQQAlert showQQAlert];
            });
            
        };
    }
    return _recordManager;
}

- (SpectrumView *)viewVoiceFrequency {
    if (!_viewVoiceFrequency) {
        
        CGFloat width = 100;
        CGFloat top = 52*kScaleHeight;
        CGFloat height = 20;
        _viewVoiceFrequency = [[SpectrumView alloc] initWithFrame:CGRectMake(CGRectGetMidX([UIScreen mainScreen].bounds)-width/2.0, top, width, height)];
//        _viewVoiceFrequency.center = CGPointMake(ScreenWidth/2.0, 52*kScaleHeight+6);
//        _viewVoiceFrequency.bounds = CGRectMake(0, 0, 100, 20);
//        _viewVoiceFrequency.backgroundColor = [UIColor cyanColor];
        
    }
    return _viewVoiceFrequency;
}

- (UIView *)viewMask {
    if (!_viewMask) {
        /*
            这个遮罩，，，
            在开始录音时出来，
            取消录音或者确定后消失，，
         
         */
        
        _viewMask = [[UIView alloc] init];
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
        /*
            这里要计算一下遮罩视图的y，，，，，因为遮罩是加在这个视图外部的
         */
        CGFloat y = kSRViewHeight - height;
        
        _viewMask.frame = CGRectMake(0, 0, width, -y);
        
        _viewMask.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
        
    }
    return _viewMask;
}

- (QQAlertView *)viewQQAlert {
    if (!_viewQQAlert) {
        _viewQQAlert = [QQAlertView createQQAlertView];
        
    }
    return _viewQQAlert;
}

#pragma mark - SRBottomViewDelegate
- (void)bottomView:(SRBottomView *)bottomView buttonDidClicked:(SRBottomButtonFunction)function {
    
    switch (function) {
        case SRBottomButtonFunctionCancle:
        {
            /*
             
                这里点了取消录音操作
                变化：
                1.按钮的状态改变
                2.需要删除录音
             
             */
            
            [self.recordManager cancelRecordSoundWithCancleRecordCompletion:^(BOOL isSuccess) {
                if (isSuccess) {
                    //这里表示录音删除成功的话，才改变状态
                    self.buttonSR.stateA = SRStateDefault;
                    self.bottomView.hidden = YES;
                    [self.viewVoiceFrequency removeFromSuperview];
                }
                
            }];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(sr_viewDidCancel:)]) {
                [self.delegate sr_viewDidCancel:self];
            }
            
        }
            break;
        case SRBottomButtonFunctionConform:
        {
            /*
                确定的话，我这里，需要将已经录制好的录音的URL放出去，
                这里得来一个代理
             */
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(sr_viewDidConfirm:recordPath:duration:)]) {
                if (_recordPath) {
                    
                    [self.delegate sr_viewDidConfirm:self recordPath:_recordPath duration:_recordDuration];
                }
            }
            
            /*
                并且录音，，，回到默认状态
             */
            
        }
            break;
            
        default:
            break;
    }
    self.state = SRStateDefault;
    self.buttonSR.stateA = SRStateDefault;
    [self.viewMask removeFromSuperview];
}

- (void)setState:(SRState)state {
    _state = state;
    
    switch (state) {
        case SRStateDefault:
        {
            if (self.viewVoiceFrequency) {
                [self.viewVoiceFrequency removeFromSuperview];
            }
            self.bottomView.hidden = YES;
            self.viewVoiceFrequency.hidden = YES;
            self.labelText.hidden = NO;
        }
            break;
        case SRStateReadying:
        {
            
        }
            break;
        case SRStateIng:
        {
            /*
                开始录音的时候，
                要加一个遮罩，
                显示出来底部的按钮
             */
            
            self.viewVoiceFrequency.hidden = NO;
            self.labelText.hidden = YES;
            
            [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self.viewMask];
            
            [self addSubview:self.viewVoiceFrequency];
            
            [self.recordManager prepareRecordSoundWithParepareRecordCompletion:^BOOL{
                
                return YES;
            }];
            
            self.viewVoiceFrequency.itemLevelCallback = ^() {
                
            };
            __weak SpectrumView *weakView = self.viewVoiceFrequency;
            
            self.recordManager.peakPowerForChannel = ^(float peakPowerForChannel,NSString *currentTime) {
                //在这里可以得到音频音量的变化
                
                weakView.level = peakPowerForChannel;
                weakView.text = currentTime;
            };
            [self.recordManager startRecordSoundWithStartRecordCompletion:^{
                
            }];
        }
            break;
        case SRStateStop:
        {
            
        }
            break;
        case SRStateFinish:
        {
            
            self.bottomView.hidden = NO;
            [self.recordManager finishRecordSoundWithFinishRecordCompletion:^(NSString *recordPath,NSString *recordDuration) {
                NSLog(@"录音路径 %@",recordPath);
                _recordPath = recordPath;
                _recordDuration = recordDuration;
            }];
        }
            break;
        case SRStatePlaying:
        {
            /*
                这里要处理的东西
             1.如果录音正处于播放ing状态，点击使录音进入播放完成状态（播放完成状态的录音进度条为0）
             2.如果录音播放完成，自动进入播放完成状态
             
             */
            
            __weak SpectrumView *weakView = self.viewVoiceFrequency;
            [self.recordManager startPlaySoundWithProgress:^(float progress) {
                self.buttonSR.progress = progress;
                if (progress >= 1) {
                    NSLog(@"录音已经播放完成");
                    self.state = SRStatePlayFinish;
                    self.buttonSR.stateA = SRStatePlayFinish;
//                    [self.recordManager stopPlaySound];
                }
            } peakPowerForChannel:^(float peakPowerForChannel, NSString *currentTime) {
                
                weakView.level = peakPowerForChannel;
                weakView.text = currentTime;
                
            }];
        }
            break;
        case SRStatePlayFinish:
        {
            [self.recordManager stopPlaySound];
            self.viewVoiceFrequency.text = _recordDuration;
            self.buttonSR.progress = 0.0;
        }
            break;
        default:
            break;
    }
}

#pragma mark - button clicked
- (void)btnRecordClicked {
    /*
     
     按钮本身有它自己的状态，但是，这里我还加了一个表示一个总状态的属性值
     我在录音按钮的点击方法中，对按钮的所处的状态进行改变，，（这里有点纠结，这一步是该写到按钮类里边？还是写到外部？？？？（还是写到外部了，因为这是在外部给按钮添加的方法））
     
     然后改变按钮的状态：
        按钮本身为Default:
            点击一下进入ing状态，按钮的状态改变，总状态改变
        本身为Ing:
            点击进入Finish状态，按钮的状态改变，总状态改变
        本身为Finish:
            点击进入Playing状态，按钮的状态改变，总状态改变
        本身为Playing:
            点击进入Finish状态，按钮的状态改变，总撞碎改变
     
     额外的东西：
        这里需要一个计时器：这个计时器，用来控制动画，用来计时，录音要有最长录音时间，（这里有一个问题，如何来判断录音是否播放完成呢？？有没有播放完成的通知？？）因为我这里要在录音播放完成的时候，做相应的状态改变
     
     */
    
    switch (self.buttonSR.stateA) {
        case SRStateDefault:
        {
            self.buttonSR.stateA = SRStateIng;
            
        }
            break;
        case SRStateReadying:
        {
            self.buttonSR.stateA = SRStateReadying;
        }
            break;
        case SRStateIng:
        {
            self.buttonSR.stateA = SRStateFinish;
            
        }
            break;
        case SRStateStop:
        {
            //现在还不要这个暂停功能
        }
            break;
        case SRStateFinish:
        {
            self.buttonSR.stateA = SRStatePlaying;
            
        }
            break;
        case SRStatePlaying:
        {
            self.buttonSR.stateA = SRStatePlayFinish;
            
        }
            break;
        case SRStatePlayFinish:
        {
            self.buttonSR.stateA = SRStatePlaying;
            
        }
            break;
        default:
            break;
    }
    self.state = self.buttonSR.stateA;
}

#pragma mark - kvo
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
}

@end
