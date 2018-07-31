//
//  ZTExpressionManager.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/31.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTExpressionManager.h"
#import "ZTHelper.h"
#import "ZTUICommonDefine.h"
@interface ZTExpressionManager()
@end

@implementation ZTExpressionManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ZTExpressionManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (UIImage *)expressionWithKey:(NSString *)key {
    __block NSDictionary *item;
    [self.expressions enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.allKeys.firstObject isEqualToString:key]) {
            item = obj;
            *stop = YES;
        }
    }];
    UIImage *image = UIImageMake(item.allValues.firstObject);
    return image;
}

- (NSArray *)expressions {
    if (!_expressions) {
        _expressions = [[NSArray alloc] initWithContentsOfFile:[[ZTHelper currentBundle] pathForResource:@"expression" ofType:@"plist"]];
    }
    return _expressions;
}

@end
