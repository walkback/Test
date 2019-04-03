//
//  MusicMenuViewController.m
//  WaekLight
//
//  Created by apple001 on 2018/6/14.
//  Copyright © 2018年 HJTech. All rights reserved.
//

#import "MusicMenuViewController.h"
#import "MusicMode_ViewController.h"
#import "MusicType_Request.h"
#import "RecommedManager.h"


@interface MusicMenuViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL  musicIsOpen;
}
@property (nonatomic, strong) UITableView * musicTableView;
@property (nonatomic, strong) NSMutableArray * musicDataArray;

@property (nonatomic, strong) UIButton *play_stop_button;
@property (nonatomic, strong) UIButton *previous_button; // 上一首
@property (nonatomic, strong) UIButton *next_button;  // 下一首
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *schedule_label; // 进度时间
@property (nonatomic, strong) UILabel *total_label;    // 总时间


@property (nonatomic, assign) int  musicNumber;
@property (nonatomic, strong) NSString * musicCommendStr;
@property (nonatomic, strong) NSString * recommend;
@property (nonatomic, assign) int  allSongNumber;
@end

@implementation MusicMenuViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RightMainAddBlackWindow" object:nil];
    _recommend = [RecommedManager  readStatus];
//    [self socketConnectHost];
    [self  performSelector:@selector(ofterTwoMintes) withObject:nil afterDelay:2.0f];
    
}
-(void)ofterTwoMintes
{
    _recommend = [RecommedManager readSDSingleAllNumber];
//    [self socketConnectHost];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor  whiteColor];

    //默认开始第一首歌
    _musicNumber = 4001;
        self.musicDataArray = [NSMutableArray  array];
    _musicTableView = [[UITableView  alloc] init];
    _musicTableView.delegate = self;
    _musicTableView.dataSource = self;
    _musicTableView.rowHeight = 44;
    _musicTableView.showsVerticalScrollIndicator = NO;
    _musicTableView.tableFooterView = [[UIView alloc]init];
    [self.musicTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_musicTableView];
    [self.musicTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self getdata_musictype];
}

#pragma mark 获取音乐类型
- (void)getdata_musictype {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.musicTableView animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    MusicType_Request *musicType_Request = [[MusicType_Request alloc] init];
    musicType_Request.requestArgument = nil;
    [musicType_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"request = %@",request.responseJSONObject);
        int code = [request.responseJSONObject[@"code"] intValue];
        NSString *message = request.responseJSONObject[@"message"];
        if (code != 100) {
            [hud hideAnimated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.musicTableView animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = message;
            [hud mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.view);
            }];
            [hud hideAnimated:YES afterDelay:2.f];
        } else {
            [hud hideAnimated:YES];
            NSArray * listMusicArr =request.responseJSONObject[@"rows"];
            if (listMusicArr.count > 0) {
                [self.musicDataArray removeAllObjects];
                for (NSDictionary * listMusicDic in listMusicArr) {
                    [self.musicDataArray addObject:listMusicDic];
                }
            }
        }
        [self.musicTableView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.musicTableView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请求失败!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.musicDataArray.count > indexPath.row) {
        NSDictionary * musicDic = self.musicDataArray[indexPath.row];
          cell.textLabel.text = musicDic[@"tmc_name"];
    }
    /*
     "tdc_add_date" = 1529380808000;
     "tdc_order" = 10;
     "tdc_status" = 1;
     "tmc_add_preson" = 1;
     "tmc_icon" = "<null>";
     "tmc_id" = 10;
     "tmc_mean" = "\U5206\U7c7b\U540d\U79f010";
     "tmc_name" = "\U5206\U7c7b\U540d\U79f010";                 */
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      NSDictionary * musicDic = self.musicDataArray[indexPath.row];
    MusicMode_ViewController *musicmode = [[MusicMode_ViewController alloc] init];
    musicmode.title_string = musicDic[@"tmc_name"];
    musicmode.tmc_Id = [NSString  stringWithFormat:@"%@",musicDic[@"tmc_id"]];
    [self.navigationController pushViewController:musicmode animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 180;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [UIImageView new];
    [imageView.layer setCornerRadius:40];
    imageView.layer.masksToBounds = YES;
    imageView.image = [UIImage imageNamed:@"444"];
    [headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return HEIGHT - 400 - 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    
    self.play_stop_button = [UIButton new];
    if (musicIsOpen == YES) {
        [self.play_stop_button setImage:[UIImage imageNamed:@"播放(开)"] forState:UIControlStateNormal];
    }else
    {
        [self.play_stop_button setImage:[UIImage imageNamed:@"播放(关)"] forState:UIControlStateNormal];
        
    }
    [self.play_stop_button  addTarget:self action:@selector(musicPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:self.play_stop_button];
    [self.play_stop_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footerView);
        make.centerY.mas_equalTo(footerView).offset(-30);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.previous_button = [UIButton new];
    [self.previous_button setImage:[UIImage imageNamed:@"047操作_上一首"] forState:UIControlStateNormal];
    [self.previous_button addTarget:self action:@selector(lastMusicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:self.previous_button];
    [self.previous_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.play_stop_button);
        make.left.equalTo(footerView).offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.next_button = [UIButton new];
    [self.next_button setImage:[UIImage imageNamed:@"048操作_下一首"] forState:UIControlStateNormal];
    [self.next_button  addTarget:self action:@selector(nextMusicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:self.next_button];
    [self.next_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.play_stop_button);
        make.right.equalTo(footerView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.slider = [[UISlider alloc] init];
    
    [self.slider  addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    [footerView addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.play_stop_button.mas_bottom).offset(20);
        make.left.mas_equalTo(self.previous_button);
        make.right.mas_equalTo(self.next_button);
        make.height.mas_equalTo(8);
    }];
    
    self.schedule_label = [UILabel new];
    self.schedule_label.text = @"2:44";
    self.schedule_label.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:self.schedule_label];
    [self.schedule_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slider.mas_bottom).offset(10);
        make.left.mas_equalTo(self.slider);
    }];
    
    self.total_label = [UILabel new];
    self.total_label.text = @"5:44";
    self.total_label.textAlignment = NSTextAlignmentRight;
    self.total_label.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:self.total_label];
    [self.total_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slider.mas_bottom).offset(10);
        make.left.mas_equalTo(self.schedule_label.mas_right);
        make.right.mas_equalTo(self.slider);
    }];
    
    return footerView;
}

