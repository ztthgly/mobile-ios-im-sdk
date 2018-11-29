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
@import ESPictureBrowser;

@interface ZTPictureLeftMessageCell()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstranint;
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

- (void)prepareForReuse {
    [super prepareForReuse];
    self.picImageView.image = nil;
}

- (void)updateCellWithVo:(ZTSendMessageV0 *)vo {
    [super updateCellWithVo:vo];
    self.vo = vo;
    if (vo.image) {
        self.picImageView.image = vo.image;
    } else {
        NSArray *array = [vo.content componentsSeparatedByString:@","];
        NSString *URLString = array.firstObject;
        self.picImageView.image = nil;
        [self.picImageView setImageWithUrlString:URLString placeholder:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            vo.image = image;
        }];
    }
}

- (IBAction)onPressedTapGesturRecognizer:(UITapGestureRecognizer *)sender {
    END_EDITING;
    if (!self.vo.image) {
        return;
    }
    NSArray *array = [self.vo.content componentsSeparatedByString:@","];
    NSString *URLString = array.firstObject;
    
    ZTPreviewPhotoView *preview = [[ZTPreviewPhotoView alloc] initWithImage:self.vo.image highQualityURL:URLString inView:self.imageView];
}

@end
