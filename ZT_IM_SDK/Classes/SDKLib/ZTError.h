//
//  ZTError.h
//  ZT_IM_SDK
//
//  Created by Deemo on 2018/6/7.
//

#import <Foundation/Foundation.h>
#import "ZTIMLibDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZTError : NSError

/**
 抛出错误

 @param code 错误code
 @param string 错误String
 @return ZTError
 */
+ (instancetype)errorWithCode:(NSUInteger)code errorString:(nullable NSString *)string;
@end
NS_ASSUME_NONNULL_END
