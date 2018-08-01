//
//  ZTViewController.m
//  ZT_IM_SDK
//
//  Created by Deemo on 05/15/2018.
//  Copyright (c) 2018 殷佳亮. All rights reserved.
//

#import "ZTViewController.h"
#import "ZTConversationVC.h"
#import "ChatKeyBoard.h"

#import "MoreItem.h"
#import "ChatToolBarItem.h"

#import <GTSDK/GeTuiSdk.h>

@import ZT_IM_SDK;

#define kTestChannelKey @"aabe12d634dd99881cd0974f1d77e425"
static NSString * const kChannelKey = @"kChannelKey";
static NSString * const kTid = @"kTid";

@interface ZTViewController ()
@property (strong, nonatomic) IBOutlet UITextField *channelKeyTF;
@property (strong, nonatomic) IBOutlet UITextField *tidTF;

@end

@implementation ZTViewController {
    NSData *_messageData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *channelKey = [userDefaults objectForKey:kChannelKey];
    NSString *tid = [userDefaults objectForKey:kTid];
    if (channelKey && channelKey.length > 0) {
        self.channelKeyTF.text = channelKey;
    } else {
        self.channelKeyTF.text = kTestChannelKey;
    }
    if (tid && tid.length > 0) {
        self.tidTF.text = tid;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:[ZTUIConfiguration appearance].navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:[ZTUIConfiguration appearance].titleLabelSize]}];
}


- (IBAction)didClickedRegistBtn:(id)sender {
    ZTUserV0 *user = [ZTUserV0 new];
    user.tid = self.tidTF.text;
    user.userName = [NSString stringWithFormat:@"App接入用户%@",self.tidTF.text];

    [[ZTIM sharedInstance] setUser:user];
    [[ZTIM sharedInstance] registerChannelKey:self.channelKeyTF.text];
    
    [GeTuiSdk bindAlias:self.tidTF.text andSequenceNum:self.tidTF.text];
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n",self.tidTF.text);
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setValue:self.channelKeyTF.text forKey:kChannelKey];
    [userdefaults setObject:self.tidTF.text forKey:kTid];
    [userdefaults synchronize];
}

- (IBAction)didClickedConnectBtn:(UIButton *)sender {
    ZTConversationVC *vc = [[ZTConversationVC alloc] init];
    vc.sourcePageName = @"Demo开始页";
    vc.landingPageName = @"";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
