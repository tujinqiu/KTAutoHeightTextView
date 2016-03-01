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

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layoutFinished = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextDidChange:) name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark -- notifis --

- (void)handleTextDidChange:(NSNotification *)notif
{
    if (!self.placeholder)
    {
        return;
    }
    
    UITextView *textView = notif.object;
    self.placeholderLabel.hidden = textView.text.length > 0;
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
    if (placeholder)
    {
        if (!_placeholderLabel)
        {
            _placeholderLabel = [[UILabel alloc] init];
            _placeholderLabel.font = self.font;
            _placeholderLabel.textAlignment = NSTextAlignmentLeft;
            UIEdgeInsets inset = self.textContainerInset;
            CGRect bounds = self.bounds;
            _placeholderLabel.frame = CGRectMake(4.0, inset.top, bounds.size.width - inset.left - inset.right, self.font.lineHeight);
            _placeholderLabel.textColor = [UIColor colorWithWhite:0.801 alpha:1.000];
            [self addSubview:_placeholderLabel];
            _placeholderLabel.text = placeholder;
        }
        _placeholderLabel.hidden = self.text.length > 0;
    }
    else
    {
        if (_placeholderLabel)
        {
            [_placeholderLabel removeFromSuperview];
            _placeholderLabel = nil;
        }
    }
}

#pragma mark -- 重写系统的setter --

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    if (_placeholderLabel)
    {
        UIEdgeInsets insets = self.textContainerInset;
        CGRect bounds = self.bounds;
        _placeholderLabel.frame = CGRectMake(4.0, insets.top, bounds.size.width - insets.left - insets.right, font.lineHeight);
    }
}

- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    
    // 监听size变化
    if (self.font)
    {
        if (self.layoutFinished) // 更新约束或者大小
        {
            CGFloat fitHeight = [self sizeThatFits:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)].height;
            if (fabs(fitHeight - self.bounds.size.height) < self.font.lineHeight * 0.5) // 变化量小于一个行距的0.5倍
            {
                [self findHeightConstraint];
                return;
            }
            if (self.heightConstraint)
            {
                self.heightConstraint.constant = fitHeight;
                [self layoutIfNeeded];
            }
            else
            {
                CGRect bounds = self.bounds;
                bounds.size.height = fitHeight;
                self.bounds = bounds;
            }
        }
        else // 查找height约束，记录初值
        {
            [self findHeightConstraint];
        }
    }
}

- (void)findHeightConstraint
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

@end
