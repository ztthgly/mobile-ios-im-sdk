//
//  ZTTextLeftMessageCell.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/31.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTTextLeftMessageCell.h"
#import "ZTExpressionManager.h"

@interface ZTTextLeftMessageCell()
@property(nonatomic, strong) ZTSendMessageV0 *vo;;
@end

@implementation ZTTextLeftMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentTF.font = [UIFont systemFontOfSize:[ZTUIConfiguration appearance].textMsgSize];
    self.contentTF.textColor = [ZTUIConfiguration appearance].textMsgLeftColor;
}

- (void)updateCellWithVo:(ZTSendMessageV0 *)vo {
    [super updateCellWithVo:vo];
    self.vo = vo;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:vo.content];
    {
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[([\u4e00-\u9fa5\\w])+\\]" options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray<NSTextCheckingResult *> *result = [regex matchesInString:attributedText.string options:0 range:NSMakeRange(0, attributedText.string.length)];
        [result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *expression = [vo.content substringWithRange:obj.range];
            UIImage *image = [[ZTExpressionManager sharedInstance] expressionWithKey:expression];
            if (image) {
                NSTextAttachment *textAttach = [[NSTextAttachment alloc] init];
                textAttach.image = image;
                CGFloat height = self.contentTF.font.lineHeight;
                textAttach.bounds = CGRectMake(0, -4, height, height);
                
                NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttach];
                [attributedText replaceCharactersInRange:obj.range withAttributedString:attachmentString];
            }
        }];
    }
    self.contentTF.attributedText = attributedText;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        self.bubbleImageView.image = [ZTUIConfiguration appearance].msgLeftItemBgSelcted;
    } else {
        self.bubbleImageView.image = [ZTUIConfiguration appearance].msgLeftItemBgNormol;
    }
}

@end
