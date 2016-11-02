//
//  YMPhotosViewController.m
//  MyImagePickerDemo
//
//  Created by YuMing on 16/11/1.
//  Copyright © 2016年 YM. All rights reserved.
//

#import "YMPhotosViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YMPhotoCell.h"
#import "YMPageViewController.h"
#import "YMPageViewData.h"

@interface YMPhotosViewController () <YMPhotoCellDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
//记录当前相册分组中的图片
@property (nonatomic, strong) NSMutableArray *assets;
//记录选中的数组
@property (nonatomic, strong) NSMutableArray *selectArray;
//用来枚举的ALAssetsLibrary类必须强引用否则取不出图片
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
//collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
//当前选择中的图片用来进行判断 预览时选中的图片
@property (nonatomic, strong) ALAsset *currentAsset;
//下方功能栏
@property (nonatomic, strong) UIView *bottomView;
//计数的label
@property (nonatomic, strong) UILabel *countLabel;
//预览按钮
@property (nonatomic, strong) UIButton *seeButton;
//提交按钮
@property (nonatomic, strong) UIButton *commitButton;

@end

@implementation YMPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self createRightButton];
    [self createBottomView];
    
}

- (void)config {
    self.navigationController.navigationBar.translucent = NO;

    self.view.backgroundColor = [UIColor whiteColor];
    //配置信息
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //创建collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50) collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //注册
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YMPhotoCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([YMPhotoCell class])];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //如果直接进入该页面则默认取相册的内容
    if (!self.fromRootFlag) {
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
            NSLog(@"%@",error);
        };
        //临时记录分组的容器
        NSMutableArray *assetsGroupArray = [NSMutableArray array];
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            
            if ([group numberOfAssets] > 0)
            {
                //判断是否是(相机中的所有照片)的类型
                if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue]==ALAssetsGroupSavedPhotos)
                {
                    [assetsGroupArray insertObject:group atIndex:0];
                }else
                {
                    [assetsGroupArray addObject:group];
                }
            }
            else
            {
                self.navigationItem.title = [[assetsGroupArray firstObject] valueForProperty:ALAssetsGroupPropertyName];
                //取出第一个分组
                [self performSelectorOnMainThread:@selector(handleAssets:) withObject:[assetsGroupArray firstObject] waitUntilDone:NO];
            }
        };
        //通过上面配置的block来调用枚举取出相册分组中的内容
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:listGroupBlock failureBlock:failureBlock];
    }else {//如果是从root页面跳转则根据选择的分组进行设置
        [self performSelectorOnMainThread:@selector(handleAssets:) withObject:self.assetsGroup waitUntilDone:NO];
    }
    
}

- (void)createRightButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(handleCancel)];
}
//关闭页面
- (void)handleCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//创建下方的功能栏
- (void)createBottomView {
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40 - 64, self.view.frame.size.width, 40)];
    [self.view addSubview:self.bottomView];
    self.bottomView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    
    self.seeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.seeButton.frame = CGRectMake(10, 5, 50, 30);
    [self.bottomView addSubview:self.seeButton];
    [self.seeButton setTitle:@"预览" forState:UIControlStateNormal];
    [self.seeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.seeButton addTarget:self action:@selector(handleSeeButton) forControlEvents:UIControlEventTouchUpInside];
    self.seeButton.userInteractionEnabled = NO;
    
    self.commitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.commitButton.frame = CGRectMake(self.view.frame.size.width - 60, 5, 50, 30);
    [self.bottomView addSubview:self.commitButton];
    [self.commitButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.commitButton setTitleColor:[UIColor colorWithRed:0.000 green:0.502 blue:0.000 alpha:1.000] forState:UIControlStateNormal];
    [self.commitButton addTarget:self action:@selector(handleCommitButton) forControlEvents:UIControlEventTouchUpInside];
    self.commitButton.userInteractionEnabled = NO;
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60 - 20, 10, 20, 20)];
    [self.bottomView addSubview:self.countLabel];
    self.countLabel.backgroundColor = [UIColor colorWithRed:0.000 green:0.502 blue:0.000 alpha:1.000];
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.layer.cornerRadius = 10;
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.hidden = YES;
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)handleSeeButton {
    //将数组排序
    [self.selectArray sortUsingComparator:^NSComparisonResult(ALAsset *obj1, ALAsset *obj2) {
        NSDate *ob1Date = [obj1 valueForProperty:ALAssetPropertyDate];
        NSDate *ob2Date = [obj2 valueForProperty:ALAssetPropertyDate];
        return [ob1Date compare:ob2Date];
    }];
    //根据选择的内容设置数据源
    [[YMPageViewData sharedInstance] setPhotoAssets:self.selectArray];
    //跳转的pageViewController类
    YMPageViewController *page = [[YMPageViewController alloc] init];
    page.startingIndex = [self.selectArray indexOfObject:self.currentAsset];
    [self.navigationController pushViewController:page animated:YES];
}

