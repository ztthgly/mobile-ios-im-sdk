//
//  ZTPreviewPhotoView.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/12.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTPreviewPhotoView.h"
@import ESPictureBrowser;

@interface ZTPreviewPhotoView() <ESPictureBrowserDelegate>
@property(nonatomic, strong) ESPictureBrowser *brower;
@property(nonatomic, strong) NSString *highQualityURL;
@property(nonatomic, strong) UIImage *image;
@end

@implementation ZTPreviewPhotoView
- (instancetype)initWithImage:(UIImage *)image highQualityURL:(NSString *)URLString inView:(UIView *)view {
    self.highQualityURL = URLString;
    self.image = image;
    self.brower = [[ESPictureBrowser alloc] init];
    self.brower.delegate = self;
    [self.brower showFromView:view picturesCount:1 currentPictureIndex:0];
    return self;
}

- (NSString *)pictureView:(ESPictureBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index {
    return self.highQualityURL;
}

- (UIImage *)pictureView:(ESPictureBrowser *)pictureBrowser defaultImageForIndex:(NSInteger)index {
    return self.image;
}


@end
