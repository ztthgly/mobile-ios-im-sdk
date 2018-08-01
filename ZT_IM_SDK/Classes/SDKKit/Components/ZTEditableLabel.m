//
//  ZTEditableLabel.m
//  ZT_IM_SDK
//
//  Created by Deemo on 2018/7/24.
//

#import "ZTEditableLabel.h"

@implementation ZTEditableLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    [self attachTapHandler];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:));
}

-(void)copy:(id)sender {
    if (self.content && self.content.length > 0) {
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = self.content;
    }
    
}

-(void)attachTapHandler {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    touch.minimumPressDuration = 0.8;
    [self addGestureRecognizer:touch];
}

-(void)handleTap:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan){
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.frame inView:self.superview];
        menu.arrowDirection = UIMenuControllerArrowDown;
        menu.menuVisible = YES;
    }
}

@end
