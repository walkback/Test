//
//  Home_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/19.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "Home_ViewController.h"
#import "Macro.h"
#import <Masonry.h>
#import <MMDrawerController.h>
#import <UIViewController+MMDrawerController.h>
#import "UIViewController+MMDrawerController.h"
#import "MyDeviceViewController.h"
#import "XYBannerView.h"
#import <UIImageView+WebCache.h>

#import "Ad_Request.h"
#import "AdWebViewController.h"

#import "Scenes_Request.h"


#import "SecondViewController.h"

#import "MusicMode_ViewController.h"


@interface Home_ViewController ()<UITableViewDelegate,UITableViewDataSource,XYBannerViewDelegate>
{
    int  vListen;
    BOOL  isOpen; //灯的开关
    BOOL  isGesture;//灯的手势
    BOOL isClock; //闹钟的手势
    int  page;
    UIScrollView * modelSuperScrollView;
}
@property (nonatomic, strong) MMDrawerController *drawerController;
@property (nonatomic, strong) UIView * blackWindow;

@property (strong, nonatomic) UIBarButtonItem *leftButton;
@property (assign, nonatomic) NSInteger selectedRowCell;

@property (nonatomic, strong) UITableView * lightTableView;
@property (nonatomic, strong) NSMutableArray * scenes_data_array;

//暗亮滑动条
@property (nonatomic, strong) UISlider *darkBirghtSlider;

@property (nonatomic, strong) NSArray * colorSelectedArray;//选择颜色
@property (nonatomic, strong) NSArray * colorSelectedRecommendArray;//命令的颜色
@property (nonatomic, strong) NSString * colorRecommend;
@property (nonatomic, strong)  UIButton * selectedButton;

@property (nonatomic, strong) UIButton * tableCellOpenButton;
@property (nonatomic, strong) UIButton * tableCellGestureButton;
@property (nonatomic, strong)  UIImageView * tableCelllightImageView;
@property (nonatomic, strong) UIButton * selectedcurrentButton;


@end

@implementation Home_ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    [self  checkRecommand];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
//查询状态的命令3
-(void)checkRecommand
{
    NSString * cleckRM = [RecommedManager  readStatus];
    [[AyncSocketManager  shareAyncManager] postRecommed:cleckRM result:^(NSString *task) {
        NSLog(@"最后的结果 = %@",task);
        self->isOpen = [ManagerTool toGetLightOpen:task];
        self->isGesture = [ManagerTool  toGetLightGesture:task];
        self->isClock = [ManagerTool  toGetLightClock:task];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self  refreshTableViewCellWithOpen:self->isOpen withGesture:self->isGesture];
        });
    }];
     
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Line_Color;
    _scenes_data_array = [NSMutableArray  array];

    //(默认色：白色；粉色)
    _colorSelectedArray = [NSArray  arrayWithObjects:RGB(223, 222, 224),RGB(248, 221, 233),RGB(237, 151, 144),RGB(239, 155, 46),RGB(223, 103, 38),[UIColor  blackColor], nil];
    _colorSelectedRecommendArray = [NSArray  arrayWithObjects:@"055055050",@"001010100",@"045010100",@"000010033",@"000000002",@"000000000", nil];
    //默认声音为3
    vListen = 3;
    [self addNavigationBarUI];
    
    _lightTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGT) style:UITableViewStylePlain];
    _lightTableView.backgroundColor = self.view.backgroundColor;
    _lightTableView.showsVerticalScrollIndicator = NO;
    _lightTableView.delegate = self;
    _lightTableView.dataSource = self;
    _lightTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.view  addSubview:_lightTableView];
        //场景的请求
    [self setupRefresh];

}

#pragma mark - 集成刷新

