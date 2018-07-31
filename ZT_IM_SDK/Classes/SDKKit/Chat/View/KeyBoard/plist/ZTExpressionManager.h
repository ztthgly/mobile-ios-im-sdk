//
//  ZTExpressionManager.h
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/31.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTExpressionManager : NSObject
+ (instancetype)sharedInstance;

@property(nonatomic, copy) NSArray *expressions;
- (UIImage *)expressionWithKey:(NSString *)key;
@end
