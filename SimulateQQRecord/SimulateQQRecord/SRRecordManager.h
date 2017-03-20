//
//  SRRecordHelper.h
//  SimulateQQVoiceRecord
//
//  Created by trq on 17/3/14.
//  Copyright © 2017年 Jean. All rights reserved.
//

/*
 
 这个类主要是用来录音的
 为什么要单独写一个类？
 将录音设置成一个单独的部分，易于管理，便于复用
 
 录音的话，同时只存在一个用于录音的对象，所以这里可以用一个单例
 
 */

#import <Foundation/Foundation.h>

#define kSRMaxRecordTime 600

typedef BOOL (^PrepareRecorderCompletion)();
typedef void (^StartRecorderCompletion)();
typedef void (^FinishRecorderCompletion)(NSString *recordPath,NSString *recordDuration);
typedef void (^StartPlaySoundCompletion)();
typedef void (^StopPlaySoundCompletion)();
typedef void (^CancelRecorderDeleteFileCompletion)(BOOL isSuccess);
typedef void (^RecordProgress)(float progress);
typedef void (^PeakPowerForChannel)(float peakPowerForChannel, NSString *currentTime);

typedef void (^PlayProgressBlock)(float progress);

@interface SRRecordManager : NSObject

@property (nonatomic, copy) NSString *recordDuration;

@property (nonatomic, copy) PeakPowerForChannel peakPowerForChannel;

@property (nonatomic, copy) FinishRecorderCompletion maxTimeCompletion;



+ (instancetype)soundRecordManager;

- (void)prepareRecordSoundWithParepareRecordCompletion:(PrepareRecorderCompletion)completion;
- (void)startRecordSoundWithStartRecordCompletion:(StartRecorderCompletion)completion;
- (void)finishRecordSoundWithFinishRecordCompletion:(FinishRecorderCompletion)completion;
- (void)cancelRecordSoundWithCancleRecordCompletion:(CancelRecorderDeleteFileCompletion)completion;

- (void)startPlaySoundWithProgress:(PlayProgressBlock)progressBlock peakPowerForChannel:(PeakPowerForChannel)peakPower;
- (void)stopPlaySound;

@end
