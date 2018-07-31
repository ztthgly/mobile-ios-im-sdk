//
//  ZTEmptyView.h
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/22.
//  Copyright © 2018年 殷佳亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTEmptyView : UIView

@property(nonatomic, strong, readonly) UIImageView *imageView;
@property(nonatomic, strong, readonly) UILabel *textLabel;
@property(nonatomic, strong, readonly) UIButton *actionButton;

/**
 * 设置要显示的图片
 * @param image 要显示的图片，为nil则不显示
 */
- (void)setImage:(UIImage *)image;

/**
 * 设置提示语
 * @param text 提示语文本，若为nil则隐藏textLabel
 */
- (void)setTextLabelText:(NSString *)text;

/**
 设置提示语

 @param text 提示语文本，若为nil则隐藏textLabel
 */
- (void)setDetailLabelText:(NSAttributedString *)text;

/**
 * 设置操作按钮的文本
 * @param title 操作按钮的文本，若为nil则隐藏actionButton
 */
- (void)setActionButtonTitle:(NSString *)title;
@end
