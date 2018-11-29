//
//  ZTAgentV0.h
//  ZT_IM_SDK
//
//  Created by Deemo on 2018/5/26.
//

#import "ZTValueObject.h"

NS_ASSUME_NONNULL_BEGIN
@interface ZTAgentV0 : ZTValueObject
@property(nonatomic, copy) NSString *imId;
@property(nonatomic, copy) NSString *agentId;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *agentAvatar;
@property(nonatomic, copy) NSString *agentWorkId;
@property(nonatomic, copy) NSString *routeId;
@property(nonatomic, copy) NSString *data;
@property(nonatomic, copy) NSString *connectTime;
@property(nonatomic, copy) NSString *lastInfo;
@property(nonatomic, copy) NSString *isEnableMessage;
@property(nonatomic, copy) NSString *welcomeText;
@property(nonatomic, assign) BOOL robot_revert_switch;

/**
 客户端字段,当前客服是分配的新的客服, 还是原来聊天的客服
 */
@property(nonatomic, assign) BOOL isRefresh;

/**
 是否是机器人
 */
@property(nonatomic, assign) BOOL isRobot;
@end
NS_ASSUME_NONNULL_END
/*
 {
 "imId": "1892",
 "agentId": "12390",
 "userId": "",
 "nickName": "小龙",
 "agentAvatar": "http://icsoc-ekt-files.oss-cn-beijing.aliyuncs.com/public/uploadfile/875dc261a0bde52c9f2a8bd0313c4f7b.jpg",
 "agentWorkId": "123456",
 "routeId": "",
 "data": "您好，小龙客服为您服务",
 "connectTime": "",
 "lastInfo": "",
 "isEnableMessage": "1"
 }
 */