-(void)setupRefresh {
    self.lightTableView.mj_header=[YJSLoadingHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [self.lightTableView.mj_header beginRefreshing];
    
    self.lightTableView.mj_footer = [YJSLoadingFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}
-(void)headerRefresh {
    page=1;
    [self dataforscenes];
    [self.lightTableView.mj_header endRefreshing];
}
-(void)footerRefresh {
    
    page += 1;
    [self dataforscenes];
    [self.lightTableView.mj_footer endRefreshing];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return   SCREEN_HEIGT/3;
    }else if (indexPath.section == 1) {
        return 220;
    }else {
        return 300;
    }
    return 300;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [[UIView  alloc]init];
    }
    UIView * headerView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    headerView.backgroundColor = self.view.backgroundColor;
    return headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
         UITableViewCell * openCell = [tableView  dequeueReusableCellWithIdentifier:@"cellOpenCell"];
        if (!openCell) {
            openCell = [[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellOpenCell"];
            openCell.selectionStyle = UITableViewCellSelectionStyleNone;
            //左面的图片
            UIImageView * leftLightImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4 *3, SCREEN_HEIGT/3)];
            leftLightImageView.backgroundColor = [UIColor whiteColor];
            [openCell  addSubview:leftLightImageView];
            
            UIImageView * lightImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0 , 20, leftLightImageView.frame.size.width , leftLightImageView.frame.size.height- 20)];
            [leftLightImageView  addSubview:lightImageView];
            self.tableCelllightImageView = lightImageView;
            
            //右边的View
            UIImageView *rightOpenImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4 *3, 0, SCREEN_WIDTH/4 , SCREEN_HEIGT/3)];
            rightOpenImageView.backgroundColor = [UIColor whiteColor];
            [openCell  addSubview:rightOpenImageView];
            rightOpenImageView.userInteractionEnabled = YES;
            
            UIButton * openButton = [UIButton  buttonWithType:UIButtonTypeCustom];
            openButton.frame = CGRectMake(rightOpenImageView.frame.size.width - 90, 10, 80, 44);
            if (isOpen == YES) {
                [openButton setImage:[UIImage imageNamed:@"open_on.png"] forState:UIControlStateNormal];
                lightImageView.image = [UIImage imageNamed:@"light_itemOpen.png"];
            }else
            {
                [openButton setImage:[UIImage imageNamed:@"open_close.png"] forState:UIControlStateNormal];
                //light_itemOpen
                lightImageView.image = [UIImage imageNamed:@"light_close.png"];

            }
            [openButton addTarget:self action:@selector(openActionClick:) forControlEvents:UIControlEventTouchUpInside];
            [rightOpenImageView  addSubview:openButton];
            self.tableCellOpenButton = openButton;
            
            UILabel * openStatusLabel = [[UILabel  alloc]initWithFrame:CGRectMake(rightOpenImageView.frame.size.width - 70, 54, 60, 20)];
            openStatusLabel.text = @"开启关闭";
            openStatusLabel.font = [UIFont  systemFontOfSize:13];
            openStatusLabel.textAlignment = NSTextAlignmentRight;
            [rightOpenImageView  addSubview:openStatusLabel];
            
            
            UIButton * gestureButton = [UIButton  buttonWithType:UIButtonTypeCustom];
            gestureButton.frame = CGRectMake(rightOpenImageView.frame.size.width - 90, CGRectGetMaxY(openStatusLabel.frame), 80, 44);
            if (isGesture == YES) {
                [gestureButton setImage:[UIImage imageNamed:@"open_on.png"] forState:UIControlStateNormal];

            }else
            {
                [gestureButton setImage:[UIImage imageNamed:@"open_close.png"] forState:UIControlStateNormal];

            }
            [gestureButton  addTarget:self action:@selector(gestureButtonActionClick:) forControlEvents:UIControlEventTouchUpInside];
            [rightOpenImageView  addSubview:gestureButton];
            self.tableCellGestureButton = gestureButton;
            
            UILabel * gestureStatusLabel = [[UILabel  alloc]initWithFrame:CGRectMake(rightOpenImageView.frame.size.width - 70, CGRectGetMaxY(openStatusLabel.frame) + 44, 60, 20)];
            gestureStatusLabel.text = @"感应关闭";
            gestureStatusLabel.font = [UIFont  systemFontOfSize:13];
            gestureStatusLabel.textAlignment = NSTextAlignmentRight;
            [rightOpenImageView  addSubview:gestureStatusLabel];
            
            //恢复默认
            UIButton * backDefaultButton = [UIButton  buttonWithType:UIButtonTypeCustom];
            backDefaultButton.frame = CGRectMake(rightOpenImageView.frame.size.width - 95, CGRectGetMaxY(gestureStatusLabel.frame), 80, 35);
            backDefaultButton.backgroundColor = RGB(107, 196, 257);
            backDefaultButton.layer.cornerRadius = 10;
            backDefaultButton.layer.masksToBounds = YES;
            backDefaultButton.titleLabel.font = [UIFont  systemFontOfSize:13];
            [backDefaultButton  setTitle:@"恢复默认" forState:UIControlStateNormal];
            [backDefaultButton  setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
            [backDefaultButton  addTarget:self action:@selector(backDefaultButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [rightOpenImageView  addSubview:backDefaultButton];
            
            
            //24小时的导入
            UIButton * hourseButton = [UIButton  buttonWithType:UIButtonTypeCustom];
            hourseButton.frame = CGRectMake(rightOpenImageView.frame.size.width - 95, CGRectGetMaxY(backDefaultButton.frame) + 10, 80, 35);
            hourseButton.backgroundColor = RGB(107, 196, 257);
            hourseButton.layer.cornerRadius = 10;
            hourseButton.layer.masksToBounds = YES;
            hourseButton.titleLabel.font = [UIFont  systemFontOfSize:13];
            [hourseButton  setTitle:@"24小时导入" forState:UIControlStateNormal];
            [hourseButton  setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
            [hourseButton  addTarget:self action:@selector(hourseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [rightOpenImageView  addSubview:hourseButton];
            
        }
        return openCell;
    }

    if (indexPath.section == 1) {
        
        UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:@"changeCell"];
        if (!cell) {
            
            cell = [[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"changeCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel * colorLabel = [[UILabel  alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
            colorLabel.text = @"色彩选择";
            colorLabel.font = [UIFont systemFontOfSize:15];
            colorLabel.textAlignment = NSTextAlignmentLeft;
            [cell  addSubview:colorLabel];
            
            UIScrollView * colorScrollView = [[UIScrollView  alloc]initWithFrame:CGRectMake(colorLabel.frame.origin.x, CGRectGetMaxY(colorLabel.frame) + 10, SCREEN_WIDTH - 20, 35)];
            colorScrollView.showsHorizontalScrollIndicator = NO;
            colorScrollView.contentSize = CGSizeMake(90 * 6 - (90 - 72), 0);
            colorScrollView.delegate = self;
            colorScrollView.pagingEnabled = YES;
            [cell  addSubview:colorScrollView];
            
            for (int i = 0; i < 6; i++) {
                
                UIButton * colorButton = [UIButton  buttonWithType:UIButtonTypeCustom];
                colorButton.frame = CGRectMake(90*i, 0, 72, 35);
                colorButton.backgroundColor = _colorSelectedArray[i];
                colorButton.layer.masksToBounds = YES;
                colorButton.layer.cornerRadius = 8;
                colorButton.tag = i;
                [colorButton  addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [colorScrollView  addSubview:colorButton];
            }
            UIImageView * colorLine = [[UIImageView  alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(colorLabel.frame) + 64, SCREEN_WIDTH - 10, 1)];
            colorLine.backgroundColor = [UIColor  lightGrayColor];
            [cell  addSubview:colorLine];
            
            
            UILabel * lightLabel = [[UILabel  alloc]initWithFrame:CGRectMake(colorLabel.frame.origin.x, CGRectGetMaxY(colorLine.frame) + 20, 100, 20)];
            lightLabel.text = @"亮度调节";
            lightLabel.font = [UIFont systemFontOfSize:15];
            lightLabel.textAlignment = NSTextAlignmentLeft;
            [cell  addSubview:lightLabel];
            //调节亮度左边的图片
            UIImageView * lightLeftImg = [[UIImageView  alloc]initWithFrame:CGRectMake(lightLabel.frame.origin.x, CGRectGetMaxY(lightLabel.frame) + 10, 30, 30)];
            lightLeftImg.image = [UIImage imageNamed:@"light_leftColor.png"];
            [cell  addSubview:lightLeftImg];
            
            //调节亮度右边的图片
            UIImageView * lightRightImg = [[UIImageView  alloc]initWithFrame:CGRectMake(CGRectGetMaxX(colorLine.frame) - 35, CGRectGetMaxY(lightLabel.frame) + 10, 30, 30)];
            lightRightImg.image = [UIImage imageNamed:@"light_rightColor.png"];
            [cell  addSubview:lightRightImg];
            
            
            //暗亮滑动条
            self.darkBirghtSlider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lightLeftImg.frame) + 5, CGRectGetMaxY(lightLabel.frame) + 10, colorLine.frame.size.width - 80, 30)];
            self.darkBirghtSlider.minimumValue = 0;
            self.darkBirghtSlider.maximumValue = 255;
            self.darkBirghtSlider.minimumTrackTintColor = RGB(21, 242, 255);
            self.darkBirghtSlider.maximumTrackTintColor = RGB(203, 242, 255);
            self.darkBirghtSlider.value = 20;
            [self.darkBirghtSlider addTarget:self action:@selector(darkBirghtClick:) forControlEvents:UIControlEventValueChanged];
            self.darkBirghtSlider.continuous = NO;
            [cell addSubview:self.darkBirghtSlider];
            [_darkBirghtSlider setThumbImage:[UIImage imageNamed:@"go"] forState:UIControlStateNormal];
            [_darkBirghtSlider setThumbImage:[UIImage imageNamed:@"go"] forState:UIControlStateHighlighted];

//            GradientSlider * colorSlider  = [[GradientSlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lightLeftImg.frame) + 5, CGRectGetMaxY(lightLabel.frame) + 50, colorLine.frame.size.width - 80, 30)];
//            [colorSlider trackRectForBounds:CGRectMake(CGRectGetMaxX(lightLeftImg.frame) + 5, CGRectGetMaxY(lightLabel.frame) + 60, colorLine.frame.size.width - 80, 20)];
//            [cell  addSubview:colorSlider];
    
        }
        return cell;
        
    }
  
    UITableViewCell * sceenCell = [tableView  dequeueReusableCellWithIdentifier:@"sceenCell"];
    if (!sceenCell) {
        sceenCell = [[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sceenCell"];
        sceenCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel * modelLabel = [[UILabel  alloc]initWithFrame:CGRectMake(10, 20, 100, 20)];
        modelLabel.text = @"固定场景";
        modelLabel.font = [UIFont systemFontOfSize:15];
        modelLabel.textAlignment = NSTextAlignmentLeft;
        [sceenCell  addSubview:modelLabel];
        
        UIScrollView * modelScrollView = [[UIScrollView  alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 300 - 40)];
        modelScrollView.showsHorizontalScrollIndicator = NO;
        modelScrollView.delegate = self;
        modelScrollView.pagingEnabled = YES;
        modelScrollView.tag = 1400;
        [sceenCell  addSubview:modelScrollView];
    }
    UIScrollView * modelScrollView = (UIScrollView *)[sceenCell  viewWithTag:1400];
    modelScrollView.contentSize = CGSizeMake(140 * self.scenes_data_array.count, 0);
    for (int i = 0; i < self.scenes_data_array.count; i ++ ) {
        NSDictionary * tbSceneDataDic = self.scenes_data_array[i];
        NSString * tac_content = tbSceneDataDic[@"tsc_name"];
        NSString * imageUrl = tbSceneDataDic[@"tsc_icon_file"];
        NSString * zhengImageUrl = [NSString  stringWithFormat:@"%@%@",RootUrl,imageUrl];
        UIView * modelView = [[UIView  alloc]initWithFrame:CGRectMake(10 + 140 * i, 10, 120, 120/3 *4)];
        modelView.backgroundColor = [UIColor  whiteColor];
        [modelScrollView  addSubview:modelView];
        
        UIImageView * screenImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, modelView.frame.size.width,  modelView.frame.size.height- 20)];
        [screenImageView sd_setImageWithURL:[NSURL  URLWithString:zhengImageUrl] placeholderImage:[UIImage  imageNamed:@"sleep.png"]];
        [modelView  addSubview:screenImageView];
        
        UILabel * screenBottomLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(screenImageView.frame), modelView.frame.size.width, 20)];
        screenBottomLabel.textAlignment =NSTextAlignmentCenter;
        screenBottomLabel.text = tac_content;
        screenBottomLabel.textColor = RGB(81, 81, 81);
        [screenImageView addSubview:screenBottomLabel];
        
        UIButton * clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clickButton.layer.masksToBounds = YES;
        clickButton.layer.cornerRadius = 8;
        clickButton.layer.borderColor = [UIColor  lightGrayColor].CGColor;
        clickButton.layer.borderWidth = 1;
        clickButton.tag = i + 100;
        clickButton.frame = CGRectMake(0, 0, modelView.frame.size.width, modelView.frame.size.height);
        [clickButton addTarget:self action:@selector(clickButtonResponse:) forControlEvents:UIControlEventTouchUpInside];
        [modelView  addSubview:clickButton];
    }
    return sceenCell;
}
#pragma mark ----场景的选择-----
-(void)clickButtonResponse:(UIButton *)sender
{
   
    sender.selected = !sender.selected;
    UIButton * currentButton = sender;
    if (sender.selected) {
        self.selectedcurrentButton.backgroundColor = [UIColor clearColor];
        self.selectedcurrentButton.layer.borderColor = [UIColor  lightGrayColor].CGColor;
        self.selectedcurrentButton.alpha = 1;
        
        currentButton.backgroundColor = RGB(209, 231, 250);
        currentButton.layer.borderColor =  RGB(20, 87, 249).CGColor;
        currentButton.alpha = 0.5;
        self.selectedcurrentButton = currentButton;
        
        NSInteger  index =  sender.tag - 100;
        NSDictionary * dataDic =  self.scenes_data_array[index];
        NSString * remarksColor = dataDic[@"tsc_remarks"];
        NSArray * colors = [remarksColor  componentsSeparatedByString:@","];
        NSString * recommend = [RecommedManager  toSetLightAmountAaa:colors[0] bbb:colors[1] ccc:colors[2]];
        [[AyncSocketManager  shareAyncManager] postRecommed:recommend result:^(NSString *task) {
            if ([task  isEqualToString:@"DMX5OK"]) {
                [ManagerTool  alert:@"设置颜色成功!"];
            }else
            {
                [ManagerTool  alert:@"设置颜色失败！"];
            }
            [self  checkRecommand];
        }];
        
    }else
    {
        currentButton.backgroundColor = [UIColor  clearColor];
        currentButton.layer.borderColor = [UIColor  lightGrayColor].CGColor;
        currentButton.alpha = 1;
    }


   
}

