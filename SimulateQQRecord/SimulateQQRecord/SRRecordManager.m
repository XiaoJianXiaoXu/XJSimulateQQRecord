//
//  SRRecordHelper.m
//  SimulateQQVoiceRecord
//
//  Created by trq on 17/3/14.
//  Copyright © 2017年 Jean. All rights reserved.
//

#import "SRRecordManager.h"
#import <AVFoundation/AVFoundation.h>

#define kSRRecordMaxTime 5//10//*60 //单位是秒

@interface SRRecordManager ()<AVAudioPlayerDelegate>
{
    NSTimer *_timerRecord;
    NSTimer *_timerPlayer;
    
}


@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, copy) NSString *recordPath;
@property (nonatomic, readwrite) NSTimeInterval currentTimeInterval;
@property (nonatomic, copy) PlayProgressBlock progressBlock;

@end

@implementation SRRecordManager

static SRRecordManager *_manager = nil;
+ (instancetype)soundRecordManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _manager = [[SRRecordManager alloc] init];
        
    });
    
    return _manager;
}

- (void)resetTimer {
    
    //在这个方法中将两个timer都重置
    
    if (!_timerRecord) {
    }
    else {
        [_timerRecord invalidate];
        _timerRecord = NULL;
    }
    
    if (!_timerPlayer) {
    }
    else {
        [_timerPlayer invalidate];
        _timerPlayer = NULL;
    }
    
}


- (void)finishRecording {
    /*
     完成录音
     需要将录音停止，并且制空
     计时器，需要停止并且制空
     
     */
    if (!_recorder) {
        return;
    }
    
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    self.recorder = NULL;
    [self resetTimer];
}

- (void)stopRecording {
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
}

- (void)prepareRecordSoundWithParepareRecordCompletion:(PrepareRecorderCompletion)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (![self activeAudioSession]) {
            return;
        }
        
        self.recordPath = [self getRecordPath];
        NSURL *url = [NSURL URLWithString:self.recordPath];
        
        NSDictionary *dicSetting = [self getRecordSetting];
        
        NSError *error = NULL;
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:dicSetting error:&error];
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return;
        }
        //        self.recorder.delegate = self;
        self.recorder.meteringEnabled = YES;
        [self.recorder recordForDuration:kSRMaxRecordTime];
        [self.recorder prepareToRecord];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
    
}

- (void)startRecordSoundWithStartRecordCompletion:(StartRecorderCompletion)completion {
    
    [self resetTimer];
    
    _timerRecord = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerHandle) userInfo:NULL repeats:YES];
    if (completion) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    }
    
}

- (void)finishRecordSoundWithFinishRecordCompletion:(FinishRecorderCompletion)completion {
    
    [self finishRecording];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getVoiceDuration:self.recordPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self.recordPath,self.recordDuration);
        });
        
    });
    
}

- (void)startPlaySoundWithProgress:(PlayProgressBlock)progressBlock peakPowerForChannel:(PeakPowerForChannel)peakPower {
    if (self.player) {
        [self.player stop];
        self.player = NULL;
    }
    
    self.progressBlock = progressBlock;
    self.peakPowerForChannel = peakPower;
    
    [self resetTimer];
    _timerPlayer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(playSoundTimerHandle) userInfo:nil repeats:YES];
    
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:self.recordPath] error:&error];
    self.player.meteringEnabled = YES;
    self.player.delegate = self;
    if (self.player) {
        
        if (!error) {
            [self.player play];
        }
    }
}

- (void)stopPlaySound {
    
    /*
        这里做的比较粗暴，，
        直接将计时器制空
        其实应该暂停即可
     
     */
    
    [self resetTimer];
    if (self.player) {
        [self.player stop];
    }
    
}

- (void)cancelRecordSoundWithCancleRecordCompletion:(CancelRecorderDeleteFileCompletion)completion {
    /*
     变成可取消状态后，录音已经被停 且 制空了
     
     所以这里，用 record delete 方法不能删除了
     */
    [self resetTimer];
    
    BOOL isSuccess = [self deleteRecordFile];
    if (completion) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(isSuccess);
        });
    }
    
}

