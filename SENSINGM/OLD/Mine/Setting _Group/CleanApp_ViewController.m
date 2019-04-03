//
//  CleanApp_ViewController.m
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/26.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import "CleanApp_ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImageManager.h>

@interface CleanApp_ViewController () <UIAlertViewDelegate>
@property (assign) float cacheSize;
@end

@implementation CleanApp_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"缓存清理";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self readCacheSize];
    [self clearCacheAction];
}

-( float )readCacheSize {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [self folderSizeAtPath:cachePath];
}

- ( float )folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    
    return folderSize/( 1024.0 * 1024.0);
}

// 计算 单个文件的大小
- ( long long )fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}

- (void)clearCacheAction {
    //读取缓存大小
    self.cacheSize = [self readCacheSize] *1024;
    NSString *message = [NSString stringWithFormat:@"是否清理%.2fKB缓存",self.cacheSize];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *action_submit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clearFile];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:action_cancel];
    [alertController addAction:action_submit];
    [self presentViewController:alertController animated:YES completion:nil];

}

//2. 清除缓存
- (void)clearFile
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
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
