//
//  ZTHelper.h
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/23.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @see https://github.com/QMUI/QMUI_iOS/blob/master/QMUIKit/QMUICore/QMUIHelper.h
 */
@interface ZTHelper : NSObject
+ (instancetype _Nonnull)sharedInstance;
@end

@interface ZTHelper (Device)
+ (BOOL)isIPad;
+ (BOOL)isIPadPro;
+ (BOOL)isIPod;
+ (BOOL)isIPhone;
+ (BOOL)isSimulator;

+ (BOOL)is58InchScreen;
+ (BOOL)is55InchScreen;
+ (BOOL)is47InchScreen;
+ (BOOL)is40InchScreen;
+ (BOOL)is35InchScreen;

+ (CGSize)screenSizeFor58Inch;
+ (CGSize)screenSizeFor55Inch;
+ (CGSize)screenSizeFor47Inch;
+ (CGSize)screenSizeFor40Inch;
+ (CGSize)screenSizeFor35Inch;

/// 用于获取 iPhoneX 安全区域的 insets
+ (UIEdgeInsets)safeAreaInsetsForIPhoneX;
@end

@interface ZTHelper (UIGraphic)
/// 获取一像素的大小
+ (CGFloat)pixelOne;
@end

@interface ZTHelper (authentication)
/// 是否有麦克风权限
+ (BOOL)canRecord;
@end

@interface ZTHelper (date)
+ (nullable NSString *)stringWithTimeInterval:(uint32_t)timeInterval;
+ (nullable NSString *)hourStringWithTimeInterval:(uint32_t)timeInterval;
@end

/**
 url解析
 */
@interface ZTHelper (url)
+ (int)getAudioDurationWithUrlString:(nonnull NSString *)URLString;

+ (nullable UIImage *)getVideoFirstFrameImage:(nonnull NSString *)URLString;
@end

@interface ZTHelper (vc)
+ (__kindof UIViewController *_Nullable)getTopViewController;
@end

@interface ZTHelper (bundle)
+ (nullable NSBundle *)currentBundle;
+ (nullable NSBundle *)imageBundle;
@end

