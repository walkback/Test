//
//  LabelViewController.m
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/23.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import "LabelViewController.h"
#import "Macro.h"

@interface LabelViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (nonatomic, strong) NSString *clockname_str;

@end

@implementation LabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Line_Color;
    
    self.title = @"标签";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    
    if (self.data) {
        self.textfield.text = self.data;
    }
    self.textfield.backgroundColor = [UIColor whiteColor];
    self.textfield.textColor = [UIColor blackColor];
}

#pragma mark -- override
- (void)action_backItem {
    
    if (self.block) {
        self.block(self.textfield.text);
    }
    [super action_backItem];
}

@end

