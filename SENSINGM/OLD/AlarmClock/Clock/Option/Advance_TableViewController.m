//
//  Advance_TableViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/9.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Advance_TableViewController.h"

@interface Advance_TableViewController ()

@property (nonatomic, strong) NSArray *time_array;

@end

@implementation Advance_TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"提前时间";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.time_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    for (int i = 0 ; i < self.time_array.count; i++) {
        if ([[NSString stringWithFormat:@"%@分钟",[NSString stringIsEmpty:self.advance_str]] isEqualToString:self.time_array[i]]) {
            if (indexPath.row == i) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    
    cell.textLabel.text = [self.time_array objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"advance" object:[NSString stringIsEmpty:self.time_array[indexPath.row]]];
}

- (NSArray *)time_array {
    if (!_time_array) {
        _time_array = [NSArray arrayWithObjects:@"不提前",@"5分钟",@"10分钟",@"20分钟",@"30分钟", nil];
    }
    return _time_array;
}

@end
