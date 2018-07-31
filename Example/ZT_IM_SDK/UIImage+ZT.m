//
//  UIImage+ZT.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/25.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "UIImage+ZT.h"

@implementation UIImage (ZT)
+ (UIImage *)imageWithTintColor:(UIColor *)tintColor {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [tintColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
