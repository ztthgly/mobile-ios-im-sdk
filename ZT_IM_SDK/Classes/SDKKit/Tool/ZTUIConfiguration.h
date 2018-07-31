//
//  ZTUIConfiguration.h
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/23.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTUIConfiguration : UIView

#pragma mark - 导航栏
@property(nonatomic, assign) UIStatusBarStyle statusBarStyle UI_APPEARANCE_SELECTOR;
// 导航栏backGroudImage
@property(nonatomic, strong) UIImage *navBarBackgroundImage UI_APPEARANCE_SELECTOR;
// 导航栏文字填充颜色
@property(nonatomic, strong) UIColor *navBarBarTintColor UI_APPEARANCE_SELECTOR;

// 导航栏名称, 如何不设置则显示坐席信息
@property(nonatomic, strong) NSString *headerTitle UI_APPEARANCE_SELECTOR;
// 隐藏导航栏名称
@property(nonatomic, assign) BOOL hideHeaderTitle UI_APPEARANCE_SELECTOR;
// 导航栏Icon, 如果不设置则显示坐席头像
@property(nonatomic, strong) UIImage *headerIcon UI_APPEARANCE_SELECTOR;
// 隐藏导航栏的图像 默认为false, 隐藏icon
@property(nonatomic, assign) BOOL hideHeaderIcon UI_APPEARANCE_SELECTOR;
// 导航栏title大小
@property(nonatomic, assign) NSInteger titleLabelSize UI_APPEARANCE_SELECTOR;

#pragma mark - 整体
@property(nonatomic, strong) UIImage *msgBackgroundImage UI_APPEARANCE_SELECTOR;
// 主题色
@property(nonatomic, strong) UIColor *msgBackgroundColor UI_APPEARANCE_SELECTOR;

#pragma mark - 消息区
// 消息列表消息项间距
@property(nonatomic, assign) NSInteger msgListViewDividerHeight UI_APPEARANCE_SELECTOR;
// 隐藏左侧(客服消息)头像 默认false
@property(nonatomic, assign) BOOL hideLeftAvatar UI_APPEARANCE_SELECTOR;
// 隐藏右侧(访客消息)头像 默认false
@property(nonatomic, assign) BOOL hideRightAvatar UI_APPEARANCE_SELECTOR;
// 头像形状 默认为0，0为圆形头像，1为方形头像
@property(nonatomic, assign) NSInteger avatarShape UI_APPEARANCE_SELECTOR;

// 提示类消息的字体颜色（包括分配客服消息，消息时间标签等）
@property(nonatomic, strong) UIColor *tipsTextColor UI_APPEARANCE_SELECTOR;
// 提示类消息的字体大小（包括分配客服消息，消息时间标签等）
@property(nonatomic, assign) NSInteger tipsTextSize UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *tipsBackgroundColor UI_APPEARANCE_SELECTOR;

// 左边消息项背景,同时影响文本和语音消息
@property(nonatomic, strong) UIImage *msgLeftItemBgNormol UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIImage *msgLeftItemBgSelcted UI_APPEARANCE_SELECTOR;
// 右边消息项背景,同时影响文本和语音消息
@property(nonatomic, strong) UIImage *msgRightItemBgNormol UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIImage *msgRightItemBgSelcted UI_APPEARANCE_SELECTOR;
// 文本消息字体颜色
@property(nonatomic, strong) UIColor *textMsgLeftColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *textMsgRightColor UI_APPEARANCE_SELECTOR;
// 文本消息字体大小
@property(nonatomic, assign) NSInteger textMsgSize UI_APPEARANCE_SELECTOR;
//// 链接类消息字体颜色（常见问题、url、转人工按钮等）
//@property(nonatomic, strong) UIColor *hyperLinkColor UI_APPEARANCE_SELECTOR;

#pragma mark - 输入区
// 隐藏表情按钮 默认为false，不隐藏
@property(nonatomic, assign) BOOL hideEmoji UI_APPEARANCE_SELECTOR;
// 隐藏拍照按钮 默认为false，不隐藏
@property(nonatomic, assign) BOOL hidePhotographButton UI_APPEARANCE_SELECTOR;
// 隐藏语音切换按钮 默认为false，不隐藏
@property(nonatomic, assign) BOOL hideAudio UI_APPEARANCE_SELECTOR;
// 隐藏发送图片按钮 默认为false，不隐藏
@property(nonatomic, assign) BOOL hideSendPictureButton UI_APPEARANCE_SELECTOR;
// 在进入聊天界面时是否隐藏输入键盘 默认为 false，进入时就自动弹出键盘
@property(nonatomic, assign) BOOL hideKeyboardOnEnterConsult UI_APPEARANCE_SELECTOR;
@end
