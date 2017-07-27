//
//  PhotoBrowserCCell.h
//  ehome
//
//  Created by WONG on 16/8/3.
//  Copyright © 2016年 hongsui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowserCCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;
/***  地址*/
@property (nonatomic,copy) NSString *urlStr;
/***  图片*/
@property (nonatomic,strong) UIImage *image;
/***  scrollView的单击事件*/
@property (nonatomic,copy) void (^tapBlock)();

@end
