//
//  ViewController.m
//  MyImagePickerDemo
//
//  Created by YuMing on 16/10/28.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "ViewController.h"
#import "YMRootPhotoTableView.h"
#import "YMPhotosViewController.h"
#import "PicCell.h"

@interface ViewController () <YMPhotosViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handlePush)];
    [self config];
}

- (void)config {
    //配置信息
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //创建collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //注册
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PicCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([PicCell class])];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PicCell class]) forIndexPath:indexPath];
    cell.picImageView.image = self.imageArray[indexPath.row];
    return cell;
}



- (void)handlePush {
    
    //通过这种方法默认加载入相册而非列表
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[YMRootPhotoTableView alloc] init]];
    [self presentViewController:navi animated:YES completion:nil];
    YMPhotosViewController *photo = [[YMPhotosViewController alloc] init];
    photo.maxSelect = 9 - self.imageArray.count;
    photo.delegate = self;
    [navi pushViewController:photo animated:NO];

}

- (void)ymPhotosViewController:(YMPhotosViewController *)photoViewController didCommitWithArray:(NSArray<UIImage *> *)imageArray {
    [self.imageArray addObjectsFromArray:imageArray];
    if (self.imageArray.count == 9) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    [self.collectionView reloadData];
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
