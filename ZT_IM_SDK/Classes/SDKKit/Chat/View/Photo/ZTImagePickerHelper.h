//
//  ZTImagePickerHelper.h
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/30.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ZTDidFinishTakeMediaCompledBlock)(UIImage *image, NSDictionary *editingInfo);

@interface ZTImagePickerHelper : NSObject
- (void)showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController compled:(ZTDidFinishTakeMediaCompledBlock)compled;
@end
