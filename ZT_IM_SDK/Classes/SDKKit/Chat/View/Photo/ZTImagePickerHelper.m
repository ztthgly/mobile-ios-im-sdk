//
//  ZTImagePickerHelper.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/30.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTImagePickerHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface ZTImagePickerHelper() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, copy) ZTDidFinishTakeMediaCompledBlock didFinishTakeMediaCompled;

@end

@implementation ZTImagePickerHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController compled:(ZTDidFinishTakeMediaCompledBlock)compled {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        compled(nil, nil);
        return;
    }
    self.didFinishTakeMediaCompled = [compled copy];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.editing = YES;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    } else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [viewController presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)dismissPickerViewController:(UIImagePickerController *)picker {
    __weak __typeof(self)weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        weakSelf.didFinishTakeMediaCompled = nil;
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    if (self.didFinishTakeMediaCompled) {
        self.didFinishTakeMediaCompled(image, editingInfo);
    }
    [self dismissPickerViewController:picker];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (self.didFinishTakeMediaCompled) {
        self.didFinishTakeMediaCompled(nil, info);
    }
    [self dismissPickerViewController:picker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissPickerViewController:picker];
}

-(void)dealloc {
    self.didFinishTakeMediaCompled = nil;
}

@end
