//
//  ZTIM.h
//  ZTIMSDK
//
//  Created by Deemo on 2018/5/14.
//  Copyright © 2018年 icsoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTConversationManager.h"
#import "ZTIMLibDefine.h"
#import "ZTUserV0.h"

NS_ASSUME_NONNULL_BEGIN;
/**
 清楚文件时的缓存回调
 
 @param error 返回的错误
 */
typedef void (^ZTCleanResourceCacheCompletionBlock)(NSError *error);

/**
 SDK全局管理类
 */
@interface ZTIM : NSObject
/**
 *  单例
 */
+ (instancetype)sharedInstance;

#pragma mark - 连接与断开服务器
/**
 注册SDK

 @param channelKey 对应管理后台分配的channelKey
 */
- (void)registerChannelKey:(NSString *)channelKey;

/**
 返回channelKey;
 */
@property(nonatomic, strong, readonly, nullable) NSString *channelKey;

/**
 User相关信息
 */
@property(nonatomic, strong, nullable) ZTUserV0 *user;

/**
 当前配置样式
 */
@property(nonatomic, strong, readonly, nullable) ZTChannelV0 *channel;


/**
 开启服务

 @param sourcePageName 发起页
 @param landingPageName 来源页
 */
- (void)startServiceFromSourcePage:(nullable NSString *)sourcePageName landingPage:(nullable NSString *)landingPageName;

/**
 重启服务
 */
- (void)restartService;

/**
 关闭服务
 */
- (void)stopService;

/**
 关闭服务

 @param code 关闭的Code号
 @param reason 关闭的原因
 */
- (void)stopServiceWithCode:(ZTCloseWebSocketType)code reason:(NSString *)reason;

#pragma mark - 日志
/**
 *  Log 输出开关 (默认关闭)
 *
 *  @param flag 是否开启
 */
+ (void)setLogEnable:(BOOL)flag;

/**
 *  是否开启了 Log 输出
 *
 *  @return Log 开关状态
 */
+ (BOOL)logEnable;

#pragma mark - 会话管理

/**
 返回会话管理类
 */
@property(nonatomic, strong, readonly, nonnull) ZTConversationManager *conversationManager;
#pragma mark - 访问轨迹
/**
 用户访问轨迹

 @param title 访问的标题
 @param enterOrOut 进入或者退出
 */
- (void)trackHistory:(NSString *)title enterOrOut:(BOOL)enterOrOut;

#pragma mark - 文件管理
/**
 清理文件缓存/缓存的图片/语音

 @param completeBlock 清理缓存完成Block回调
 */
- (void)cleanResourceCacheWithBlock:(ZTComplectionWithResultBlock)completeBlock;

@end
NS_ASSUME_NONNULL_END

