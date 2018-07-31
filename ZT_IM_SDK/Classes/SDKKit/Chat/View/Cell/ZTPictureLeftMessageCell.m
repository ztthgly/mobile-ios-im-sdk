//
//  ZTPictureLeftMessageCell.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/1.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTPictureLeftMessageCell.h"
#import "NSObject+ZTKit.h"
#import "UIImageView+bubble.h"
#import "ZTPreviewPhotoView.h"

@import YYWebImage;
@interface ZTPictureLeftMessageCell()
@property(nonatomic, strong) ZTSendMessageV0 *vo;
@end

@implementation ZTPictureLeftMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // 设置bubble
    [self.picImageView setBubbleImage:[ZTUIConfiguration appearance].msgLeftItemBgNormol];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPressedTapGesturRecognizer:)];
    [self.picImageView addGestureRecognizer:tapRecognizer];
}

- (void)updateCellWithVo:(ZTSendMessageV0 *)vo {
    [super updateCellWithVo:vo];
    self.vo = vo;
    if (vo.image) {
        self.picImageView.image = vo.image;
    } else {
        NSArray *array = [vo.content componentsSeparatedByString:@","];
        NSString *URLString = array.firstObject;
        [self.picImageView setImageWithUrlString:[URLString resizeStringWithSize:CGSizeMake(self.picImageView.frame.size.width, self.picImageView.frame.size.height)]];
        
    }
}

- (IBAction)onPressedTapGesturRecognizer:(UITapGestureRecognizer *)sender {
    END_EDITING;
    if (!self.picImageView.image) {
        return;
    }
    ZTPreviewPhotoView *preview = [[ZTPreviewPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds picture:self.picImageView.image];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.duration = 0.5;
    [preview.layer addAnimation:transition forKey:nil];
    
    [[UIApplication sharedApplication].keyWindow addSubview:preview];
}

@end
