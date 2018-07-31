//
//  ZTAudioRightMessageCell.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/1.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTAudioRightMessageCell.h"

@interface ZTAudioRightMessageCell()
@end

@implementation ZTAudioRightMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.audioImageView.animationImages = @[UIImageMake(@"audio_right_3"),UIImageMake(@"audio_right_2"), UIImageMake(@"audio_right_1")];
    self.audioImageView.animationDuration = 1.0;
    self.audioImageView.image = UIImageMake(@"audio_right_3");
}


@end
