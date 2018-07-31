//
//  ZTFileLeftMessageCell.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/6/1.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTFileLeftMessageCell.h"
#import "ZTWebVC.h"

@interface ZTFileLeftMessageCell()

@property (strong, nonatomic) IBOutlet UIStackView *mainView;
@property (strong, nonatomic) IBOutlet UILabel *fileNameLbl;
@property (strong, nonatomic) IBOutlet UIImageView *fileTypeImageView;

@property(nonatomic, strong) ZTSendMessageV0 *vo;

@end

@implementation ZTFileLeftMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPressedTapGesturRecognizer:)];
    [self.mainView addGestureRecognizer:tapRecognizer];
}

- (void)updateCellWithVo:(ZTSendMessageV0 *)vo {
    [super updateCellWithVo:vo];
    
    self.vo = vo;
    NSArray *array = [vo.content componentsSeparatedByString:@","];
    self.fileNameLbl.text = [array lastObject];
}

- (IBAction)onPressedTapGesturRecognizer:(UITapGestureRecognizer *)sender {
    if (self.vo && self.vo.content) {
        ZTWebVC *vc = [[ZTWebVC alloc] init];
        NSArray *array = [self.vo.content componentsSeparatedByString:@","];
        self.fileNameLbl.text = [array lastObject];
        vc.URLString = array.firstObject;
        vc.title = array.lastObject;
        [[[ZTHelper getTopViewController] navigationController] pushViewController:vc animated:YES];
    }
}

@end
