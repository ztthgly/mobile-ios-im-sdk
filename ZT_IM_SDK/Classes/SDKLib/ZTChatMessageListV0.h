//
//  ZTChatMessageListV0.h
//  ZT_IM_SDK
//
//  Created by Deemo on 2018/6/14.
//

#import "ZTValueObject.h"
#import "ZTSendMessageV0.h"

@interface ZTChatMessageListV0 : ZTValueObject
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *imId;
@property(nonatomic, copy) NSString *currentFlag;
@property(nonatomic, copy) NSString *queryFlag;
@property(nonatomic, copy) NSString *cid;
@property(nonatomic, strong) NSNumber *endNum;
@property(nonatomic, strong) NSNumber *totalNum;
@property(nonatomic, copy) NSArray <ZTSendMessageV0 *> *data;
@property(nonatomic, strong) NSNumber *pageNum;
@property(nonatomic, strong) NSNumber *totalPageNum;
@property(nonatomic, copy) NSString *userAvatar;
@property(nonatomic, copy) NSString *agentAvatar;
@property(nonatomic, strong) NSNumber *userSourceType;

@end

/*
 {
 "userId": "730b94412d124e6da6a4643e3b804e0e",
 "imId": "2436",
 "currentFlag": 0,
 "queryFlag": 0,
 "cid": "",
 "endNum": 20,
 "totalNum": 13,
 "datas": [
 "{\"from\":0,\"to\":1,\"content\":\"***\",\"msgType\":0,\"sequence\":5,\"createTime\":1528953626}",
 "{\"from\":0,\"to\":1,\"content\":\"333\",\"msgType\":0,\"sequence\":4,\"createTime\":1528953625}",
 "{\"from\":0,\"to\":1,\"content\":\"sss\",\"msgType\":0,\"sequence\":11,\"createTime\":1528953614}"
 ],
 "data": null,
 "pageNum": 0,
 "totalPageNum": 0,
 "userAvatar": "",
 "agentAvatar": "http://icsoc-ekt-files.oss-cn-beijing.aliyuncs.com/public/uploadfile/d65f04b3a1ca3395e8c5fe3e806c3c8c.jpg",
 "userSourceType": 0
 }
 */