- (void)playSoundTimerHandle {
    
    //这里计算录音播放进度
    CGFloat maxSoundLength = self.player.duration;
    CGFloat current = self.player.currentTime;
    CGFloat progress = current / maxSoundLength;
    if (self.progressBlock) {
        self.progressBlock(progress);
    }
    
    //这里计算当前播放录音的peakPower 和 当前时间
    [self.player updateMeters];
    CGFloat peakPower = [self.player averagePowerForChannel:0];
    /*
        我这里需要做一下时间的转换，，，，
        开始是秒    目地是 分.01（分后边两位小数）
     
        秒   - -> 分   除以 60
     
     */
    
//    NSString *currentTime = [NSString stringWithFormat:@"%.2f",current/60.0];
    NSString *currentTime = [self transfromTime:current];
    
    if (self.peakPowerForChannel) {
        self.peakPowerForChannel(peakPower,currentTime);
    }

}

- (void)timerHandle {
    
    /*
     
     1.我在这里还需要处理一个 最大录音时长，，，这个计时器 0.05s走一次这个方法，，，有一个最大时长，，大于等于这个时长时停止录音
     
     2.还要一个最小录音时长，，小于这个时长时，，，要提示录音时间太短，不让发送
     
     */
    
    if (!self.recorder) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.recorder updateMeters];
        self.currentTimeInterval = self.recorder.currentTime;

        float peakPower = [self.recorder averagePowerForChannel:0];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.peakPowerForChannel) {

//                self.peakPowerForChannel(peakPower,[NSString stringWithFormat:@"%.2f",self.currentTimeInterval/60.0]);
                self.peakPowerForChannel(peakPower,[self transfromTime:self.currentTimeInterval]);
            }
            
            NSLog(@"这是时间 %f",self.currentTimeInterval);
            
            if (self.currentTimeInterval > kSRRecordMaxTime) {
                //这里大于最大时长
                
                /* 这里不需要加结束操作，会在类外部作结束处理 */
//                [self finishRecording];
                if (self.maxTimeCompletion) {
                    [self getVoiceDuration:self.recordPath];
                    self.maxTimeCompletion(self.recordPath,self.recordDuration);
                }
            }
        });
    });
}

#pragma mark - setter && getter
- (NSString *)getRecordPath {
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *fileName = [dateFormatter stringFromDate:now];
    
    NSString *recordPath = NSHomeDirectory();
    recordPath = [NSString stringWithFormat:@"%@/Library/RecordSound/%@.m4a",recordPath,fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:[recordPath stringByDeletingLastPathComponent]]){
        [fm createDirectoryAtPath:[recordPath stringByDeletingLastPathComponent]
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    
    return recordPath;
}

- (BOOL)activeAudioSession {
    NSError *error = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&error];
    if(error) {
        NSLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
        return NO;
    }
    
    error = nil;
    [audioSession setActive:YES error:&error];
    if(error) {
        NSLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
        return NO;
    }
    return YES;
}

- (NSDictionary *)getRecordSetting {
    
    NSMutableDictionary *dicSetting = [NSMutableDictionary dictionary];
    
    //设置录音格式
    [dicSetting setObject:@(kAudioFormatMPEG4AAC) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率
    [dicSetting setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道，，，这里用单声道
    [dicSetting setObject:@(1) forKey:AVNumberOfChannelsKey];
    //设置采样点数 分为8、16、24、32
    [dicSetting setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //设置使用浮点数采样
    [dicSetting setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    return dicSetting;
}

- (void)getVoiceDuration:(NSString*)recordPath {
    NSError *error = nil;
    AVAudioPlayer *play = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:recordPath] error:&error];
    if (error) {
        self.recordDuration = @"";
    } else {

        double duration = play.duration;
        
        self.recordDuration = [self transfromTime:duration];
        
//        self.recordDuration = [NSString stringWithFormat:@"%.2f",duration/60.0];
    }
}

- (BOOL)deleteRecordFile {
    
    if (self.recordPath) {

        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:self.recordPath]) {
            NSError *error = NULL;
            [manager removeItemAtPath:self.recordPath error:&error];
            if (error) {
                NSLog(@"移除文件error : %@",error.description);
                //文件删除失败
                return NO;
            }
            //文件删除成功
            return YES;
            
        }
        else {
            //路径下文件不存在，直接算文件删除成功
            return YES;
        }
    }
    else {
        //路径不存在，直接算删除成功
        return YES;
    }
}

#pragma mrak - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    self.progressBlock(1.0);
    [self resetTimer];
    
}

- (NSString *)transfromTime:(double)duration {
    //表示商
    NSInteger over = duration / 60;
    NSInteger remainder = (NSInteger)duration % 60;
    NSString *formate = [NSString stringWithFormat:@"%@:%02ld",@(over),(long)remainder];
    return formate;
}

@end