- (void)handleCommitButton {
    //将数组排序
    [self.selectArray sortUsingComparator:^NSComparisonResult(ALAsset *obj1, ALAsset *obj2) {
        NSDate *ob1Date = [obj1 valueForProperty:ALAssetPropertyDate];
        NSDate *ob2Date = [obj2 valueForProperty:ALAssetPropertyDate];
        return [ob1Date compare:ob2Date];
    }];
    if ([self.delegate respondsToSelector:@selector(ymPhotosViewController:didCommitWithArray:)]) {
        //将排序好的asset取出image返回出去
        [self.delegate ymPhotosViewController:self didCommitWithArray:[self photosWithArray:self.selectArray]];
        [self handleCancel];
    }
    
}
//返回装载图片的数组
- (NSArray <UIImage *>*)photosWithArray:(NSArray *)arr {
    NSMutableArray *photoArray = [NSMutableArray array];
    for (ALAsset *asset in arr) {
        @autoreleasepool {
            ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
            UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
                                                           scale:[assetRepresentation scale]
                                                     orientation:UIImageOrientationUp];
            [photoArray addObject:fullScreenImage];
        }
    }
    return photoArray;
}

#pragma mark - 取出分组中的图片
- (void)handleAssets:(ALAssetsGroup *)grops {
    //从相册分组中取出ALAsset类
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.assets addObject:result];
        }else {
            //当分组图片都添加完毕后通过时间进行排序
            [self.assets sortUsingComparator:^NSComparisonResult(ALAsset *obj1, ALAsset *obj2) {
                NSDate *ob1Date = [obj1 valueForProperty:ALAssetPropertyDate];
                NSDate *ob2Date = [obj2 valueForProperty:ALAssetPropertyDate];
                return [ob1Date compare:ob2Date];
            }];
            //刷新collectionview
            [self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:NO];
        }
    };
    //遍历取出图片
    ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
    [grops setAssetsFilter:onlyPhotosFilter];
    [grops enumerateAssetsUsingBlock:assetsEnumerationBlock];
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YMPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YMPhotoCell class]) forIndexPath:indexPath];
    ALAsset *asset = self.assets[indexPath.row];
    cell.asset = asset;
    cell.delegate = self;
    //如果存在则设置yes
    cell.isSelect = [self.selectArray containsObject:asset];
    return cell;
}
#pragma mark - CellDelegate
- (void)handleSelectImage:(YMPhotoCell *)cell isSelect:(BOOL)select asset:(ALAsset *)asset {
    //点击按钮如果YES则移除
    if (!select) {
        if (self.selectArray.count < self.maxSelect) {
            [self.selectArray addObject:asset];
            self.currentAsset = asset;
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"你最多只能选择%ld张照片", self.maxSelect] message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:okAction];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        }
        
    }else {
        [self.selectArray removeObject:asset];
        if (self.currentAsset == asset) {
            //如果移除了选择数组中,最后选择的图片,则默认选择数组中第一位
            self.currentAsset = self.selectArray.firstObject;
        }
    }
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.assets indexOfObject:asset] inSection:0]]];
    //通过选中的图片更改下方功能栏按钮的状态
    if (self.selectArray.count > 0) {
        self.countLabel.hidden = NO;
        self.seeButton.userInteractionEnabled = YES;
        self.commitButton.userInteractionEnabled = YES;
        
        [self.seeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.commitButton setTitleColor:[UIColor colorWithRed:0.000 green:0.502 blue:0.000 alpha:1.000] forState:UIControlStateNormal];
        //赋值
        self.countLabel.text = [NSString stringWithFormat:@"%ld", self.selectArray.count];
        //放大
        if (self.selectArray.count < self.maxSelect) {
            [UIView animateWithDuration:0.25f animations:^(){
                self.countLabel.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
            } completion:^(BOOL done){
                [UIView animateWithDuration:0.1f animations:^(){
//                    self.countLabel.transform = CGAffineTransformIdentity;
                    self.countLabel.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
                }];
            }];
        }
    }else{
        self.countLabel.hidden = YES;
        self.seeButton.userInteractionEnabled = NO;
        self.commitButton.userInteractionEnabled = NO;
        [self.seeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.commitButton setTitleColor:[UIColor colorWithRed:0.000 green:0.318 blue:0.160 alpha:1.000] forState:UIControlStateNormal];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //默认点击时查看所有图片，点击预览时查看选中数组图片
    //初始化数据源
    [[YMPageViewData sharedInstance] setPhotoAssets:self.assets];
    
    YMPageViewController *page = [[YMPageViewController alloc] init];
    page.startingIndex = indexPath.row;
    [self.navigationController pushViewController:page animated:YES];
}


#pragma mark - 懒加载

- (ALAssetsLibrary *)assetsLibrary {
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (NSMutableArray *)assets {
    if (!_assets) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    }
    return _selectArray;
}

- (NSInteger)maxSelect {
    if (_maxSelect == 0) {
        _maxSelect = 9;
    }
    return _maxSelect;
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
