//
//  RepeatTime_TableViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/9.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "RepeatTime_TableViewController.h"

@interface RepeatTime_TableViewController ()

@property (nonatomic, strong) NSArray *date_array;
@property (nonatomic, strong) NSMutableArray *select_array;

@end

@implementation RepeatTime_TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIButton *leftbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回 (1)"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    
    
    self.select_array = [NSMutableArray array];
    self.title = @"重复时间";
    _date_array = @[@"每周日",@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六"];
    self.view.backgroundColor = Line_Color;
    
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)back {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"repeattime" object:self.select_array userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.date_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.date_array[indexPath.row];

    if (self.select_tag == 1 || self.select_tag == 2) {
        NSArray *array = [self.repeat_time_string componentsSeparatedByString:@","];
        if ([array containsObject:@"7"] || [array containsObject:@"每周日"]) {
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [self.select_array addObject:cell.textLabel.text];
            }
        }
        if ([array containsObject:@"1"] || [array containsObject:@"每周一"]) {
            if (indexPath.row == 1) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [self.select_array addObject:cell.textLabel.text];
            }
        }
        if ([array containsObject:@"2"] || [array containsObject:@"每周二"]) {
            if (indexPath.row == 2) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [self.select_array addObject:cell.textLabel.text];
            }
        }
        if ([array containsObject:@"3"] || [array containsObject:@"每周三"]) {
            if (indexPath.row == 3) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [self.select_array addObject:cell.textLabel.text];
            }
        }
        if ([array containsObject:@"4"] || [array containsObject:@"每周四"]) {
            if (indexPath.row == 4) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [self.select_array addObject:cell.textLabel.text];
            }
        }
        if ([array containsObject:@"5"] || [array containsObject:@"每周五"]) {
            if (indexPath.row == 5) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [self.select_array addObject:cell.textLabel.text];
            }
        }
        if ([array containsObject:@"6"] || [array containsObject:@"每周六"]) {
            if (indexPath.row == 6) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [self.select_array addObject:cell.textLabel.text];
            }
        }
    }
    NSLog(@"select_array = %@",self.select_array);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.select_array removeObject:cell.textLabel.text];
    }else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.select_array addObject:cell.textLabel.text];
    }
}



@end
