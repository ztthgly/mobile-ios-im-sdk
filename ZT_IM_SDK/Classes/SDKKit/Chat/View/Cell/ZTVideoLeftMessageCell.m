//
//  ZTVideoLeftMessageCell.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/1.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTVideoLeftMessageCell.h"
#import "ZTPlayerManager.h"
#import "UIImageView+bubble.h"

@interface ZTVideoLeftMessageCell()

@property(nonatomic, strong) ZTSendMessageV0 *vo;
@end

@implementation ZTVideoLeftMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.thumbnailImageView setBubbleImage:[ZTUIConfiguration appearance].msgLeftItemBgNormol];
}

- (void)updateCellWithVo:(ZTSendMessageV0 *)vo {
    [super updateCellWithVo:vo];
    
    if (!self.thumbnailImageView.image) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *image = [ZTHelper getVideoFirstFrameImage:vo.content];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.thumbnailImageView.image = image;
            });
        });
    }
}

- (IBAction)onPressedPlayBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(videoMessageCell:didClickedPlayBtn:sendMessageVO:)]) {
        [self.delegate videoMessageCell:self didClickedPlayBtn:sender sendMessageVO:self.vo];
    }
}

@end


