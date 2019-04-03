//
//  CustomScene_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/17.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "CustomScene_ViewController.h"
#import "SystemScenario_Cell.h"
#import "AddScene_TableViewController.h"

@interface CustomScene_ViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableView;
}

@property (nonatomic) BOOL switch_bool;

@end

@implementation CustomScene_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _switch_bool = false;
    
    tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[SystemScenario_Cell class] forCellReuseIdentifier:@"SystemScenario"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 200;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-45);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemScenario_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemScenario" forIndexPath:indexPath];
    
    NSArray *array = @[@"img_00",@"img_01",@"img_02",@"img_03",@"img_04"];
    cell.bg_imagev.image = [UIImage imageNamed:array[indexPath.section]];
    [[[cell.switch_but rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        x.selected = !x.selected;
        if (x.selected && self->_switch_bool == false) {
            self->_switch_bool = true;
            [cell.switch_but setBackgroundImage:[UIImage imageNamed:@"开"] forState:UIControlStateNormal];
            cell.bg_imagev.image = [UIImage imageNamed:array[indexPath.section]];
        } else {
            self->_switch_bool = false;
            [cell.switch_but setBackgroundImage:[UIImage imageNamed:@"关"] forState:UIControlStateNormal];
            UIImage *image = [self changeGrayImage:[UIImage imageNamed:array[indexPath.section]]];
            cell.bg_imagev.image = image;
        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backButtonItem;
    AddScene_TableViewController *addScene = [[AddScene_TableViewController alloc] init];
    addScene.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addScene animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [UIView new];
    header_view.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    return header_view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return 90;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [UIView new];
    if (section == 4) {
        UIButton *add_but = [UIButton new];
        [add_but setTitle:@"+ 自定义场景" forState:UIControlStateNormal];
        [add_but setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
        [add_but setBackgroundColor:UIColor.whiteColor];
        [footer_view addSubview:add_but];
        [add_but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(footer_view);
            make.left.equalTo(footer_view).offset(15);
            make.right.equalTo(footer_view).offset(-15);
            make.height.mas_equalTo(60);
        }];
    }
    return footer_view;
}

-(UIImage *)changeGrayImage:(UIImage *)oldImage {
    int bitmapInfo = kCGImageAlphaNone;
    int width = oldImage.size.width;
    int height = oldImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), oldImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
