//
//  KTKeyboardAvoidingView.h
//
//  Created by kevin.tu on 16/1/22.
//  Copyright © 2016年 ov. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface KTKeyboardAvoidingView : UIView

@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *OVLayoutGuideConstraint;
@property (nonatomic, assign) IBInspectable BOOL touchesOusideAutoHide;

@end
