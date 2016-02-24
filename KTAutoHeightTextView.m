//
//  KTAutoHeightTextView.m
//
//  Created by kevin.tu on 16/2/24.
//  Copyright © 2016年 ov. All rights reserved.
//

#import "KTAutoHeightTextView.h"

@interface KTAutoHeightTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@property (nonatomic, assign) BOOL layoutFinished;

@end

@implementation KTAutoHeightTextView

#pragma mark -- life cycle --

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layoutFinished = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- notifis --

- (void)handleTextDidChange:(NSNotification *)notif
{
    UITextView *textView = notif.object;
    if (textView.text.length > 0 && self.placeholder)
    {
        self.placeholderLabel.hidden = YES;
    }
    else
    {
        self.placeholderLabel.hidden = NO;
    }
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
    _placeholder = placeholder;
    if (placeholder && [self.text isEqualToString:@""])
    {
        self.placeholderLabel.hidden = NO;
        self.placeholderLabel.text = placeholder;
    }
    else
    {
        self.placeholderLabel.hidden = YES;
    }
}

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel)
    {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = self.font;
        _placeholderLabel.textAlignment = NSTextAlignmentLeft;
        UIEdgeInsets insets = self.textContainerInset;
        CGRect bounds = self.bounds;
        NSDictionary *attr = @{NSFontAttributeName : self.font};
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        CGRect suggestRect = [@"placeholder" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1.0) options:options attributes:attr context:nil];
        _placeholderLabel.frame = CGRectMake(4.0, insets.top, bounds.size.width - insets.left - insets.right, suggestRect.size.height);
        _placeholderLabel.textColor = [UIColor colorWithWhite:0.801 alpha:1.000];
        [self addSubview:_placeholderLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return _placeholderLabel;
}

#pragma mark -- 重写系统的setter --

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    if (_placeholderLabel)
    {
        UIEdgeInsets insets = self.textContainerInset;
        CGRect bounds = self.bounds;
        NSDictionary *attr = @{NSFontAttributeName : font};
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        CGRect suggestRect = [@"placeholder" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1.0) options:options attributes:attr context:nil];
        _placeholderLabel.frame = CGRectMake(insets.left, insets.top, bounds.size.width - insets.left - insets.right, suggestRect.size.width);
    }
}

- (void)setContentSize:(CGSize)contentSize
{
    CGFloat oldHeight = self.contentSize.height;
    
    [super setContentSize:contentSize];
    
    // 监听size变化
    if (self.font)
    {
        if (self.layoutFinished) // 更新约束或者大小
        {
            if (self.heightConstraint)
            {
                self.heightConstraint.constant += contentSize.height - oldHeight;
                [self layoutIfNeeded];
            }
            else
            {
                CGRect bounds = self.bounds;
                bounds.size.height += contentSize.height - oldHeight;
                self.bounds = bounds;
            }
        }
        else // 查找height约束，记录初值
        {
            if (self.heightConstraint)
            {
                return;
            }
            for (NSLayoutConstraint *constraint in self.constraints)
            {
                if (constraint.secondItem == nil && constraint.firstAttribute == NSLayoutAttributeHeight)
                {
                    self.heightConstraint = constraint;
                    break;
                }
            }
        }
    }
}

@end
