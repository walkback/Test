//
//  Address_TableViewCell.h
//  SENSINGM
//
//  Created by 吴志刚 on 2018/6/16.
//  Copyright © 2018 吴志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Address_TableViewCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, strong) UILabel *header_label;
@property (nonatomic, strong) UILabel *address_lab;
@property (nonatomic, strong) UITextView *address_detail;

@end
