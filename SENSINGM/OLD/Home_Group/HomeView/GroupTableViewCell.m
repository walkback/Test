//
//  GroupTableViewCell.m
//  WaekLight
//
//  Created by apple001 on 2018/6/16.
//  Copyright © 2018年 HJTech. All rights reserved.
//

#import "GroupTableViewCell.h"
#define View_WIDTH  ( (SCREEN_WIDTH - 12)/2)
#define View_HEIGHT (210 - 4)
#define LEFT_START  ((View_WIDTH - 90)/2)

@implementation GroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:( NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor  colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
        
        UIView * leftBackView = [[UIImageView  alloc]initWithFrame:CGRectMake(4, 4, View_WIDTH, View_HEIGHT)];
        leftBackView.backgroundColor = [UIColor  whiteColor];
        [self.contentView  addSubview:leftBackView];
        
        //编辑状态
        self.editLeftImageView = [[UIImageView alloc]init];
        self.editLeftImageView.frame = CGRectMake(LEFT_START - 11, (View_HEIGHT - 130)/2 + (45 - 11), 22, 22);
        self.editLeftImageView.image = [UIImage imageNamed:@"圆圈"];
        [leftBackView  addSubview: self.editLeftImageView];
        self.editLeftImageView.hidden = YES;
        
        self.leftImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(LEFT_START, (View_HEIGHT - 130)/2, 90,90)];
        self.leftImageView.backgroundColor = [UIColor  whiteColor];
        
        [leftBackView  addSubview:self.leftImageView];
        
        self.leftTitleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(LEFT_START, CGRectGetMaxY(self.leftImageView.frame) + 10, self.leftImageView.frame.size.width, 20)];
       
        self.leftTitleLabel.textAlignment = NSTextAlignmentCenter;
        [leftBackView  addSubview:self.leftTitleLabel];
        
        self.leftCellButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        self.leftCellButton.frame = CGRectMake(0, 0, leftBackView.frame.size.width, leftBackView.frame.size.height);
        leftBackView.userInteractionEnabled = YES;
        [leftBackView  addSubview:  self.leftCellButton];
        
        UIView * rightBackView = [[UIImageView  alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftBackView.frame) + 4, 4, View_WIDTH, View_HEIGHT)];
        rightBackView.backgroundColor = [UIColor  whiteColor];
        [self.contentView  addSubview:rightBackView];

        //编辑状态
        self.editRightImageView = [[UIImageView  alloc] init];
        self.editRightImageView.frame = CGRectMake(LEFT_START - 11, (View_HEIGHT - 130)/2 + (45 - 11), 22, 22);
        self.editRightImageView.image = [UIImage imageNamed:@"圆圈"] ;
        [rightBackView  addSubview: self.editRightImageView];
        self.editRightImageView.hidden = YES;
        
        
        self.rightImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(LEFT_START,(View_HEIGHT - 130)/2, 90,90)];
        self.rightImageView.backgroundColor = [UIColor  whiteColor];
        [rightBackView  addSubview:self.rightImageView];
        
        
        self.rightTitleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(LEFT_START, CGRectGetMaxY(self.rightImageView.frame) + 10, 90, 20)];
        self.rightTitleLabel.textAlignment = NSTextAlignmentCenter;
        [rightBackView  addSubview:self.rightTitleLabel];
        
        self.rightCellButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        self.rightCellButton.frame = CGRectMake(0, 0, rightBackView.frame.size.width, rightBackView.frame.size.height);
        rightBackView.userInteractionEnabled = YES;
        [rightBackView  addSubview:  self.rightCellButton];
        
//        [self.leftCellButton addTarget:self action:@selector(leftCellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.rightCellButton addTarget:self action:@selector(rightCellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)reloadLeftEdit:(BOOL)leftResult  rightEdit:(BOOL)rightResult
{
    if (leftResult == YES) {
        //编辑的状态
        self.editLeftImageView.hidden = NO;
        self.leftImageView.frame = CGRectMake(LEFT_START + 22, (View_HEIGHT - 130)/2, 90,90);
        self.leftTitleLabel.frame = CGRectMake(LEFT_START + 22, CGRectGetMaxY(self.leftImageView.frame) + 10, self.leftImageView.frame.size.width, 20);


    }else
    {
        //非编辑的状态
        self.editLeftImageView.hidden = YES;
        self.leftImageView.frame = CGRectMake(LEFT_START, (View_HEIGHT - 130)/2, 90,90);
        self.leftTitleLabel.frame = CGRectMake(LEFT_START, CGRectGetMaxY(self.leftImageView.frame) + 10, self.leftImageView.frame.size.width, 20);
    }
    
    if (rightResult == YES) {
        //编辑的状态
         self.editRightImageView.hidden = NO;
        self.rightImageView.frame = CGRectMake(LEFT_START + 22,(View_HEIGHT - 130)/2, 90,90);
        self.rightTitleLabel.frame = CGRectMake(LEFT_START+22, CGRectGetMaxY(self.rightImageView.frame) + 10, self.rightImageView.frame.size.width, 20);
    }else
    {
        //非编辑的状态
         self.editRightImageView.hidden = YES;
        self.rightImageView.frame = CGRectMake(LEFT_START,(View_HEIGHT - 130)/2, 90,90);
        self.rightTitleLabel.frame = CGRectMake(LEFT_START, CGRectGetMaxY(self.rightImageView.frame) + 10, self.rightImageView.frame.size.width, 20);

    }
}
-(void)reloadEdit:(BOOL)result
{
    if (result == YES) {
        //编辑的状态
        self.editLeftImageView.hidden = NO;
        self.editRightImageView.hidden = NO;
        self.leftImageView.frame = CGRectMake(LEFT_START + 22, (View_HEIGHT - 130)/2, 90,90);
        self.leftTitleLabel.frame = CGRectMake(LEFT_START + 22, CGRectGetMaxY(self.leftImageView.frame) + 10, self.leftImageView.frame.size.width, 20);
        self.rightImageView.frame = CGRectMake(LEFT_START + 22,(View_HEIGHT - 130)/2, 90,90);
        self.rightTitleLabel.frame = CGRectMake(LEFT_START+22, CGRectGetMaxY(self.rightImageView.frame) + 10, self.rightImageView.frame.size.width, 20);
        //圆圈中

    }else
    {
        //非编辑的状态
        self.editLeftImageView .image = [UIImage imageNamed:@"圆圈中"] ;
        self.editRightImageView.image = [UIImage imageNamed:@"圆圈"] ;
        self.editLeftImageView.hidden = YES;
        self.editRightImageView.hidden = YES;
        self.leftImageView.frame = CGRectMake(LEFT_START, (View_HEIGHT - 130)/2, 90,90);
        self.leftTitleLabel.frame = CGRectMake(LEFT_START, CGRectGetMaxY(self.leftImageView.frame) + 10, self.leftImageView.frame.size.width, 20);
        self.rightImageView.frame = CGRectMake(LEFT_START,(View_HEIGHT - 130)/2, 90,90);
        self.rightTitleLabel.frame = CGRectMake(LEFT_START, CGRectGetMaxY(self.rightImageView.frame) + 10, self.rightImageView.frame.size.width, 20);
    }
}
#pragma mark ----试一试
-(void)editRightButtonClick:(UIButton *)sender
{
    NSLog(@"试一试有没有结果");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
