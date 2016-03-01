//
//  KTKeyboardAvoidingView.m
//
//  Created by kevin.tu on 16/1/22.
//  Copyright © 2016年 ov. All rights reserved.
//

#import "KTKeyboardAvoidingView.h"

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

@interface KTKeyboardAvoidingView ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat priorHeight;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, weak) UIWindow *textWindow;

@end

@implementation KTKeyboardAvoidingView

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

- (void)setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OVKeyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OVKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OVKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OVTextDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OVTextDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OVTextDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OVTextDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];

    self.priorHeight = self.OVLayoutGuideConstraint.constant;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- notifications and actions --

- (void)OVKeyboardWillShow:(NSNotification *)notif
{
    CGRect keyboardRect = [self convertRect:[[[notif userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    if (CGRectIsEmpty(keyboardRect))
    {
        return;
    }
    
    self.OVLayoutGuideConstraint.constant = keyboardRect.size.height;
    [UIView animateWithDuration:[[[notif userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]
                          delay:0.0
                        options:[[[notif userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                     animations:^{
                         [self layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)OVKeyboardDidShow:(NSNotification *)notif
{
    if (self.textWindow && self.touchesOusideAutoHide && ![self.textWindow.gestureRecognizers containsObject:self.tapGesture])
    {
        [self.textWindow addGestureRecognizer:self.tapGesture];
    }
}

- (void)OVKeyboardWillHide:(NSNotification *)notif
{
    self.OVLayoutGuideConstraint.constant = self.priorHeight;
    [UIView animateWithDuration:[[[notif userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]
                          delay:0.0
                        options:[[[notif userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                     animations:^{
                         [self layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)OVTextDidBeginEditing:(NSNotification *)notif
{
    if (self.touchesOusideAutoHide)
    {
        self.textWindow = ((UIView *)(notif.object)).window;
    }
}

- (void)OVTextDidEndEditing:(NSNotification *)notif
{
    if ([self.textWindow.gestureRecognizers containsObject:self.tapGesture])
    {
        [self.textWindow removeGestureRecognizer:self.tapGesture];
    }
}

- (void)tapOuside:(UITapGestureRecognizer *)tap
{
    if (!self.touchesOusideAutoHide)
    {
        return;
    }
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [self endEditing:YES];
    }
}

#pragma mark -- getter and setter --

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture)
    {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOuside:)];
        _tapGesture.delegate = self;
        _tapGesture.cancelsTouchesInView = NO;
    }
    
    return _tapGesture;
}

#pragma mark -- UIGestureRecognizerDelegate --

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ([[touch view] isKindOfClass:[UIControl class]] || [[touch view] isKindOfClass:[UINavigationBar class]]) ? NO : YES;
}

@end
