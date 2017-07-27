//
//  pictureView.m
//  ehome
//
//  Created by WONG on 16/7/21.
//  Copyright © 2016年 hongsui. All rights reserved.
//

#import "PictureView.h"
#import "PictureViewCell.h"

@interface PictureView ()<UICollectionViewDataSource,UICollectionViewDelegate>

/***  图片数组*/
@property (nonatomic,strong) NSArray<UIImage *> *images;
/***  图片url数组 优先使用*/
@property (nonatomic,strong) NSArray<NSString *> *urls;
/**
 *  流水布局
 */
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
/***  选中的indexPath*/
@property (nonatomic, strong) NSIndexPath * indexPath;


@end

@implementation PictureView

static NSString *ReuseIdentifier = @"PictureViewCell";
//- (instancetype)init {
//    self.backgroundColor = [UIColor clearColor];
//    // 注册cell
//    [self registerClass:[PictureViewCell class] forCellWithReuseIdentifier:ReuseIdentifier];
//
//    self.dataSource = self;
//    self.delegate = self;
//    
//    return [super initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
//}

- (instancetype)initwithImages:(NSArray<UIImage *> *)images {
    self.images = images;
    [self registerClass:[PictureViewCell class] forCellWithReuseIdentifier:ReuseIdentifier];
    self.dataSource = self;
    self.delegate = self;
     
    return [super initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
}

- (instancetype)initwithUrls:(NSArray<NSString *> *)urls {
    self.urls = urls;
    [self registerClass:[PictureViewCell class] forCellWithReuseIdentifier:ReuseIdentifier];
    self.dataSource = self;
    self.delegate = self;
    
    return [super initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
}

- (void)setUrls:(NSArray<NSString *> *)urls {
    _urls = urls;
    
    [self reloadData];
}

- (void)setImages:(NSArray<UIImage *> *)images {
    _images = images;
    
    [self reloadData];
}

- (CGSize)calcViewSize {
    self.backgroundColor = [UIColor brownColor];
    CGFloat swidth = [UIScreen mainScreen].bounds.size.width;
    
    // 间距
    CGFloat margin = 5;
    
    // 设置itemSize大小
    CGSize itemSize = CGSizeMake((swidth - margin * 2) / 3, (swidth - margin * 2) / 3);
    self.flowLayout.itemSize = itemSize;
    
    // 流水布局的间距，图片数量小于0时，没有间距
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 0;
    
    NSUInteger count = 0;
    // 获取图片数量
    if (self.images.count > 0) {
        count = self.images.count;
    }
    if (self.urls.count > 0) {
        count = self.urls.count;
    }
    
    if (count == 0) {
        return CGSizeZero;
    }
    if (count == 1) {
        CGSize size = CGSizeMake(swidth, 160);
        
        UIImage *image = nil;
        if (self.images.count > 0) {
            image = self.images.firstObject;
        }
        if (self.urls.count > 0) {
            // 使用SDWebImage从磁盘中找到这张图片, key: 是图片的url地址
//            image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:self.urls.firstObject];
            if (!image) {
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.urls.firstObject]];
                image = [UIImage imageWithData:data];
            }
        }
        if (image) {
            size = image.size;
        }
        
        if (size.width < 40) {
            size.width = 40;
        }
        if (size.height < 40) {
            size.height = 40;
        }
        self.flowLayout.itemSize = size;
        
        return size;
    }
    // 当图片的数量大于1时 间距
    self.flowLayout.minimumInteritemSpacing = margin;
    self.flowLayout.minimumLineSpacing = margin;
    
    if (count == 4) {
        CGFloat width = 2 * itemSize.width + margin + 1;
        return CGSizeMake(width, width);
    }
    // 当count = 2，3，5，6，7，8，9
    // 列数
    int column = 3;
    // 行数：公式: 行数 = (count + column - 1) / column   注意:count, column必须是Int类型
    NSInteger row = (count + column - 1) / column;
    // 宽度：列数 * itemSize.width + (列数 - 1) * 间距
    CGFloat width = (CGFloat)column * itemSize.width + ((CGFloat)column - 1) * margin;
    // 高度: 行数 * itemSize.width + (行数 - 1) * 间距
    CGFloat height = (CGFloat)row * itemSize.width + ((CGFloat)row - 1) * margin;
    
    return CGSizeMake(width, height);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.urls.count > 0) {
        return self.urls.count;
    }else {
        return self.images.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    if (self.urls.count > 0) {
        cell.imageURL = self.urls[indexPath.item];
    }else {
        cell.image = self.images[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    PictureViewCell *cell = (PictureViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.didSelectItemAtIndexPathBlock) {
        self.didSelectItemAtIndexPathBlock(indexPath, cell.bkgImageView);
    }
}

- (UIView *)viewWithIndexPaeh:(NSIndexPath *)indexPath {
    PictureViewCell *cell = (PictureViewCell *)[self cellForItemAtIndexPath:indexPath];
    return cell.bkgImageView;
}

#pragma mark - lazy load

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _flowLayout;
}

@end
