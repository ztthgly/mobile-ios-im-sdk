//
//  ZTConfigViewController.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/25.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTConfigViewController.h"
#import "ZTConfigCell.h"
#import "UIImage+ZT.h"
#import "ZTConfigItem.h"

#define UIColorMake(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIImageMake(img) [UIImage imageNamed:img inBundle:[ZTHelper imageBundle] compatibleWithTraitCollection:nil]
@import ActionSheetPicker_3_0;
@import ZT_IM_SDK;

@interface ZTConfigViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *dataSource;

@property(nonatomic, strong) NSArray *defaultColors;
@property(nonatomic, strong) NSArray *fontSizes;
@property(nonatomic, strong) ZTConfigItem *currentSelectItem;
@end

@implementation ZTConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    // Do any additional setup after loading the view.
}

- (void)initSubviews {
    self.title = @"配置";
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = self.dataSource[section];
    return sectionArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @[ @"导航栏", @"整体", @"消息区", @"输入区"][section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZTConfigItem *item = self.dataSource[indexPath.section][indexPath.row];
    switch (item.type) {
        case ZTConfigBool:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.textLabel.text = item.declare;
            cell.detailTextLabel.text = [item.defaultValue boolValue] ? @"true" : @"false";
            return cell;
        }
        case ZTConfigTypeColor:
        {
            ZTConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            cell.nameLabel.text = item.declare;
            cell.valueImageView.backgroundColor = item.defaultValue;
            cell.valueImageView.image = nil;
            return cell;
        }
        case ZTConfigTypeImage:
        {
            ZTConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            cell.nameLabel.text = item.declare;
            cell.valueImageView.image = item.defaultValue;
            cell.valueImageView.backgroundColor = [UIColor clearColor];
            return cell;
        }
        case ZTConfigTypeInt:
        case ZTConfigTypePicker:
        case ZTConfigTypeString:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.textLabel.text = item.declare;
            if ([item.defaultValue isKindOfClass: [NSString class]]) {
                cell.detailTextLabel.text = item.defaultValue;
            } else {
                cell.detailTextLabel.text = [item.defaultValue stringValue];
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentSelectItem = self.dataSource[indexPath.section][indexPath.row];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    [self _configNavBarBackgroundImage];
                    break;
                case 1:
                    [self _configNavBarBarTintColor];
                    break;
                case 2:
                    [self _configHeaderTitle];
                    break;
                case 3:
                    [self _configHideHeaderTitle];
                    break;
                case 4:
                    [self _configHeaderIcon];
                    break;
                case 5:
                    [self _confighideHeaderIcon];
                    break;
                case 6:
                    [self _configTitleLabelSize];
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    [self _configMsgBackgroundImage];
                    break;
                case 1:
                    [self _configMsgBackgroundColor];
                    break;
                default:
                    break;
            }
        }
            break;

        case 2:
        {
            switch (indexPath.row) {
                case 0:
                    [self _configMsgListViewDividerHeight];
                    break;
                case 1:
                    [self _configHideLeftAvatar];
                    break;
                case 2:
                    [self _configHideRightAvatar];
                    break;
                case 3:
                    [self _configAvatarShapeType];
                    break;
                case 4:
                    [self _configTipsTextColor];
                    break;
                case 5:
                    [self _configTipsTextSize];
                    break;
                case 6:
                    [self _configTipsBackgroundColor];
                    break;
                case 7:
                    [self _configMsgLeftItemBg];
                    break;
                case 8:
                    [self _configMsgRightItemBg];
                    break;
                case 9:
                    [self _configTextMsgLeftColor];
                    break;
                case 10:
                    [self _configTextMsgRightColor];
                    break;
                case 11:
                    [self _configTextMsgSize];
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                    [self _configHideEmoji];
                    break;
                case 1:
                    [self _configHidePhotographButton];
                    break;
                case 2:
                    [self _configHideAudio];
                    break;
                case 3:
                    [self _configSendPictureButton];
                    break;
                case 4:
                    [self _configHideKeyboardOnEnterConsult];
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - privite

#pragma mark - 导航栏
- (void)_configNavBarBackgroundImage {
    [ActionSheetStringPicker showPickerWithTitle:@"导航栏背景图片" rows:self.defaultColors initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        UIImage *image = self.currentSelectItem.defaultValue;
        if (selectedIndex == 0) {
            image = nil;
        } else {
            image = [self _imageWithColorName:selectedValue];
        }
        self.currentSelectItem.defaultValue = image;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].navBarBackgroundImage = image;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
    } origin:self.view];
}

- (void)_configNavBarBarTintColor {
    [ActionSheetStringPicker showPickerWithTitle:@"导航栏文字填充颜色" rows:self.defaultColors initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        UIColor *color = self.currentSelectItem.defaultValue;
        if (selectedIndex == 0) {
            color = [UIColor whiteColor];
        } else {
            color = [self _colorWithName:self.defaultColors[selectedIndex]];
        }
        self.currentSelectItem.defaultValue = color;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].navBarBarTintColor = color;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
    } origin:self.view];
}

