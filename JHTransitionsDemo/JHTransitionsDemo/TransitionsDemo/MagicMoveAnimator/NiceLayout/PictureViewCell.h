//
//  PictureViewCell.h
//  ehome
//
//  Created by WONG on 16/7/21.
//  Copyright © 2016年 hongsui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureViewCell : UICollectionViewCell

/**
 *  优先使用，图片URL
 */
@property (nonatomic,strong) NSString *imageURL;
/***  图片*/
@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) UIImageView *bkgImageView;


@end
