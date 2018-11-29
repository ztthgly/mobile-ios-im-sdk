//
//  ZTAppraise.h
//  ZT_IM_SDK
//
//  Created by Deemo on 2018/5/26.
//

#import "ZTValueObject.h"

NS_ASSUME_NONNULL_BEGIN
// 评价项
@interface ZTOptionV0: ZTValueObject
@property(nonatomic, copy) NSString *nid;
@property(nonatomic, copy) NSString *optionName;
@property(nonatomic, copy) NSString *optionOrder;
@end

@interface ZTAppraiseV0 : ZTValueObject
// 代表 坐席主动邀评  1: 代表 坐席主动结束回话的自动邀评
@property(nonatomic, strong) NSNumber *remarkType;
@property(nonatomic, copy) NSString *remarkText;
@property(nonatomic, strong) NSArray <ZTOptionV0 *> *remarkContent;
@property(nonatomic, copy) NSString *evaDescriptText;
// "0": 代表 关闭  "1": 代表 开启
@property(nonatomic, assign) BOOL isEnableEvaDescrip;
@end

NS_ASSUME_NONNULL_END
