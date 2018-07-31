//
//  ZTTextRightMessageCell.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/31.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTTextRightMessageCell.h"
#import "ZTExpressionManager.h"

@interface ZTTextRightMessageCell()
@end

@implementation ZTTextRightMessageCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentTF.textColor = [ZTUIConfiguration appearance].textMsgRightColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        self.bubbleImageView.image = [ZTUIConfiguration appearance].msgRightItemBgSelcted;
    } else {
        self.bubbleImageView.image = [ZTUIConfiguration appearance].msgRightItemBgNormol;
    }
}

@end
