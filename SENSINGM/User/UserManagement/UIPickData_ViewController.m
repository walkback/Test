//
//  UIPickData_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/12/13.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "UIPickData_ViewController.h"

@interface UIPickData_ViewController () <UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *pickview;
}

@property (nonatomic, strong) NSArray *data_array;
@property (nonatomic, copy) NSString *character_str;

@end

@implementation UIPickData_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    self.data_array = @[@"强迫症",@"小心眼",@"铁公鸡",@"做作",@"虚伪"];
    
    pickview = [[UIPickerView alloc] init];
    pickview.backgroundColor = UIColor.whiteColor;
    pickview.delegate = self;
    pickview.dataSource = self;
    [self.view addSubview:pickview];
    [pickview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT / 3);
    }];
    
    self.character_str = self.data_array[0];
    
    UIView *but_view = [UIView new];
    but_view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:but_view];
    [but_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self->pickview.mas_top);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *cancel_but = [UIButton new];
    [cancel_but setTitle:@"取消" forState:UIControlStateNormal];
    [cancel_but setTitleColor:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0] forState:UIControlStateNormal];
    cancel_but.titleLabel.font = [UIFont systemFontOfSize:14];
    [but_view addSubview:cancel_but];
    [cancel_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(but_view);
        make.left.equalTo(but_view).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [[cancel_but rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
    UIButton *submit_but = [UIButton new];
    [submit_but setTitle:@"确定" forState:UIControlStateNormal];
    [submit_but setTitleColor:[UIColor colorWithRed:39/255.0 green:151/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    cancel_but.titleLabel.font = [UIFont systemFontOfSize:14];
    [but_view addSubview:submit_but];
    [submit_but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(but_view);
        make.right.equalTo(but_view).offset(-15);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [[submit_but rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self dismissViewControllerAnimated:true completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"character" object:self.character_str];
    }];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.data_array.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.data_array[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.character_str = [NSString stringIsEmpty:self.data_array[row]];
    
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
