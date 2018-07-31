//
//  ZTAudioLeftMessageCell.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/1.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTAudioLeftMessageCell.h"
#import "ZTPlayerManager.h"

@interface ZTAudioLeftMessageCell()
@property(nonatomic, strong) ZTSendMessageV0 *vo;
@end

@implementation ZTAudioLeftMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    __weak __typeof(self)weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:ZTPlayerDidStartPlayNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf stop];
    }];
    [[ZTPlayerManager sharedInstance] addObserver:self forKeyPath:@"playStatus" options:NSKeyValueObservingOptionNew context:nil];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPressedTapGesturRecognizer:)];
    [self.bubbleImageView addGestureRecognizer:tapRecognizer];
    self.audioImageView.animationImages = @[UIImageMake(@"audio_left_3"),UIImageMake(@"audio_left_2"), UIImageMake(@"audio_left_1")];
    self.audioImageView.animationDuration = 1.0;
    self.audioImageView.image = UIImageMake(@"audio_left_3");
}

- (void)stop {
    [self.audioImageView stopAnimating];
}
- (void)updateCellWithVo:(ZTSendMessageV0 *)vo {
    [super updateCellWithVo:vo];
    self.vo = vo;
    int audioDuration;
    if (vo.audioDuration) {
        audioDuration = vo.audioDuration;
    } else {
        audioDuration = [ZTHelper getAudioDurationWithUrlString:vo.content];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%d’’",(int)audioDuration];
    switch (vo.status) {
        case ZTSendMessageStatusSending:
            self.timeLabel.hidden = YES;
            break;
        case ZTSendMessageStatusError:
        case ZTSendMessageStatusSuccess:
            self.timeLabel.hidden = false;
    }
}
- (IBAction)onPressedTapGesturRecognizer:(UITapGestureRecognizer *)sender {
    if (self.vo && self.vo.content) {
        [[ZTPlayerManager sharedInstance] playWithUrl:[NSURL URLWithString:self.vo.content]];
        [self.audioImageView startAnimating];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if ([keyPath isEqualToString:@"playStatus"]) {
        ZTPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (status == ZTPlayerStatusFinished) {
            [self stop];
        }
    }
}

@end
