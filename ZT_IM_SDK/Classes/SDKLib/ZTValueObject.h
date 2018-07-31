//
//  ZTValueObject.h
//  Ticket
//
//  Created by Cloud on 7/4/15.
//  Copyright (c) 2015 ICSOC. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN
@interface ZTValueObject : NSObject
    /**
     *  通过字典创建VO
     *
     *  @param aDict 字典
     *
     *  @return VO
     */
+ (instancetype)voWithDict:(nullable NSDictionary *)aDict;
+ (instancetype)voWithJson:(nullable NSString *)aJson;


@end
NS_ASSUME_NONNULL_END

