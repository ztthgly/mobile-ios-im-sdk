//
//  ZTWebVC.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/6.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTWebVC.h"
@import WebKit;
@interface ZTWebVC ()
@property(nonatomic, strong) WKWebView *webView;
@end

@implementation ZTWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]]];
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


@end
