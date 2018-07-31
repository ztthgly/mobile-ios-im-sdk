//
//  ZTEmptyView.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/22.
//  Copyright © 2018年 殷佳亮. All rights reserved.
//

#import "ZTEmptyView.h"

@interface ZTEmptyView()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIButton *detailTextBtn;

@property (strong, nonatomic) IBOutlet UIButton *actionButton;


@end

@implementation ZTEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    self.imageView.hidden = !image;
    [self setNeedsLayout];
}

- (void)setTextLabelText:(NSString *)text {
    self.textLabel.text = text;
    self.textLabel.hidden = !text;
    [self setNeedsLayout];
}

- (void)setDetailLabelText:(NSAttributedString *)text {
    self.detailTextBtn.hidden = !text;
    
    // 防止文字闪动
    self.detailTextBtn.titleLabel.attributedText = text;
    [self.detailTextBtn setAttributedTitle:text forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)setActionButtonTitle:(NSString *)title {
    [self.actionButton setTitle:title forState:UIControlStateNormal];
    self.actionButton.hidden = !title;
    [self setNeedsLayout];
}

@end