- (void)_configHeaderIcon {
    [ActionSheetStringPicker showPickerWithTitle:@"导航栏Icon" rows:self.defaultColors initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        UIImage *image = self.currentSelectItem.defaultValue;
        if (selectedIndex == 0) {
            image = nil;
        } else {
            image = [self _imageWithColorName:selectedValue];
        }
        self.currentSelectItem.defaultValue = image;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].headerIcon = [image imageByResizeToSize:CGSizeMake(25, 25)];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
    } origin:self.view];
}

- (void)_confighideHeaderIcon {
    [ActionSheetStringPicker showPickerWithTitle:@"隐藏名称" rows:@[@"false", @"true"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.currentSelectItem.defaultValue = @(selectedIndex);
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].hideHeaderIcon = @(selectedIndex).boolValue;
    } cancelBlock:nil origin:self.view];
}

- (void)_configHeaderTitle {
    [ActionSheetStringPicker showPickerWithTitle:@"设置企业名称" rows:@[@"default",@"中通天鸿", @"中通智星"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        NSString *value = self.currentSelectItem.defaultValue;
        if (selectedIndex == 0) {
            value = nil;
        } else {
            value = selectedValue;
        }
        self.currentSelectItem.defaultValue = value;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].headerTitle = value;
    } cancelBlock:nil origin:self.view];
}
- (void)_configHideHeaderTitle {
    [ActionSheetStringPicker showPickerWithTitle:@"隐藏企业名称" rows:@[@"false", @"true"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.currentSelectItem.defaultValue = @(selectedIndex);
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].hideHeaderTitle = @(selectedIndex).boolValue;
    } cancelBlock:nil origin:self.view];
}

- (void)_configTitleLabelSize {
    [ActionSheetStringPicker showPickerWithTitle:@"导航栏Title 字体大小" rows:self.fontSizes initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.currentSelectItem.defaultValue = selectedValue;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].titleLabelSize = [selectedValue integerValue];
    } cancelBlock:nil origin:self.view];
}

#pragma mark - 聊天整体
- (void)_configMsgBackgroundImage {
    [ActionSheetStringPicker showPickerWithTitle:@"聊天背景图片" rows:self.defaultColors initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        UIImage *image = self.currentSelectItem.defaultValue;
        if (selectedIndex == 0) {
            image = nil;
        } else {
            image = [self _imageWithColorName:selectedValue];
        }
        self.currentSelectItem.defaultValue = image;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].msgBackgroundImage = image;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
    } origin:self.view];
}

- (void)_configMsgBackgroundColor {
    [ActionSheetStringPicker showPickerWithTitle:@"聊天主题色" rows:self.defaultColors initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        UIColor *color = self.currentSelectItem.defaultValue;
        if (selectedIndex == 0) {
            color = UIColorMake(244, 245, 247);
        } else {
            color = [self _colorWithName:self.defaultColors[selectedIndex]];
        }
        self.currentSelectItem.defaultValue = color;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].msgBackgroundColor = color;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
    } origin:self.view];
}

#pragma mark - 聊天配置
- (void)_configMsgListViewDividerHeight {
    [ActionSheetStringPicker showPickerWithTitle:@"消息列表消息项间距" rows:@[@"20", @"30", @"40"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.currentSelectItem.defaultValue = selectedValue;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].msgListViewDividerHeight = [selectedValue integerValue];
    } cancelBlock:nil origin:self.view];
}

- (void)_configHideLeftAvatar {
    [ActionSheetStringPicker showPickerWithTitle:@"隐藏左侧客服头像" rows:@[@"false", @"true"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.currentSelectItem.defaultValue = @(selectedIndex);
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].hideLeftAvatar = @(selectedIndex).boolValue;
    } cancelBlock:nil origin:self.view];
}

- (void)_configHideRightAvatar {
    [ActionSheetStringPicker showPickerWithTitle:@"隐藏右侧用户头像" rows:@[@"false", @"true"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.currentSelectItem.defaultValue = @(selectedIndex);
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].hideRightAvatar = @(selectedIndex).boolValue;
    } cancelBlock:nil origin:self.view];
}

