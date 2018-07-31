//
//  UIViewController+ZTKit.h
//  ZT_IM_SDK
//
//  Created by Deemo on 2018/6/27.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZTKit)
- (IBAction)onTap:(id)sender;


/**
 判断当前VC是不是导航栏控制器最顶层的控制器

 @return Yes or No;
 */
- (BOOL)isNavTopVC;
@end
