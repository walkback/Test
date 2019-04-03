//
//  ClockName_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/7/9.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "ClockName_ViewController.h"

@interface ClockName_ViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) NSString *text_string;
@end

@implementation ClockName_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回 (1)"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.title = @"添加标题";
    self.view.backgroundColor = Line_Color;
    
    UIView *headerview = [UIView new];
    headerview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerview];
    [headerview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(WIDTH / 3);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];

    
    self.textfield = [UITextField new];
    [self.textfield addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.textfield.placeholder = @"添加名称";
    if (![[NSString stringIsEmpty:self.tacName] isEqualToString:@""]) {
        self.text_string = [NSString stringIsEmpty:self.tacName];
        self.textfield.text = self.text_string;
    }
    self.textfield.font = [UIFont systemFontOfSize:16];
    [headerview addSubview:self.textfield];
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(headerview);
    }];
}

- (void)back {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"text_string" object:self.text_string userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)passConTextChange:(UITextField *)textfielf {
    self.text_string = textfielf.text;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
