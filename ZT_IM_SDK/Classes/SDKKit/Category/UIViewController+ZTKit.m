//
//  UIViewController+ZTKit.m
//  ZT_IM_SDK
//
//  Created by Deemo on 2018/6/27.
//

#import "UIViewController+ZTKit.h"
#import "ZTHelper.h"

@implementation UIViewController (ZTKit)
- (IBAction)onTap:(id)sender
{
    [[[UIApplication sharedApplication].delegate window] endEditing:YES];
}

- (BOOL)isNavTopVC {
    if (!self.navigationController) {
        return false;
    }
    UIViewController *vc = self.navigationController.viewControllers.lastObject;
    if (![vc isKindOfClass:[self class]]) {
        return false;
    }
    return true;
}
@end