- (void)_configAvatarShapeType {
    [ActionSheetStringPicker showPickerWithTitle:@"头像形状" rows:self.currentSelectItem.values initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.currentSelectItem.defaultValue = selectedValue;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].avatarShape = selectedIndex;
    } cancelBlock:nil origin:self.view];
}

- (void)_configRightAvatar {
    
}

- (void)_configTipsTextColor {
    [ActionSheetStringPicker showPickerWithTitle:@"提示类消息的字体颜色" rows:self.defaultColors initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        UIColor *color = self.currentSelectItem.defaultValue;
        if (selectedIndex == 0) {
            color = UIColorMake(144, 147, 153);
        } else {
            color = [self _colorWithName:self.defaultColors[selectedIndex]];
        }
        self.currentSelectItem.defaultValue = color;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].tipsTextColor = color;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
    } origin:self.view];
}

- (void)_configTipsTextSize {
    [ActionSheetStringPicker showPickerWithTitle:@"提示类字体大小" rows:self.fontSizes initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.currentSelectItem.defaultValue = selectedValue;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].tipsTextSize = [selectedValue integerValue];
    } cancelBlock:nil origin:self.view];
}

- (void)_configTipsBackgroundColor {
    [ActionSheetStringPicker showPickerWithTitle:@"提示类消息的背景颜色" rows:self.defaultColors initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        UIColor *color = self.currentSelectItem.defaultValue;
        if (selectedIndex == 0) {
            color = UIColorMake(190, 199, 207);
        } else {
            color = [self _colorWithName:self.defaultColors[selectedIndex]];
        }
        self.currentSelectItem.defaultValue = color;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].tipsBackgroundColor = color;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
    } origin:self.view];
}

- (void)_configMsgLeftItemBg {
    [ActionSheetStringPicker showPickerWithTitle:@"左侧气泡" rows:self.defaultColors initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        UIImage *image = self.currentSelectItem.defaultValue;
        if (selectedIndex == 0) {
            image = UIImageMake(@"bubble_left");
        } else {
            image = [self _imageWithColorName:selectedValue];
        }
        self.currentSelectItem.defaultValue = image;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].msgLeftItemBgNormol = image;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
    } origin:self.view];
}

- (void)_configMsgRightItemBg {
    [ActionSheetStringPicker showPickerWithTitle:@"右侧气泡" rows:self.defaultColors initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        UIImage *image = self.currentSelectItem.defaultValue;
        if (selectedIndex == 0) {
            image = UIImageMake(@"bubble_right");
        } else {
            image = [self _imageWithColorName:selectedValue];
        }
        self.currentSelectItem.defaultValue = image;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].msgRightItemBgNormol = image;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
    } origin:self.view];
}

- (void)_configTextMsgLeftColor {
    [ActionSheetStringPicker showPickerWithTitle:@"左侧文字颜色" rows:self.defaultColors initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        UIColor *color = self.currentSelectItem.defaultValue;
        if (selectedIndex == 0) {
            color = UIColorMake(48, 49, 51);
        } else {
            color = [self _colorWithName:self.defaultColors[selectedIndex]];
        }
        self.currentSelectItem.defaultValue = color;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].textMsgLeftColor = color;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
    } origin:self.view];
}

- (void)_configTextMsgRightColor {
    [ActionSheetStringPicker showPickerWithTitle:@"右侧字体颜色" rows:self.defaultColors initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        UIColor *color = self.currentSelectItem.defaultValue;
        if (selectedIndex == 0) {
            color = [UIColor whiteColor];
        } else {
            color = [self _colorWithName:self.defaultColors[selectedIndex]];
        }
        self.currentSelectItem.defaultValue = color;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].textMsgRightColor = color;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
    } origin:self.view];
}

- (void)_configTextMsgSize{
    [ActionSheetStringPicker showPickerWithTitle:@"输入文字大小" rows:self.fontSizes initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.currentSelectItem.defaultValue = selectedValue;
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].textMsgSize = [selectedValue integerValue];
    } cancelBlock:nil origin:self.view];
}

#pragma mark - 输入区
- (void)_configHideEmoji{
    [ActionSheetStringPicker showPickerWithTitle:@"隐藏表情按钮" rows:@[@"false", @"true"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.currentSelectItem.defaultValue = @(selectedIndex);
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].hideEmoji = @(selectedIndex).boolValue;
    } cancelBlock:nil origin:self.view];
}

- (void)_configHidePhotographButton {
    [ActionSheetStringPicker showPickerWithTitle:@"隐藏拍照按钮" rows:@[@"false", @"true"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.currentSelectItem.defaultValue = @(selectedIndex);
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].hidePhotographButton = @(selectedIndex).boolValue;
    } cancelBlock:nil origin:self.view];
}

