//
//  ZTUIConfiguration.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/23.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTUIConfiguration.h"
#import "UIImage+ZTKit.h"
#import "ZTUICommonDefine.h"

@implementation ZTUIConfiguration

@end

@interface ZTUIConfiguration(UIAppearance)

@end

@implementation ZTUIConfiguration(UIAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    ZTUIConfiguration *apperence = [ZTUIConfiguration appearance];
#pragma mark - 导航栏
    apperence.statusBarStyle = UIStatusBarStyleLightContent;
    apperence.navBarBackgroundImage = [self defaultBackgroundImage];
    apperence.navBarBarTintColor = [UIColor whiteColor];
    apperence.hideHeaderTitle = false;
    apperence.hideHeaderIcon = false;
    apperence.headerTitle = nil;
    apperence.headerIcon = nil;
    apperence.titleLabelSize = 17;

#pragma mark - 整体
    apperence.msgBackgroundImage = nil;
    apperence.msgBackgroundColor = UIColorMake(244, 245, 247);
#pragma mark - 消息区
    apperence.msgListViewDividerHeight = 20;
    apperence.hideLeftAvatar = false;
    apperence.hideRightAvatar = false;
    apperence.avatarShape = 0;
    
    apperence.tipsTextColor = UIColorMake(144, 147, 153);
    apperence.tipsTextSize = 10;
    apperence.tipsBackgroundColor = UIColorMake(230, 233, 237);
    
    apperence.msgLeftItemBgNormol = UIImageMake(@"bubble_left");
    apperence.msgLeftItemBgSelcted = UIImageMake(@"bubble_left");
    
    apperence.msgRightItemBgNormol = UIImageMake(@"bubble_right");
    apperence.msgRightItemBgSelcted = UIImageMake(@"bubble_right");
    
    apperence.textMsgLeftColor = UIColorMake(48, 49, 51);
    apperence.textMsgRightColor = [UIColor whiteColor];
    apperence.textMsgSize = 14;
//    apperence.hyperLinkColor = [UIColor blueColor];
    
#pragma mark - 输入区
    apperence.hideEmoji = false;
    apperence.hidePhotographButton = false;
    apperence.hideAudio = false;
    apperence.hideSendPictureButton = false;
    apperence.hideKeyboardOnEnterConsult = true;
}

+ (UIImage *)defaultBackgroundImage {
    UIImage *image = [UIImageMake(@"navigationbar_background") imageByResizeToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
    return image;
}

@end
