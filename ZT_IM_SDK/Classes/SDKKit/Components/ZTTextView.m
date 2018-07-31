//
//  ZTTextView.m
//  ZT_IM_SDK_Example
//
//  Created by Deemo on 2018/5/23.
//  Copyright © 2018年 ICSOC. All rights reserved.
//

#import "ZTTextView.h"

@interface ZTTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, copy) UIColor *defaultiOSPlaceholderColor;

@property (nonatomic, copy) NSArray *placeholderLabelConstraints;

@end

@implementation ZTTextView
@dynamic delegate;

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeholderLabel.text = _placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = _placeholderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    self.placeholderLabel.textAlignment = textAlignment;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self textDidChange];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
    [super setTextContainerInset:textContainerInset];
    [self updateConstraintsForPlaceholderLabel];
}

- (nonnull instancetype)initWithFrame:(CGRect)frame textContainer:(nullable NSTextContainer *)textContainer
{
    self = [super initWithFrame:frame textContainer:textContainer];
    [self commonInit];
    return self;
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self commonInit];
    return self;
}

- (void)commonInit
{
    self.placeholderLabelConstraints = @[];
    
    self.defaultiOSPlaceholderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0980392 alpha:0.22];
    self.placeholder = @"";
    self.placeholderColor = self.defaultiOSPlaceholderColor;
    self.placeholderLabel = [UILabel new];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.textColor = self.placeholderColor;
    self.placeholderLabel.textAlignment = self.textAlignment;
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.placeholderLabel];
    
    [self updateConstraintsForPlaceholderLabel];
}

- (void)updateConstraintsForPlaceholderLabel
{
    self.placeholderLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.placeholderLabel.frame = CGRectMake(self.textContainerInset.left + self.textContainer.lineFragmentPadding, self.textContainerInset.top, self.bounds.size.width - self.textContainerInset.left - self.textContainer.lineFragmentPadding - self.textContainerInset.right, 20);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateConstraintsForPlaceholderLabel];
}

- (void)textDidChange
{
    self.placeholderLabel.hidden = self.text.length;
    
    if (!self.maxLength) {
        return;
    }
    
    if (self.text.length > self.maxLength) {
        self.text = [self.text substringToIndex:self.maxLength];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(textViewTouchesBegan:withEvent:)]) {
        [self.delegate textViewTouchesBegan:touches withEvent:event];
    }
}

@end