- (void)_configHideAudio {
    [ActionSheetStringPicker showPickerWithTitle:@"隐藏语音切换按钮" rows:@[@"false", @"true"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.currentSelectItem.defaultValue = @(selectedIndex);
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].hideAudio = @(selectedIndex).boolValue;
    } cancelBlock:nil origin:self.view];
}

- (void)_configSendPictureButton {
    [ActionSheetStringPicker showPickerWithTitle:@"隐藏发送图片按钮" rows:@[@"false", @"true"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.currentSelectItem.defaultValue = @(selectedIndex);
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].hideSendPictureButton = @(selectedIndex).boolValue;
    } cancelBlock:nil origin:self.view];
}

- (void)_configHideKeyboardOnEnterConsult {
    [ActionSheetStringPicker showPickerWithTitle:@"隐藏输入键盘" rows:@[@"false", @"true"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.currentSelectItem.defaultValue = @(selectedIndex);
        [self.tableView reloadData];
        [ZTUIConfiguration appearance].hideKeyboardOnEnterConsult = @(selectedIndex).boolValue;
    } cancelBlock:nil origin:self.view];
}

#pragma mark - config
- (ZTConfigItem *)configItemWithDeclareName:(NSString *)declare
                           ConfigType:(ZTConfigType)type
                              defaultValue:(id)defaultValue {
    ZTConfigItem *item = [[ZTConfigItem alloc] initWithDeclareName:declare configType:type defaultValue:defaultValue values:nil];
    return item;
}

- (ZTConfigItem *)configItemWithDeclareName:(NSString *)declare
                                 ConfigType:(ZTConfigType)type
                               defaultValue:(id)defaultValue
                                     values:(NSArray *)values {
    ZTConfigItem *item = [[ZTConfigItem alloc] initWithDeclareName:declare configType:type defaultValue:defaultValue values:values];
    return item;
}

- (UIColor *)_colorWithName:(NSString *)name {
    if ([name isEqualToString:@"Red"]) {
        return [UIColor redColor];
    } else if ([name isEqualToString:@"Green"]) {
        return [UIColor greenColor];
    } else if ([name isEqualToString:@"Blue"]) {
        return [UIColor blueColor];
    } else if ([name isEqualToString:@"Orange"]) {
        return [UIColor orangeColor];
    } else {
        return [UIColor clearColor];
    }
}

- (UIImage *)_imageWithColorName:(NSString *)name {
    return [UIImage imageWithTintColor:[self _colorWithName:name]];
}

