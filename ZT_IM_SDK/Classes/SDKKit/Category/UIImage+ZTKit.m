//
//  UIImage+ZTKit.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/22.
//  Copyright © 2018年 殷佳亮. All rights reserved.
//

#import "UIImage+ZTKit.h"

@implementation UIImage (ZTKit)
- (UIImage *)imageByResizeToSize:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
