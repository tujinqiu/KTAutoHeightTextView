//
//  KTAutoHeightTextView.m
//
//  Created by kevin.tu on 16/2/24.
//  Copyright © 2016年 ov. All rights reserved.
//

#import "KTAutoHeightTextView.h"

@interface KTAutoHeightTextView ()

@end

@implementation KTAutoHeightTextView

#pragma mark -- life cycle --

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self addTextViewNotificationObservers];
}

- (void)dealloc
{
    [self removeTextViewNotificationObservers];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // calculate size needed for the text to be visible without scrolling
    CGSize sizeThatFits = [self sizeThatFits:self.frame.size];
    float newHeight = sizeThatFits.height;
    // if there is any minimal height constraint set, make sure we consider that
    if (self.maxHeightConstraint) {
        newHeight = MIN(newHeight, self.maxHeightConstraint.constant);
    }
    // if there is any maximal height constraint set, make sure we consider that
    if (self.minHeightConstraint) {
        newHeight = MAX(newHeight, self.minHeightConstraint.constant);
    }
    // update the height constraint
    self.heightConstraint.constant = newHeight;
}

#pragma mark -- notifications

- (void)addTextViewNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kt_didReceiveTextViewNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kt_didReceiveTextViewNotification:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kt_didReceiveTextViewNotification:)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:self];
}

- (void)removeTextViewNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidBeginEditingNotification
                                                  object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidEndEditingNotification
                                                  object:self];
}

- (void)kt_didReceiveTextViewNotification:(NSNotification *)notification
{
    [self setNeedsDisplay];
}

#pragma mark -- getter and setter --

- (void)setShowsRoundCorner:(BOOL)showsRoundCorner
{
    _showsRoundCorner = showsRoundCorner;
    if (showsRoundCorner)
    {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 0.5;
    }
    else
    {
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 0.0;
        self.layer.borderColor = [[UIColor clearColor] CGColor];
        self.layer.borderWidth = 0.0;
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}

#pragma mark -- 重写系统的setter --

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    if (self.contentSize.height <= self.bounds.size.height + 1){
        self.contentOffset = CGPointZero; // Fix wrong contentOffset
    }
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ([self.text length] == 0 && self.placeholder) {
        [[UIColor lightGrayColor] set];
        [self.placeholder drawInRect:CGRectInset(rect, 6.0f, 8.0f) withAttributes:[self kt_placeholderTextAttributes]];
    }
}

#pragma mark - Utilities

- (NSDictionary *)kt_placeholderTextAttributes
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = self.textAlignment;
    
    return @{ NSFontAttributeName : self.font,
              NSForegroundColorAttributeName : [UIColor lightGrayColor],
              NSParagraphStyleAttributeName : paragraphStyle };
}

@end
