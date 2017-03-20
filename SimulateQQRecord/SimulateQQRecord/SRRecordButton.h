//
//  SRButton.h
//  SimulateQQVoiceRecord
//
//  Created by trq on 17/3/13.
//  Copyright © 2017年 Jean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRHelp.h"
@class XJCycleProgressView;

#define kSRButtonWidth 93*kScaleHeight

@interface SRRecordButton : UIButton

/**
 *  image
 */
@property (nonatomic, assign) SRState stateA;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) XJCycleProgressView *viewProgress;

+ (instancetype)createSRButton;

@end
