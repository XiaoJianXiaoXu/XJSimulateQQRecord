//
//  SRView.h
//  SimulateQQVoiceRecord
//
//  Created by trq on 17/3/13.
//  Copyright © 2017年 Jean. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRView;
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScaleHeight ScreenHeight/667
#define kSRViewHeight 256*kScaleHeight

@protocol SRViewDelegate <NSObject>

- (void)sr_viewDidConfirm:(SRView *)view_SR recordPath:(NSString *)path duration:(NSString *)duration;
- (void)sr_viewDidCancel:(SRView *)view_SR;

@end

@interface SRView : UIView

@property (nonatomic, assign) id <SRViewDelegate> delegate;
+ (instancetype)createSRView;

@end
