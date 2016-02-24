//
//  TableViewCell.h
//  KTAutoHeightTextView
//
//  Created by tujinqiu on 16/2/24.
//  Copyright © 2016年 tujinqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end
