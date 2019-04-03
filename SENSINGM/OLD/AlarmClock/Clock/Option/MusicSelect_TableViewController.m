//
//  MusicSelect_TableViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/9.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "MusicSelect_TableViewController.h"

@interface MusicSelect_TableViewController ()

@property (nonatomic, strong) NSArray *musicList;

@end

@implementation MusicSelect_TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _musicList = @[@"lightM_01.caf",
                   @"lightM_02.caf",
                   @"lightM_03.caf",
                   @"lightM_04.caf",
                   @"hotM_01.caf",
                   @"hotM_02.caf"];
    
    self.title = @"选择音乐";
    self.tableView.backgroundColor = Line_Color;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    for (int i = 0 ; i < self.musicList.count; i++) {
        if ([[NSString stringIsEmpty:self.music_name] isEqualToString:self.musicList[i]]) {
            if (indexPath.row == i) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }

    cell.textLabel.text = self.musicList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"music" object:[NSString stringIsEmpty:self.musicList[indexPath.row]]];
}



@end
