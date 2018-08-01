//
//  ZTBaseVC.h
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/23.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTEmptyView.h"
#import "ZTUICommonDefine.h"
#import "ZTUIConfiguration.h"
#import "ZTConversationManager.h"
#import "ZTIM.h"

@interface ZTBaseVC : UIViewController <ZTConversationManagerDeleage>

#pragma mark - empty
@property(nonatomic, strong) ZTEmptyView *emptyView;
/**
 * 显示带image、text的emptyView
 */
- (void)showEmptyViewWithImage:(UIImage *)image
                          text:(NSString *)text;
/**
 * 显示带image、text、button的emptyView
 */
- (void)showEmptyViewWithImage:(UIImage *)image
                          text:(NSString *)text
                   buttonTitle:(NSString *)buttonTitle
                  buttonAction:(SEL)action;

- (void)showEmptyViewWithImage:(UIImage *)image
                          text:(NSString *)text
                    detailText:(NSAttributedString *)detailText
                   buttonTitle:(NSString *)buttonTitle
                  buttonAction:(SEL)action;

- (void)hideEmptyView;

#pragma mark - 子类覆盖
- (void)initSubviews NS_REQUIRES_SUPER;
// 返回方法
- (void)onPressedBack:(UIBarButtonItem *)item;

@end
