//
//  PhotoBrowserVC.h
//  ehome
//
//  Created by WONG on 16/8/3.
//  Copyright © 2016年 hongsui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowserVC : UIViewController

@property (nonatomic,strong) UICollectionView *collectionView;
/***  图片URL 数组，优先使用*/
@property (nonatomic,strong) NSArray<NSString *> *urls;
/***  图片 数组*/
@property (nonatomic,strong) NSArray<UIImage *> *images;
/***  选中的indexPath*/
@property (nonatomic,strong) NSIndexPath *selectIndexPath;
/***  选中的imageView*/
@property (nonatomic, strong) UIImageView * selectImageView;

/** 获取转场动画神奇移动 终止视图*/
@property (nonatomic, copy) void (^addMagicMoveEndViewGroupBlock)(NSIndexPath *indexPath);


+ (instancetype)PhotoBrowserWithImages:(NSArray<UIImage *> *)images selectIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)PhotoBrowserWithUrls:(NSArray<NSString *> *)urls selectIndexPath:(NSIndexPath *)indexPath;



@end
