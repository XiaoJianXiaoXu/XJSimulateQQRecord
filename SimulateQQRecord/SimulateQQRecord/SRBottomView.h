//
//  SRBottomView.h
//  SimulateQQVoiceRecord
//
//  Created by trq on 17/3/14.
//  Copyright © 2017年 Jean. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRBottomView;
#define kSRBottomViewHeight 44*kScaleHeight

typedef NS_ENUM(NSInteger, SRBottomButtonFunction) {
    SRBottomButtonFunctionCancle,
    SRBottomButtonFunctionConform
};

@protocol SRBottomViewDelegate <NSObject>

- (void)bottomView:(SRBottomView *)bottomView buttonDidClicked:(SRBottomButtonFunction)function;

@end

@interface SRBottomView : UIView

+ (instancetype)createSRBottomViewWithDelegate:(id <SRBottomViewDelegate>)delegate;

@end
