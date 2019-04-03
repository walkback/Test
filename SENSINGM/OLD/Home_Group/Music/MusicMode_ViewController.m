//
//  MusicMode_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/20.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "MusicMode_ViewController.h"
#import "Music_header_view.h"
#import "Music_player_view.h"
#import "MusicType_Request.h"
#import "MusicMode_Request.h"
#import "Macro.h"
#import <Masonry.h>
#import "MusicModelCollectionViewCell.h"
#import "MusicListViewController.h"

@interface MusicMode_ViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
{
    int  page;
}
@property (nonatomic, strong) UICollectionView * musicCollectionView;
@property (nonatomic, strong) NSArray * armTressBackImageArray;
@property (nonatomic, strong) NSMutableArray * musicDataArray;//歌曲类型存放处
@property (nonatomic, strong) Music_header_view *music_header;
@property (nonatomic, strong) Music_player_view *music_player;
@property (nonatomic, strong) UILabel * musicNameLabel;//歌曲的名称
@property (nonatomic, strong) NSString * musicPlayNumber;//歌曲播放的曲目

@property (nonatomic) BOOL if_player;



@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *currentPlayerItem;
@property (nonatomic, assign) CGFloat music_time;
@property (nonatomic,strong)NSTimer *avTimer; //监控进度


@property (nonatomic, strong) NSArray *music_data_array;
@property (nonatomic) BOOL newItem;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSTimeInterval total;
@end

@implementation MusicMode_ViewController
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
    self.view.backgroundColor = Line_Color;
    self.armTressBackImageArray = [NSArray  arrayWithObjects:@"purple_backImage.png",@"blue_backImage.png",@"pink_backImage.png", nil];
    _musicDataArray = [NSMutableArray  array];
    UIImageView * backImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGT)];
    backImageView.image = [UIImage  imageNamed:@"music_back.png"];
    [self.view  addSubview:backImageView];
    [self  addNavigationBarUI];
    
    [self  initCollectionView];
    
    
    self.musicNameLabel = [[UILabel  alloc]init];
    self.musicNameLabel.textColor = RGB(81, 81, 81);
    self.musicNameLabel.font = [UIFont systemFontOfSize:14];
    self.musicNameLabel.textAlignment = NSTextAlignmentCenter;
    self.musicNameLabel.text = @"奇幻领域";
    self.musicPlayNumber = @"1";
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
     [self.music_player.play_stop_button addTarget:self action:@selector(playorstop:) forControlEvents:UIControlEventTouchUpInside];
    [self setupRefresh];
//    [self playWithURL];
}

#pragma mark - 集成刷新

-(void)setupRefresh {
    self.musicCollectionView.mj_header=[YJSLoadingHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [self.musicCollectionView.mj_header beginRefreshing];
    
    self.musicCollectionView.mj_footer = [YJSLoadingFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}
-(void)headerRefresh {
    page=1;
    [self getdata_musictype];
    [self.musicCollectionView.mj_header endRefreshing];
}
-(void)footerRefresh {
    
    page += 1;
    [self getdata_musictype];
    [self.musicCollectionView.mj_footer endRefreshing];
}

#pragma mark 获取音乐类型
- (void)getdata_musictype {
    
    if ([[ManagerTool getWifiName] isEqualToString:LIGHT_NAME]) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.musicCollectionView animated:YES];
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
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.musicCollectionView animated:YES];
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
        [self.musicCollectionView reloadData];
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.musicCollectionView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"请求失败!", @"HUD message title");;
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [hud hideAnimated:YES afterDelay:2.f];
    }];
    
}
- (void) initCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //设置CollectionView的属性
    self.musicCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGT - 124) collectionViewLayout:flowLayout];
//    self.musicCollectionView.backgroundColor = RGB(238, 238, 238);
    self.musicCollectionView.backgroundColor = [UIColor  clearColor];
    self.musicCollectionView.delegate = self;
    self.musicCollectionView.dataSource = self;
    self.musicCollectionView.scrollEnabled = YES;
    [self.view addSubview:self.musicCollectionView];
    //注册Cell
    [self.musicCollectionView registerClass:[MusicModelCollectionViewCell class] forCellWithReuseIdentifier:@"musicModelCell"];
}
#pragma mark ----UICollectionView的代理方法------
#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return   self.musicDataArray.count ;
    
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"musicModelCell";
    MusicModelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    //
    int value = arc4random() % self.armTressBackImageArray.count;
    cell.collectionBackImageView.image = [UIImage  imageNamed:[self.armTressBackImageArray objectAtIndex:value]];
    if (self.musicDataArray.count > indexPath.row) {
        if (indexPath.row == 0) {
            cell.remarkImageView.image = [UIImage  imageNamed:@"musicPlay_remark.png"];
        }else
        {
            cell.remarkImageView.image = [UIImage  imageNamed:@""];
        }
        NSDictionary * musicDic = self.musicDataArray[indexPath.row];
        cell.musicModelLabel.text= musicDic[@"tmc_name"];
    }
    return cell;
}



