//
//  YMGroupCell.h
//  MyImagePickerDemo
//
//  Created by YuMing on 16/10/31.
//  Copyright © 2016年 YM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMGroupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