#pragma mark -----灯的开关---
-(void)openActionClick:(UIButton *)sender
{
    isOpen = !isOpen;
    NSString * openRM = [RecommedManager  openLight:isOpen openGuster:isGesture openClock:isClock];
    NSLog(@"输出一下此时的命令的开关 = %@",openRM);
    [[AyncSocketManager  shareAyncManager] postRecommed:openRM result:^(NSString *task) {
        if ([task  isEqualToString:@"DMX4OK"]) {
            [self  checkRecommand];
        }
    }];

}
#pragma mark ---灯的感应开关---
-(void)gestureButtonActionClick:(UIButton *)sender
{
    isGesture = !isGesture;
    NSString * gestureRM = [RecommedManager  openLight:isOpen openGuster:isGesture openClock:isClock];
    [[AyncSocketManager  shareAyncManager] postRecommed:gestureRM result:^(NSString *task) {
        if ([task  isEqualToString:@"DMX4OK"]) {
            [self  checkRecommand];
        }
    }];
}

#pragma mark----恢复默认的按钮-----
-(void)backDefaultButtonClick:(UIButton *)sender
{
    NSString * backRM = [RecommedManager  backLight];
    [[AyncSocketManager  shareAyncManager] postRecommed:backRM result:^(NSString *task) {
        if ([task  isEqualToString:@"DMX6OK"]) {
            [ManagerTool  alert:@"恢复默认成功!"];
        }else
        {
            [ManagerTool  alert:@"恢复默认失败！"];
        }
        [self  checkRecommand];

    }];
    
}
#pragma mark ---24小时时间导入----
-(void)hourseButtonClick:(UIButton *)sender
{
    NSLog(@"24小时导入按钮");
    NSString *string = [[NSBundle mainBundle]pathForResource:@"DayDefault.plist" ofType:nil];
    NSArray *hourArr = [[NSArray alloc]initWithContentsOfFile:string];
    NSLog(@"24小时的hourArray = %zi",hourArr.count);
    NSString * hourseRecommend = [RecommedManager  dayTwentyHourseWithPlistArray:hourArr];
    NSLog(@"----输出此时的24小时的日光照 = %@",hourseRecommend);
    //dayTwentyHourseWithPlistArray
    [[AyncSocketManager  shareAyncManager] postRecommed:hourseRecommend result:^(NSString *task) {
        if ([task  isEqualToString:@"DMX1OK"]) {
            [ManagerTool  alert:@"设置颜色成功!"];
        }else
        {
            [ManagerTool  alert:@"设置颜色失败！"];
        }
        [self  checkRecommand];
    }];
}
#pragma mark ---色彩选择----
-(void)colorButtonClick:(UIButton *)sender
{
    NSString * color = _colorSelectedRecommendArray[sender.tag];
    NSString * aaa = [color substringWithRange:NSMakeRange(0, 3)];
    NSString * bbb = [color substringWithRange:NSMakeRange(3, 3)];
    NSString * ccc = [color substringWithRange:NSMakeRange(6, 3)];
    NSString *  chengeColorRM= [RecommedManager toSetLightAmountAaa:aaa bbb:bbb ccc:ccc];
    [[AyncSocketManager  shareAyncManager] postRecommed:chengeColorRM result:^(NSString *task) {
        if ([task  isEqualToString:@"DMX5OK"]) {
            [ManagerTool  alert:@"设置颜色成功!"];
        }else
        {
            [ManagerTool  alert:@"设置颜色失败！"];
        }
        [self  checkRecommand];
    }];
}
#pragma mark-----暗亮调节命令-----
- (void)darkBirghtClick:(UISlider *)slider
{
    NSString *str = [[NSString alloc]initWithFormat:@"%f",self.darkBirghtSlider.value];
    //由于输出为小数，转化成整数
    NSString * chengeDouble = [NSString  stringWithFormat:@"%i",[str intValue]];
    if (chengeDouble.length == 2) {
        chengeDouble = [NSString  stringWithFormat:@"0%@",chengeDouble];
    }
    if (chengeDouble.length == 1) {
        chengeDouble = [NSString  stringWithFormat:@"00%@",chengeDouble];
    }
    NSString * changeColorRM = [RecommedManager  toSetLightAmountAaa:chengeDouble bbb:chengeDouble ccc:chengeDouble];
    [[AyncSocketManager  shareAyncManager] postRecommed:changeColorRM result:^(NSString *task) {
        if ([task  isEqualToString:@"DMX5OK"]) {
            [ManagerTool  alert:@"设置颜色成功!"];
        }else
        {
            [ManagerTool  alert:@"设置颜色失败！"];
        }
        [self  checkRecommand];
    }];
}

