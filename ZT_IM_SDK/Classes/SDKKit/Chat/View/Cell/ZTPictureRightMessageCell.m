//
//  ZTPictureRightMessageCell.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/1.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTPictureRightMessageCell.h"
#import "UIImageView+bubble.h"

@interface ZTPictureRightMessageCell()

@end

@implementation ZTPictureRightMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.picImageView setBubbleImage:[ZTUIConfiguration appearance].msgRightItemBgNormol];
}

@end
