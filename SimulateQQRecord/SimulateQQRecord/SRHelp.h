//
//  Header.h
//  SimulateQQVoiceRecord
//
//  Created by trq on 17/3/13.
//  Copyright © 2017年 Jean. All rights reserved.
//

#ifndef Header_h
#define Header_h
/*
 这里做一下，代码约束的说明：
 1.SR 是 SoundRecord的简称，在本模块中统一用SR代表
 
 
 */

#import "SRView.h"
#import "SRRecordButton.h"

typedef NS_ENUM(NSInteger, SRState) {
    SRStateDefault,
    SRStateReadying,/*准备中...*/
    SRStateIng,
    SRStateStop, /* 开始时是要暂停功能的，后来去掉了，，，，，，这就先留下来 */
    SRStateFinish,
    SRStatePlaying,
    SRStatePlayFinish
};




#endif /* Header_h */
