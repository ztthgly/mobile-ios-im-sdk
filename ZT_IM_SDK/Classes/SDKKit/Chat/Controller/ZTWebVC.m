//
//  ZTWebVC.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/6.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTWebVC.h"
#import "ZTUICommonDefine.h"

@import WebKit;
@interface ZTWebVC ()
@property(nonatomic, strong) WKWebView *webView;
@end

@implementation ZTWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]]];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:UIImageMake(@"arrow_left") style:UIBarButtonItemStylePlain target:self action:@selector(onPressedBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - getters and setters
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *controller = [[WKUserContentController alloc] init];
        configuration.userContentController = controller;
        
        _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration: configuration];
        
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)onPressedBack {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
