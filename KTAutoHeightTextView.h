//
//  KTAutoHeightTextView.h
//
//  Created by kevin.tu on 16/2/24.
//  Copyright © 2016年 ov. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface KTAutoHeightTextView : UITextView

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *maxHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *minHeightConstraint;
// 是否显示圆角边界
@property (nonatomic, assign) IBInspectable BOOL showsRoundCorner;
// placeholder
@property (nonatomic, copy) IBInspectable NSString *placeholder;

@end
