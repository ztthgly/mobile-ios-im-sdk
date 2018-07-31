//
//  ZTSecretTrainRecorder.m
//  ZTRecord
//
//  Created by Spring on 2017/4/26.
//  Copyright © 2017年 Spring. All rights reserved.
//

#import "ZTRecorderManager.h"

#define ZTSecretTrainRecordFielName @"lvRecord.m4a"

@interface ZTRecorderManager()<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
//录音文件地址
@property (nonatomic, strong) NSURL *recordFileUrl;

@property (nonatomic, strong) AVAudioSession *session;

@end

@implementation ZTRecorderManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ZTRecorderManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)startRecording
{
    // 录音时停止播放 删除曾经生成的文件
    [self destructionRecordingFile];
    // 真机环境下需要的代码
    self.session = [AVAudioSession sharedInstance];
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [self.recorder record];
}

- (void)stopRecording
{
    if ([self.recorder isRecording])
    {
        [self.recorder stop];
    }
}

#pragma mark - 懒加载
- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        // 1.获取沙盒地址
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:ZTSecretTrainRecordFielName];
        self.recordFileUrl = [NSURL fileURLWithPath:filePath];
//        ZT_Log(@"%@", filePath);
        
        // 3.设置录音的一些参数
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        // 音频格式
        setting[AVFormatIDKey] = @(kAudioFormatMPEG4AAC);
        // 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
        setting[AVSampleRateKey] = @(16000.0);
        // 音频通道数 1 或 2
        setting[AVNumberOfChannelsKey] = @(1);
        // 线性音频的位深度  8、16、24、32
        setting[AVLinearPCMBitDepthKey] = @(16);
        //录音的质量
        setting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityHigh];

        _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:setting error:NULL];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
        
        [_recorder prepareToRecord];
    }
    return _recorder;
}

- (void)destructionRecordingFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (self.recordFileUrl)
    {
        [fileManager removeItemAtURL:self.recordFileUrl error:NULL];
    }
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    //录音结束
}
@end
