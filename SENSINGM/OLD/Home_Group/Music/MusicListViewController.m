//
//  MusicListViewController.m
//  SENSINGM
//
//  Created by apple on 2018/7/11.
//  Copyright © 2018年 吴志刚. All rights reserved.
//

#import "MusicListViewController.h"
#import "Music_player_view.h"
#import "MusicMode_Request.h"
#import "MusicListCell.h"


@interface MusicListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int  page;
}
@property (nonatomic, strong) UITableView * musicListTableView;
@property (nonatomic, strong) Music_player_view * music_player;
@property (nonatomic, strong) UILabel * musicNameLabel;//歌曲名称
@property (nonatomic, strong)  NSString * musicPlayNumber;//歌曲播放的曲目
@property (nonatomic) BOOL if_player;
@property (nonatomic, strong) NSMutableArray * musicListArray;
@property (nonatomic, strong) UIButton * musicPlayButton;
@property (nonatomic, assign) BOOL  nextSong;
@property (nonatomic, assign) NSUInteger remarkSongIndex;

@end

@implementation MusicListViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor  whiteColor];
    _musicListArray = [NSMutableArray  array];
    
    UIImageView * backImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGT)];
    backImageView.image = [UIImage  imageNamed:@"music_back.png"];
    [self.view  addSubview:backImageView];
    [self  addNavigationBarUI];
    
    _musicListTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGT - 64 - 80) style:UITableViewStylePlain];
    _musicListTableView.delegate  = self;
    _musicListTableView.dataSource = self;
    _musicListTableView.backgroundColor = [UIColor  clearColor];
    _musicListTableView.tableFooterView = [[UIView alloc]init];
    [_musicListTableView registerClass:[MusicListCell  class] forCellReuseIdentifier:@"musicListCell"];
    [self.view  addSubview:_musicListTableView];
    
    
    self.musicNameLabel = [[UILabel  alloc]init];
    self.musicNameLabel.textColor = RGB(81, 81, 81);
    self.musicNameLabel.font = [UIFont systemFontOfSize:14];
    self.musicNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view  addSubview:self.musicNameLabel];
    [self.musicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
        make.left.equalTo(self.view).offset(0);
        make.right.bottom.equalTo(self.view).offset(-0);
        make.height.offset(20);
    }];
    self.music_player = [Music_player_view new];
    [self.view addSubview:self.music_player];
    [self.music_player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.bottom.equalTo(self.view).offset(-0);
        make.height.offset(60);
    }];
    //播放当前歌曲
    [self.music_player.play_stop_button addTarget:self action:@selector(playorstop:) forControlEvents:UIControlEventTouchUpInside];
   //播放上一首的歌曲
    [self.music_player.previous_button addTarget:self action:@selector(playLastSong:) forControlEvents:UIControlEventTouchUpInside];
    //播放下一首的歌曲
    [self.music_player.next_button addTarget:self action:@selector(playNextSong:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupRefresh];

}
-(void)refreshMusicName:(NSString *)musicName  musicPlayOpen:(BOOL)playOpen
{
    NSLog(@"此时的歌曲名称 = %@",musicName);
    self.musicNameLabel.text = [NSString stringIsEmpty:musicName];
    self.music_player.play_stop_button.selected = playOpen;
    if (playOpen == YES) {
        [self.music_player.play_stop_button setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    }else
    {
        [self.music_player.play_stop_button setImage:[UIImage imageNamed:@"播放 (1)"] forState:UIControlStateNormal];
    }

}

#pragma mark - 集成刷新

-(void)setupRefresh {
    _musicListTableView.mj_header=[YJSLoadingHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [_musicListTableView.mj_header beginRefreshing];
    
    _musicListTableView.mj_footer = [YJSLoadingFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}
-(void)headerRefresh {
    page=1;
//    dataArr=[NSMutableArray array];
    [self music_data];
    [_musicListTableView.mj_header endRefreshing];
}
-(void)footerRefresh {
    
    page += 1;
    [self music_data];
    [_musicListTableView.mj_footer endRefreshing];
}
#pragma mark 音乐列表
- (void)music_data{
    //此时查询一下，当前正在播放的到底是哪一首
    NSString * checkSongPlayer = [RecommedManager  readSinglingNumber];
    [[AyncSocketManager  shareAyncManager] postRecommed:checkSongPlayer result:^(NSString *task) {
        NSLog(@"=-----查询返回的数据 = %@",task);
    
        if ([task  containsString:@"DMXE="]) {
            NSString * number = [task  substringWithRange:NSMakeRange(5, 4)];
            NSLog(@"----输出查询的歌曲是 = %@",number);
            if ([number hasPrefix:@"00"]) {
                number = [number stringByReplacingOccurrencesOfString:@"00" withString:@""];
            }
            if ([number hasPrefix:@"0"]) {
                number = [number  substringWithRange:NSMakeRange(1, 3)];
            }
            self.musicPlayNumber = number;
//            self.musicPlayNumber =[NSString  stringWithFormat:@"%d", [number  integerValue] + 4000];
            [self.musicListTableView reloadData];

            [ManagerTool  alert:@"当前播放歌曲查询成功!"];
        }else
        {
            [ManagerTool  alert:@"当前播放歌曲查询失败!"];
        }
    }];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    hud.minSize = CGSizeMake(150.f, 100.f);
    if (![self.tmc_Id isEqualToString:@""]) {
        __weak __typeof(self) weakSelf = self;
        MusicMode_Request *musicMode_Request = [[MusicMode_Request alloc] init];
        musicMode_Request.requestArgument = @{@"tmCataId":[NSString stringIsEmpty:self.tmc_Id],@"page":[NSString  stringWithFormat:@"%d",page],@"pageSize":@"15"};
        [musicMode_Request startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
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
                NSDictionary * mapReceiveDic = request.responseJSONObject[@"map"];
                NSArray * receiveArray = mapReceiveDic[@"rows"];
                if (self->page == 1) {
                    [weakSelf.musicListArray  removeAllObjects];
                }
                for (NSDictionary * receiveDic in receiveArray) {
                    [weakSelf.musicListArray addObject:receiveDic];
                }
                
            }
            [weakSelf.musicListTableView reloadData];
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
    } else {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"缺少必要参数!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }
    
}
#pragma mark ----播放上一首----
-(void)playLastSong:(UIButton *)sender
{
    NSLog(@"播放上一首");
    long  index =  self.musicPlayButton.tag - 1000 - 1;
    if (self.musicPlayButton.tag - 1000  == 0) {
        [ManagerTool  alert:@"已经是第一首了"];
        return;
    }
    NSDictionary *dictionary = self.musicListArray[index];
    NSString * musicNumber = [NSString  stringIsEmpty:dictionary[@"tm_order"]];
    NSLog(@"---应该得到的歌曲名 = %@",[NSString stringIsEmpty:dictionary[@"tm_name"]] );
    [self refreshMusicName:[NSString stringIsEmpty:dictionary[@"tm_name"]] musicPlayOpen:self.musicPlayButton.selected];
    int  songNumber =   [musicNumber intValue];
    NSString *  currentSongNumber = [NSString  stringWithFormat:@"%d",songNumber + 4000];
    self.musicPlayNumber = currentSongNumber;
    NSIndexPath * indexPath = [NSIndexPath  indexPathForRow:index inSection:0];
    MusicListCell * musicListCell = [self.musicListTableView  cellForRowAtIndexPath:indexPath];
    self.musicPlayButton = musicListCell.musicOpenButton;
    self.nextSong = YES;
    NSString * playMusic = [RecommedManager  playSongWithNumber:currentSongNumber withType: self.musicPlayButton.selected ? RrcommendSongPlayTypeSingle:RrcommendSongPlayTypeStop];
    [[AyncSocketManager  shareAyncManager] postRecommed:playMusic result:^(NSString *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([task  isEqualToString:@"DMX8OK"]) {
                [ManagerTool  alert:@"播放成功!"];
            }else
            {
                [ManagerTool  alert:@"播放失败！"];
            }
        });
    }];
    [self.musicListTableView reloadData];
}
#pragma mark 播放 暂停
- (void)playorstop:(UIButton *)sender {
    sender.selected = !sender.selected;
    int  songNumber =   [self.musicPlayNumber intValue];
    NSString *  currentSongNumber = [NSString  stringWithFormat:@"%d",songNumber + 4000];
    self.if_player = sender.selected ;
    NSString * playMusic = [RecommedManager  playSongWithNumber:currentSongNumber withType:self.if_player ? RrcommendSongPlayTypeSingle:RrcommendSongPlayTypeStop];
    [[AyncSocketManager  shareAyncManager] postRecommed:playMusic result:^(NSString *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([task  isEqualToString:@"DMX8OK"]) {
                [ManagerTool  alert:@"播放成功!"];
            }else
            {
                [ManagerTool  alert:@"播放失败！"];
            }
        });
     
    }];
    [self.musicListTableView reloadData];
}

