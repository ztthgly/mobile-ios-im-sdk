//
//  ZTConversationVC.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/23.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTConversationVC.h"

@interface ZTConversationVC ()

@end

@implementation ZTConversationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showEmptyViewWithImage:UIImageMake(@"lianjiezhong") text:@"努力连接中, 请稍等..."];
    [[ZTIM sharedInstance] startServiceFromSourcePage:self.sourcePageName landingPage:self.landingPageName];
}

- (void)initSubviews {
    [super initSubviews];
    self.title = @"在线客服";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
