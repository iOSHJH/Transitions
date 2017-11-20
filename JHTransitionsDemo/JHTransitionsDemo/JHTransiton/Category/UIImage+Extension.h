//
//  UIImage+Extension.h
//  win
//
//  Created by 黄俊煌 on 2017/10/25.
//  Copyright © 2017年 hongsui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/// 图片缩放到指定大小尺寸 图片不会变模糊
- (UIImage*)scaleToSize:(CGSize)size;

/// 根据宽度等比例压缩
+ (CGSize)scaleSizeWithWidth:(CGFloat)width image:(UIImage *)image;

/// 根据高度等比例压缩
+ (CGSize)scaleSizeWithHeight:(CGFloat)height image:(UIImage *)image;

@end
