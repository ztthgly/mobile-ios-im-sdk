//
//  ZTConversationNavigationVC.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/23.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTConversationNavigationVC.h"
@interface ZTConversationNavigationVC () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *infoTextLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation ZTConversationNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initSubviews {
    [super initSubviews];
    self.title = @"请选择导航菜单";
    // 解析字典
    self.infoTextLabel.text = self.navInfo.navText;
    
    self.tableView.layer.cornerRadius = 10;
    self.heightConstraint.constant = self.navInfo.navContent.count * 44;
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.navInfo.navContent && self.navInfo.navContent.count > 0) {
        return self.navInfo.navContent.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *text = self.navInfo.navContent[indexPath.row];
    cell.textLabel.text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[ZTIM sharedInstance].conversationManager chooseNavigationWithNavIndex:indexPath.row + 1];
}

@end