#pragma mark - getters and setters
- (NSArray *)dataSource {
    if (!_dataSource) {
        // 整体
        NSMutableArray *items = @[].mutableCopy;
        
        {
            // 标题栏
            NSMutableArray *navItems = @[].mutableCopy;
            [navItems addObject:[self configItemWithDeclareName:@"标题栏背景图" ConfigType:ZTConfigTypeImage defaultValue:[ZTUIConfiguration appearance].navBarBackgroundImage]];
            [navItems addObject:[self configItemWithDeclareName:@"标题栏背景颜色" ConfigType:ZTConfigTypeColor defaultValue:[ZTUIConfiguration appearance].navBarBarTintColor]];

            [navItems addObject:[self configItemWithDeclareName:@"企业简称" ConfigType:ZTConfigTypeString defaultValue:[ZTUIConfiguration appearance].headerTitle]];
            [navItems addObject:[self configItemWithDeclareName:@"隐藏名称" ConfigType:ZTConfigBool defaultValue:@([ZTUIConfiguration appearance].hideHeaderTitle)]];
            [navItems addObject:[self configItemWithDeclareName:@"企业Logo" ConfigType:ZTConfigTypeImage defaultValue:[ZTUIConfiguration appearance].headerIcon]];
            [navItems addObject:[self configItemWithDeclareName:@"隐藏头像" ConfigType:ZTConfigBool defaultValue:@([ZTUIConfiguration appearance].hideHeaderIcon)]];
            
            [items addObject:navItems.copy];
        }
        
        {
            NSMutableArray *themeItems = @[].mutableCopy;
            [themeItems addObject:[self configItemWithDeclareName:@"主题图片" ConfigType:ZTConfigTypeImage defaultValue:[ZTUIConfiguration appearance].msgBackgroundImage]];
            [themeItems addObject:[self configItemWithDeclareName:@"主题色" ConfigType:ZTConfigTypeColor defaultValue:[ZTUIConfiguration appearance].msgBackgroundColor]];
            [items addObject:themeItems.copy];
        }
        
        {
            NSMutableArray *chatItems = @[].mutableCopy;

            // 消息区
            [chatItems addObject:[self configItemWithDeclareName:@"消息列表消息项间距" ConfigType:ZTConfigTypeInt defaultValue:@([ZTUIConfiguration appearance].msgListViewDividerHeight)]];
            [chatItems addObject:[self configItemWithDeclareName:@"隐藏左侧(客服消息)头像" ConfigType:ZTConfigBool defaultValue:@([ZTUIConfiguration appearance].hideLeftAvatar)]];
            [chatItems addObject:[self configItemWithDeclareName:@"隐藏右侧(访客消息)头像" ConfigType:ZTConfigBool defaultValue:@([ZTUIConfiguration appearance].hideRightAvatar)]];
            [chatItems addObject:[self configItemWithDeclareName:@"头像形状" ConfigType:ZTConfigTypePicker defaultValue:[ZTUIConfiguration appearance].avatarShape == 0 ? @"圆形形状" : @"方形头像" values:@[@"圆形头像", @"方形头像"]]];
            [chatItems addObject:[self configItemWithDeclareName:@"提示类消息的字体颜色" ConfigType:ZTConfigTypeColor defaultValue:[ZTUIConfiguration appearance].tipsTextColor]];
            [chatItems addObject:[self configItemWithDeclareName:@"提示类消息的字体大小" ConfigType:ZTConfigTypeInt defaultValue:@([ZTUIConfiguration appearance].tipsTextSize)]];
            [chatItems addObject:[self configItemWithDeclareName:@"提示类消息字体背景" ConfigType:ZTConfigTypeColor defaultValue:[ZTUIConfiguration appearance].tipsBackgroundColor]];
            [chatItems addObject:[self configItemWithDeclareName:@"左边消息项背景" ConfigType:ZTConfigTypeImage defaultValue:[ZTUIConfiguration appearance].msgLeftItemBgNormol]];
            [chatItems addObject:[self configItemWithDeclareName:@"右边消息项背景" ConfigType:ZTConfigTypeImage defaultValue:[ZTUIConfiguration appearance].msgRightItemBgNormol]];
            [chatItems addObject:[self configItemWithDeclareName:@"左侧文本消息字体颜色" ConfigType:ZTConfigTypeColor defaultValue:[ZTUIConfiguration appearance].textMsgLeftColor]];
            [chatItems addObject:[self configItemWithDeclareName:@"右侧文本消息字体颜色" ConfigType:ZTConfigTypeColor defaultValue:[ZTUIConfiguration appearance].textMsgRightColor]];
            [chatItems addObject:[self configItemWithDeclareName:@"文本消息字体大小" ConfigType:ZTConfigTypeInt defaultValue:@([ZTUIConfiguration appearance].textMsgSize)]];
            [items addObject:chatItems.copy];
        }
        
        {
            // 输入区
            NSMutableArray *inputItems = @[].mutableCopy;
            [inputItems addObject:[self configItemWithDeclareName:@"隐藏表情按钮" ConfigType:ZTConfigBool defaultValue:@([ZTUIConfiguration appearance].hideEmoji)]];
            [inputItems addObject:[self configItemWithDeclareName:@"隐藏拍照按钮" ConfigType:ZTConfigBool defaultValue:@([ZTUIConfiguration appearance].hidePhotographButton)]];
            [inputItems addObject:[self configItemWithDeclareName:@"隐藏语音切换按钮" ConfigType:ZTConfigBool defaultValue:@([ZTUIConfiguration appearance].hideAudio)]];
            [inputItems addObject:[self configItemWithDeclareName:@"隐藏发送图片按钮" ConfigType:ZTConfigBool defaultValue:@([ZTUIConfiguration appearance].hideSendPictureButton)]];
            [inputItems addObject:[self configItemWithDeclareName:@"隐藏输入键盘" ConfigType:ZTConfigBool defaultValue:@([ZTUIConfiguration appearance].hideKeyboardOnEnterConsult)]];
            [items addObject:inputItems];
        }
        _dataSource = items.copy;
    }
    return _dataSource;
}

- (NSArray *)defaultColors {
    if (!_defaultColors) {
        _defaultColors = [NSArray arrayWithObjects:@"default", @"Red", @"Green", @"Blue", @"Orange", nil];
    }
    return _defaultColors;
}

- (NSArray *)fontSizes {
    if (!_fontSizes) {
        _fontSizes = [NSArray arrayWithObjects:@"10", @"13", @"15", @"17", @"20", nil];
    }
    return _fontSizes;
}
@end
