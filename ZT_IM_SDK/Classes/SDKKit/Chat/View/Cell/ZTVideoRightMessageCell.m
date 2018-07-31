//
//  ZTVideoRightMessageCell.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/1.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTVideoRightMessageCell.h"
#import "UIImageView+bubble.h"

@implementation ZTVideoRightMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.thumbnailImageView setBubbleImage:[ZTUIConfiguration appearance].msgRightItemBgNormol];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