#pragma mark -----调节音量------
-(void)sliderChangeValue:(UISlider *)sender
{
    CGFloat  voice = 9 * sender.value;
    NSString * voiceStr = [NSString  stringWithFormat:@"%lf",voice];
    NSArray * voiceArray = [voiceStr componentsSeparatedByString:@"."];
    NSString * currentVoice = [NSString  stringWithFormat:@"%@",voiceArray[0]];
    NSLog(@"slider value%@",currentVoice);
    _musicCommendStr = [RecommedManager  volumeControlWithVoice:currentVoice];
   // [self   socketConnectHost];

}


#pragma mark ---播放、暂停按钮点击------
-(void)musicPlayBtnClick:(UIButton *)sender
{
    musicIsOpen = !musicIsOpen;
    if (musicIsOpen == YES) {
        [sender  setImage:[UIImage  imageNamed:@"播放(开)"] forState:UIControlStateNormal];
        _musicCommendStr = [RecommedManager  playSongWithNumber:[NSString  stringWithFormat:@"%i",_musicNumber] withType:RrcommendSongPlayTypeSingle];
       // [self  socketConnectHost];
    }else
    {
        [sender setImage:[UIImage imageNamed:@"播放(关)"] forState:UIControlStateNormal];
        _musicCommendStr = [RecommedManager  playSongWithNumber:[NSString  stringWithFormat:@"%i",_musicNumber] withType:RrcommendSongPlayTypeStop];
     //   [self  socketConnectHost];
        
    }
}


#pragma mark ----上一曲的按钮点击------
-(void)lastMusicBtnClick:(UIButton *)sender
{
    if (_musicNumber == 4001) {
        [ManagerTool alert:@"已经是第一首了"];
        return;
    }
    _musicNumber-=1;
    _recommend = [RecommedManager  playSongWithNumber:[NSString  stringWithFormat:@"%i",_musicNumber] withType:RrcommendSongPlayTypeSingle];
  //  [self  socketConnectHost];
    
    [ManagerTool alert:@"上一曲"];
    NSLog(@"上一曲的按钮结果 = %i",_musicNumber);
}
#pragma mark ----下一曲按钮的点击-----
-(void)nextMusicBtnClick:(UIButton *)sender
{

    //每点击一次下一曲就查询一下总歌曲
    if (_musicNumber == 4000 + _allSongNumber + 1) {
        //        [WeakManagerTool  alert:@"已经是最后一首歌了,现在开始第一首"];
        _musicNumber = 4000;
        //        return;
    }
    _musicNumber+=1;
    _recommend = [RecommedManager  playSongWithNumber:[NSString  stringWithFormat:@"%i",_musicNumber] withType:RrcommendSongPlayTypeSingle];
 //   [self  socketConnectHost];
    [ManagerTool  alert:@"下一曲"];
    
    NSLog(@"下一曲的按钮结果 = %i",_musicNumber);
    
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
