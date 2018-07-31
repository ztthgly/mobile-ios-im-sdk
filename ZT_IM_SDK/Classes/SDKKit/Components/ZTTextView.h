//
//  ZTTextView.h
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/23.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZTTextViewDelegate <UITextViewDelegate>

@optional
- (void)textViewTouchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end

@interface ZTTextView : UITextView

@property (nonatomic, weak) id <ZTTextViewDelegate> delegate;
@property (nonatomic, copy) IBInspectable NSString *placeholder;
@property (nonatomic, copy) IBInspectable UIColor *placeholderColor;
@property(nonatomic, assign) NSInteger maxLength;
@end