#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((SCREEN_WIDTH - 30) /2,55);
}



#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//（上、左、下、右）
}


#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * musicDic = self.musicDataArray[indexPath.item];
    MusicListViewController *musicmode = [[MusicListViewController alloc] init];
    musicmode.title_string = musicDic[@"tmc_name"];
    musicmode.tmc_Id = [NSString  stringWithFormat:@"%@",musicDic[@"tmc_id"]];
    [self.navigationController pushViewController:musicmode animated:YES];
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
    titleLabel.text=@"音乐";
    titleLabel.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:16];
    [navigationBar addSubview:titleLabel];

}
#pragma mark -----导航栏返回按钮----
-(void)leftBackButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 音乐播放
- (void)playWithURL{
    NSString *music_file = [[NSBundle mainBundle] pathForResource:@"Florida Georgia Line;Backstreet Boys-God, Your Ma" ofType:@"mp3"];
    NSURL *music_url = [NSURL fileURLWithPath:music_file];
//    NSURL *music_url = [NSURL URLWithString:@""];
    self.currentPlayerItem = [AVPlayerItem playerItemWithURL:music_url];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.currentPlayerItem];
    self.avTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
}


#pragma mark 播放 暂停
- (void)playorstop:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (self.if_player == NO) {
            self.if_player = YES;
            [self.player play];
            [sender setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
            //打开了,播放音乐
            NSString * playMusic = [RecommedManager  playSongWithNumber:@"4001" withType:RrcommendSongPlayTypeSingle];
            [[AyncSocketManager  shareAyncManager] postRecommed:playMusic result:^(NSString *task) {
                if ([task  isEqualToString:@"DMX8OK"]) {
                    [ManagerTool  alert:@"播放成功!"];
                }else
                {
                    [ManagerTool  alert:@"播放失败！"];
                }
            }];
        } else {
            self.if_player = NO;
            [self.player pause];
            [sender setImage:[UIImage imageNamed:@"播放 (1)"] forState:UIControlStateNormal];
            NSString * playMusic = [RecommedManager  playSongWithNumber:@"4001" withType:RrcommendSongPlayTypeStop];
            [[AyncSocketManager  shareAyncManager] postRecommed:playMusic result:^(NSString *task) {
                if ([task  isEqualToString:@"DMX8OK"]) {
                    [ManagerTool  alert:@"播放成功!"];
                }else
                {
                    [ManagerTool  alert:@"播放失败！"];
                }
            }];
        }
    } else {
        if (self.if_player == YES) {
            self.if_player = NO;
            [self.player pause];
            [sender setImage:[UIImage imageNamed:@"播放 (1)"] forState:UIControlStateNormal];
            NSString * playMusic = [RecommedManager  playSongWithNumber:@"4001" withType:RrcommendSongPlayTypeStop];
            [[AyncSocketManager  shareAyncManager] postRecommed:playMusic result:^(NSString *task) {
                if ([task  isEqualToString:@"DMX8OK"]) {
                    [ManagerTool  alert:@"播放成功!"];
                }else
                {
                    [ManagerTool  alert:@"播放失败！"];
                }
            }];
        } else {
            self.if_player = YES;
            [self.player play];
            [sender setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
            NSString * playMusic = [RecommedManager  playSongWithNumber:@"4001" withType:RrcommendSongPlayTypeSingle];
            [[AyncSocketManager  shareAyncManager] postRecommed:playMusic result:^(NSString *task) {
                if ([task  isEqualToString:@"DMX8OK"]) {
                    [ManagerTool  alert:@"播放成功!"];
                }else
                {
                    [ManagerTool  alert:@"播放失败！"];
                }
            }];
        }
    }
}

//#pragma mark 进度条
//- (void)timer {
//    self.music_player.schedule_label.text = [self getMMSSFromSS:[NSString stringWithFormat:@"%f", CMTimeGetSeconds(self.player.currentItem.currentTime)]];
//    self.music_player.total_label.text = [self getMMSSFromSS:[NSString stringWithFormat:@"%f", CMTimeGetSeconds(self.player.currentItem.duration)]];
//    self.music_player.slider.value = CMTimeGetSeconds(self.player.currentItem.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
//}
//
//-(NSString *)getMMSSFromSS:(NSString *)totalTime{
//
//    NSInteger seconds = [totalTime integerValue];
//    //format of minute
//    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
//    //format of second
//    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
//    //format of time
//    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
//    return format_time;
//}


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