#pragma mark-----歌曲播放按钮-----
-(void)musicOpenButtonClick:(UIButton *)sender
{
    sender.selected = ! sender.selected;
    [self.musicPlayButton  setImage:[UIImage imageNamed:@"musiclist_close.png"] forState:UIControlStateNormal];
    [sender  setImage: sender.selected ? [UIImage imageNamed:@"暂停"] : [UIImage imageNamed:@"musiclist_close.png"] forState:UIControlStateNormal];
    
    NSDictionary *dictionary = self.musicListArray[sender.tag - 1000];
    NSString * musicName = [NSString stringIsEmpty:dictionary[@"tm_name"]];
    NSString * musicNumber = [NSString  stringIsEmpty:dictionary[@"tm_order"]];
    self.musicPlayNumber =musicNumber;
    [self refreshMusicName:musicName musicPlayOpen:sender.selected];
    self.musicPlayButton = sender;
//    if (sender.selected == YES) {
//        NSDictionary *dictionary = self.musicListArray[sender.tag - 1000];
//        NSString * musicName = [NSString stringIsEmpty:dictionary[@"tm_name"]];
//        NSString * musicNumber = [NSString  stringIsEmpty:dictionary[@"tm_order"]];
//        self.musicPlayNumber =musicNumber;
//        [self refreshMusicName:musicName musicPlayOpen:sender.selected];
//        self.musicPlayButton = sender;
//
//    }else
//    {
//        NSDictionary *dictionary = self.musicListArray[0];
//        [self refreshMusicName:[NSString stringIsEmpty:dictionary[@"tm_name"]] musicPlayOpen:self.if_player];
//        NSString * musicNumber = [NSString  stringIsEmpty:dictionary[@"tm_order"]];
//        self.musicPlayNumber =musicNumber;
//    }
    //只要点了一次就
    self.nextSong = YES;
    
    //
  /*  int  songNumber =   [self.musicPlayNumber intValue];
    NSString *  currentSongNumber = [NSString  stringWithFormat:@"%d",songNumber + 4000];
    NSString * playMusic = [RecommedManager  playSongWithNumber:currentSongNumber withType:sender.selected ? RrcommendSongPlayTypeSingle : RrcommendSongPlayTypeStop];
    [[AyncSocketManager  shareAyncManager] postRecommed:playMusic result:^(NSString *task) {
        if ([task  isEqualToString:@"DMX8OK"]) {
            [ManagerTool  alert:@"播放成功!"];
        }else
        {
            [ManagerTool  alert:@"播放失败！"];
        }
    }];
   */
}

