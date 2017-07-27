//
//  PhotoBrowserVC.m
//  ehome
//
//  Created by WONG on 16/8/3.
//  Copyright © 2016年 hongsui. All rights reserved.
//

#import "PhotoBrowserVC.h"
#import "PhotoBrowserCCell.h"
#import "UIViewController+JHTransition.h"

@interface PhotoBrowserVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerTransitioningDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;

@property (nonatomic,strong) UIPageControl *pageControl;

@end

static NSString * const PhotoBrowserCCellIdentifier = @"PhotoBrowserCCellIdentifier";

@implementation PhotoBrowserVC

+ (instancetype)PhotoBrowserWithImages:(NSArray<UIImage *> *)images selectIndexPath:(NSIndexPath *)indexPath {
    PhotoBrowserVC *vc = [PhotoBrowserVC new];
    vc.images = images;
    vc.selectIndexPath = indexPath;
    return vc;
}

+ (instancetype)PhotoBrowserWithUrls:(NSArray<NSString *> *)urls selectIndexPath:(NSIndexPath *)indexPath {
    PhotoBrowserVC *vc = [PhotoBrowserVC new];
    vc.urls = urls;
    vc.selectIndexPath = indexPath;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageControl];

    // 注册cell
    [self.collectionView registerClass:[PhotoBrowserCCell class] forCellWithReuseIdentifier:PhotoBrowserCCellIdentifier];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.selectIndexPath) {
        [self.collectionView selectItemAtIndexPath:self.selectIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionRight];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.selectIndexPath) {
        NSArray *cells = [self.collectionView visibleCells];
        self.selectImageView = [(PhotoBrowserCCell *)cells.firstObject imageView];
    }else {
        self.selectIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    }
}

- (void)dealloc {

}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.urls.count > 0) {
        return self.urls.count;
    }
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoBrowserCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoBrowserCCellIdentifier forIndexPath:indexPath];
    WeakSelf;
    cell.tapBlock = ^{
        [weakSelf addMagicMoveStartViewGroup:@[weakSelf.selectImageView]];
        weakSelf.addMagicMoveEndViewGroupBlock(indexPath);
        
        if (weakSelf.navigationController) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            return ;
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    if (self.urls.count > 0) {
        cell.urlStr = self.urls[indexPath.row];
    }else {
        cell.image = self.images[indexPath.row];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    double page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = (int)page;
    
    
}

#pragma mark - lazy load

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 10, self.view.frame.size.height) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 10);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor blackColor];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        
        _layout.itemSize = self.view.bounds.size;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumInteritemSpacing = 10;
        _layout.minimumLineSpacing = 10;
    }
    return _layout;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        //设置显示几页
        if (self.urls.count > 0) {
            _pageControl.numberOfPages = self.urls.count;
        }else {
            _pageControl.numberOfPages = self.images.count;
        }
        //设置选中的颜色与默认的颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        //设置位置
        _pageControl.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height - 60);
        
        //沿着边切掉多余的部分
        //_pageControl.clipsToBounds = YES;
    }
    return _pageControl;
}

#pragma mark - setter

//- (void)setSelectImageView:(UIImageView *)selectImageView {
//    _selectImageView = selectImageView;
//    
//    UIImage *image = [self scaleToSize:_selectImageView.image];
//    _selectImageView.image = image;
//}

//将图片等比缩放到宽度等于屏幕的宽度
- (UIImage *)scaleToSize:(UIImage *)img{
    // 新的高度 / 新的宽度 = 旧的高度 / 旧的宽度
    // 新的高度 = 新的宽度(屏幕的宽度) * 旧的高度 / 旧的宽度
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = width * img.size.height / img.size.width;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, width, height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end