/*
#pragma mark ----24个按钮点击----
-(void)twenty_fourClick:(UIButton *)sender
{
    NSLog(@"=---点点点点");
    NSString *string = [[NSBundle mainBundle]pathForResource:@"Twenty-fourLightWakeUp.plist" ofType:nil];
    NSArray *hourArr = [[NSArray alloc]initWithContentsOfFile:string];
    NSLog(@"//////hourArr[sender.tag - 1]:%@",hourArr[sender.tag - 1]);
    NSString * checkCodeMessage = [NSString stringWithFormat:@"%@",hourArr[sender.tag - 1]];
    NSArray * recommendArray = [NSArray arrayWithObjects:checkCodeMessage, nil];
    NSLog(@"----输出一下今天的结果 = %@",checkCodeMessage);
    _changeRecommend = [RecommedManager  dayTwentyHourseWithArray:recommendArray];
    NSLog(@"----输出一下命令1 = %@",_changeRecommend);
    [self  socketConnectHost];
}
#pragma mark -----24小时曲线导入------
-(void)changeColorBtnClick:(UIButton *)sender
{//001010100  粉色  045010100
   // 100100100   白色   200200200
    
    NSString *currentTime = [ManagerTool getCurrentHoursAndMinutesTimes];
    NSLog(@"当前的时分秒是 = %@",currentTime);
    NSString * theCurrentTime = [currentTime  stringByReplacingOccurrencesOfString:@":" withString:@"" ];
    NSLog(@"去掉冒号的结果是 = %@",theCurrentTime);
    NSString * changeName = [NSString  stringWithFormat:@"045010100%@",theCurrentTime];
    _changeRecommend = [NSString  stringWithFormat:@"1001=%@,ffffff%@",changeName,[ManagerTool  ToHexMM:changeName]];
    NSLog(@"----24小时导入的命令=%@", _changeRecommend);
    [self   socketConnectHost];
}
#pragma mark ---查询当前灯的信息----
-(void)checkCurrentBtnClick:(UIButton *)sender
{
    _changeRecommend = [RecommedManager calibration];
    [self   socketConnectHost];
}

#pragma mark ----亮度调节-----
-(void)lightBtnClick:(UIButton *)sender
{
    _changeRecommend = [RecommedManager toSetLightAmountAaa:@"001" bbb:@"001" ccc:@"001"];
     [self   socketConnectHost];
}
#pragma mark ----场景的点击----
-(void)clickButtonResponse:(UIButton *)sender
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    
}


#pragma mark -----去校验当前时间----
-(void)toReplaceCurrentTime:(UITapGestureRecognizer *)gesture
{
    _changeRecommend = @"";
    //校验当前的时间
    [self  socketConnectHost];
    
}
*/
#pragma mark ----设置导航条内容-------
-(void)addNavigationBarUI
{
    self.navigationItem.title = @"司辰唤醒灯";
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1]}];
    self.navigationController.navigationBar.barTintColor = [UIColor  whiteColor];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"music"] forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24);
    [leftBtn  addTarget:self action:@selector(leftMusicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBackButtonItem = [[UIBarButtonItem  alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBackButtonItem;
    
    UIButton *rightDevice=[UIButton buttonWithType:UIButtonTypeCustom];
    rightDevice.frame=CGRectMake(0, 0, 44, 44);
    [rightDevice setImage:[UIImage imageNamed:@"light_item.png"] forState:UIControlStateNormal];
    rightDevice.imageEdgeInsets = UIEdgeInsetsMake(12, 24, 12, 0);
    [rightDevice  addTarget:self action:@selector(rightDeviceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightDevicekButtonItem =  [[UIBarButtonItem  alloc]initWithCustomView:rightDevice];
    self.navigationItem.rightBarButtonItem = rightDevicekButtonItem;
}

-(void)rightDeviceButtonClick:(UIButton *)sender {
 
    SecondViewController *second = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:second animated:YES];
}

-(void)leftMusicButtonClick:(UIButton *)sender{
    MusicMode_ViewController * musicVC = [[MusicMode_ViewController  alloc]init];
    [self.navigationController pushViewController:musicVC animated:YES];
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
#pragma mark 获取场景
- (void)dataforscenes {
    if ([[ManagerTool getWifiName] isEqualToString:LIGHT_NAME]) {
        return;
    }
    [self  checkRecommand];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
 
    Scenes_Request *scenes_request = [[Scenes_Request alloc] init];
    scenes_request.requestArgument = nil;
    [scenes_request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"request = %@",request.responseJSONObject);
        int code = [request.responseJSONObject[@"code"] intValue];
        NSString *message = request.responseJSONObject[@"message"];
        if (code != 100) {
            [hud hideAnimated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = message;
            [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.view);
            }];
            [hud hideAnimated:YES afterDelay:2.f];
        } else {
            [hud hideAnimated:YES];
            NSArray  * receiveDataArray = request.responseJSONObject[@"tbSceneCatalogList"];
            [self.scenes_data_array  removeAllObjects];
            for (NSDictionary * screenDic in receiveDataArray) {
                [self.scenes_data_array addObject:screenDic];
            }
        }
        [self.lightTableView  reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请求失败!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }];
}

-(void)blackWindowTap
{
    self.blackWindow.hidden = YES;
  //  [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTableViewCellWithOpen:(BOOL)open  withGesture:(BOOL)gesture
{
    if (open == YES) {
        [self.tableCellOpenButton setImage:[UIImage imageNamed:@"open_on.png"] forState:UIControlStateNormal];
        self.tableCelllightImageView.image = [UIImage imageNamed:@"light_itemOpen.png"];
    }else
    {
        [self.tableCellOpenButton setImage:[UIImage imageNamed:@"open_close.png"] forState:UIControlStateNormal];
        //light_itemOpen
        self.tableCelllightImageView.image = [UIImage imageNamed:@"light_close.png"];
        
    }

    if (isGesture == YES) {
        [self.tableCellGestureButton setImage:[UIImage imageNamed:@"open_on.png"] forState:UIControlStateNormal];
        
    }else
    {
        [self.tableCellGestureButton setImage:[UIImage imageNamed:@"open_close.png"] forState:UIControlStateNormal];
    }
    
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