#pragma mark-----播放下一曲----
-(void)playNextSong:(UIButton *)sender
{
    NSLog(@"播放下一曲");
    //下一曲的indexPath.row的值
    long  index =  self.musicPlayButton.tag - 1000 + 1;
    if (index  == self.musicListArray.count) {
        //已经是最后一曲了
        index = 0;
    }
    NSDictionary *dictionary = self.musicListArray[index];
    NSString * musicNumber = [NSString  stringIsEmpty:dictionary[@"tm_order"]];
    [self refreshMusicName:[NSString stringIsEmpty:dictionary[@"tm_name"]] musicPlayOpen:self.musicPlayButton.selected];
    int  songNumber =   [musicNumber intValue];
    NSString *  currentSongNumber = [NSString  stringWithFormat:@"%d",songNumber + 4000];
    self.musicPlayNumber =currentSongNumber;
    NSLog(@"下一曲的的 = %@",currentSongNumber);
    NSIndexPath * indexPath = [NSIndexPath  indexPathForRow:index inSection:0];
    MusicListCell * musicListCell = [self.musicListTableView  cellForRowAtIndexPath:indexPath];
    self.musicPlayButton = musicListCell.musicOpenButton;
    self.nextSong = YES;
    NSString * playMusic = [RecommedManager  playSongWithNumber:currentSongNumber withType: self.musicPlayButton.selected ? RrcommendSongPlayTypeSingle:RrcommendSongPlayTypeStop];
    [[AyncSocketManager  shareAyncManager] postRecommed:playMusic result:^(NSString *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([task  isEqualToString:@"DMX8OK"]) {
                [ManagerTool  alert:@"播放成功!"];
            }else
            {
                [ManagerTool  alert:@"播放失败！"];
            }
        });
    }];
    [self.musicListTableView reloadData];
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 44)];
    UILabel * headerTitleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 34)];
    headerTitleLabel.text = self.title_string;
    headerTitleLabel.backgroundColor = RGB(231, 242, 246);
    headerTitleLabel.font = [UIFont  systemFontOfSize:16];
    headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    headerTitleLabel.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    headerTitleLabel.layer.shadowOffset = CGSizeMake(5, 5);
    headerTitleLabel.layer.shadowOpacity = 1;
    headerTitleLabel.layer.shadowRadius = 9.0;
    headerTitleLabel.layer.cornerRadius = 9.0;
    headerTitleLabel.clipsToBounds = NO;
    [headerView  addSubview:headerTitleLabel];

    return headerView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicListCell * musicListCell = [tableView  dequeueReusableCellWithIdentifier:@"musicListCell" forIndexPath:indexPath];
    musicListCell.backgroundColor = [UIColor  clearColor];
    NSDictionary *dictionary = self.musicListArray[indexPath.row];
    musicListCell.musicNameLable.text = [NSString  stringWithFormat:@"%d.%@",indexPath.row + 1,[NSString stringIsEmpty:dictionary[@"tm_name"]]];
    [musicListCell.musicOpenButton  setImage:[UIImage imageNamed:@"musiclist_close.png"] forState:UIControlStateNormal];

    musicListCell.musicOpenButton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    musicListCell.musicOpenButton.tag = indexPath.row + 1000;
    [musicListCell.musicOpenButton  addTarget:self action:@selector(musicOpenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.nextSong == NO ) {
        if (indexPath.row == 0 ) {
            [self refreshMusicName:[NSString stringIsEmpty:dictionary[@"tm_name"]] musicPlayOpen:self.if_player];
            NSString * musicNumber = [NSString  stringIsEmpty:dictionary[@"tm_order"]];
            self.musicPlayNumber =musicNumber;
            self.musicPlayButton  =  musicListCell.musicOpenButton;
            musicListCell.musicOpenButton.selected = self.if_player;
            [self.musicPlayButton setImage:self.if_player ? [UIImage  imageNamed:@"暂停"]:[UIImage imageNamed:@"musiclist_close.png"] forState:UIControlStateNormal];
        }
    }else
    {
          NSString * musicNumber = [NSString  stringIsEmpty:dictionary[@"tm_order"]];
        NSLog(@"-----输出此时的歌曲 = %@",musicNumber);
        NSLog(@"呵呵呵呵呵 = %@",self.musicPlayNumber);
        [self.musicPlayButton setImage:[self.musicPlayNumber isEqualToString:musicNumber] ? [UIImage  imageNamed:@"暂停"]:[UIImage imageNamed:@"musiclist_close.png"] forState:UIControlStateNormal];

        //[self.musicPlayNumber isEqualToString:[NSString stringWithFormat:@"%d", [musicNumber  intValue] + 4000]]
//        if ([self.musicPlayButton isEqual: musicListCell.musicOpenButton]) {
//            musicListCell.musicOpenButton.selected = self.if_player;
//            [self refreshMusicName:[NSString stringIsEmpty:dictionary[@"tm_name"]] musicPlayOpen:self.if_player];
//            self.musicPlayButton  =  musicListCell.musicOpenButton;
//            if (self.musicPlayButton.selected) {
//                [musicListCell.musicOpenButton  setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
//            }else
//            {
//                [musicListCell.musicOpenButton  setImage:[UIImage imageNamed:@"musiclist_close.png"] forState:UIControlStateNormal];
//            }
//        }
//        if (musicListCell.musicOpenButton.tag  == self.musicPlayButton.tag && self.musicPlayButton.selected) {
//            [musicListCell.musicOpenButton  setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
//        }else
//        {
//
//
//        }
    }
    return musicListCell;
}

-(void)addNavigationBarUI
{
    
    UIView *navigationBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0,WIDTH, 64)];
    [self.view addSubview:navigationBar];
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"top_back.png"] forState:UIControlStateNormal];
    [leftBtn  addTarget:self action:@selector(leftBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((WIDTH-230)/2,CGRectGetMinY(leftBtn.frame)+8, 230, 20)];
    titleLabel.text=@"列表";
    titleLabel.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:16];
    [navigationBar addSubview:titleLabel];
    
}
#pragma mark----导航条返回按钮-----
-(void)leftBackButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
