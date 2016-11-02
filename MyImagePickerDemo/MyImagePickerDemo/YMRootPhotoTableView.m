//
//  YMRootPhotoTableView.m
//  MyImagePickerDemo
//
//  Created by YuMing on 16/10/31.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "YMRootPhotoTableView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YMGroupCell.h"
#import "YMPhotosViewController.h"

@interface YMRootPhotoTableView ()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) NSMutableArray *assetsGroupArray;

@end

@implementation YMRootPhotoTableView



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self config];
    
}

- (void)config {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(handleCancel)];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YMGroupCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([YMGroupCell class])];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    self.tableView.rowHeight = 80;
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        NSLog(@"%@",error);
    };
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        
        if ([group numberOfAssets] > 0)
        {
            [self.assetsGroupArray addObject:group];
        }
        else
        {
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    //取出分组
    [self.assetsLibrary enumerateGroupsWithTypes:(ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos) usingBlock:listGroupBlock failureBlock:failureBlock];
}
//让tableView的分割线没有左侧缝隙
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)handleCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)assetsGroupArray {
    if (!_assetsGroupArray) {
        _assetsGroupArray = [NSMutableArray array];
    }
    return _assetsGroupArray;
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.assetsGroupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YMGroupCell class])];
    
    ALAssetsGroup *groupForCell = self.assetsGroupArray[indexPath.row];
    CGImageRef posterImageRef = [groupForCell posterImage];
    UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef];
    cell.picImageView.image = posterImage;
    cell.groupLabel.text = [groupForCell valueForProperty:ALAssetsGroupPropertyName];
    cell.countLabel.text = [NSString stringWithFormat:@"(%@)", @(groupForCell.numberOfAssets)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.assetsGroupArray.count > indexPath.row) {

        YMPhotosViewController *photos = [[YMPhotosViewController alloc] init];
        photos.assetsGroup = self.assetsGroupArray[indexPath.row];
        photos.navigationItem.title = [photos.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        [self.navigationController pushViewController:photos animated:YES];
    }
}

- (ALAssetsLibrary *)assetsLibrary {
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
