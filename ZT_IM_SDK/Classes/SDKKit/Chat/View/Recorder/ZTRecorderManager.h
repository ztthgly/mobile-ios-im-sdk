//
//  ZTSecretTrainRecorder.h
//  ZTRecord
//
//  Created by Spring on 2017/4/26.
//  Copyright © 2017年 Spring. All rights reserved.

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class ZTRecorderManager;
@protocol ZTSecretTrainRecorderDelegate <NSObject>

@optional
- (void)recorder:(ZTRecorderManager *)recorder didstartRecoring:(int)no;
- (void)recordToolDidFinishPlay:(ZTRecorderManager *)recorder;
@end
@interface ZTRecorderManager : NSObject

//录音工具的单例
+ (instancetype)sharedInstance;

@property(nonatomic, strong, readonly) NSURL *recordFileUrl;

//开始录音
- (void)startRecording;

//停止录音
- (void)stopRecording;

//销毁录音文件
- (void)destructionRecordingFile;

//录音对象
@property (nonatomic, strong) AVAudioRecorder *recorder;

@end
