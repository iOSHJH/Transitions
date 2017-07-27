//
//  pictureView.h
//  ehome
//
//  Created by WONG on 16/7/21.
//  Copyright © 2016年 hongsui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureView : UICollectionView

- (instancetype)initwithImages:(NSArray<UIImage *> *)images;

- (instancetype)initwithUrls:(NSArray<NSString *> *)urls;

/** view:转场动画神奇移动 初始视图 */
@property (nonatomic, copy) void (^didSelectItemAtIndexPathBlock)(NSIndexPath *indexPath, UIView *view);
/** 根据indexPath 获取视图*/
- (UIView *)viewWithIndexPaeh:(NSIndexPath *)indexPath;

/**
 *  计算配图的宽高
 */
- (CGSize)calcViewSize;


@end
