//
//  ViewController.m
//  KTAutoHeightTextView
//
//  Created by tujinqiu on 16/2/24.
//  Copyright © 2016年 tujinqiu. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;

@property (nonatomic, strong) NSArray *comments;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 15.0;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.timeLabel.text = [dateFormatter stringFromDate:date];
    
    self.comments = @[
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"],
                      @[@"Header", @"风景美如画！"]
                      ];
    
    self.commentNumLabel.text = [NSString stringWithFormat:@"%lu评论", (unsigned long)self.comments.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    NSArray *comment = [self.comments objectAtIndex:indexPath.row];
    cell.headerImageView.image = [UIImage imageNamed:[comment firstObject]];
    cell.commentLabel.text = [comment lastObject];
    
    return cell;
}

@end
