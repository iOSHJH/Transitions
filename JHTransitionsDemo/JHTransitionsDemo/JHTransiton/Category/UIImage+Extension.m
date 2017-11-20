//
//  UIImage+Extension.m
//  win
//
//  Created by 黄俊煌 on 2017/10/25.
//  Copyright © 2017年 hongsui. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

/// 图片缩放到指定大小尺寸 图片不会变模糊
-(UIImage*)scaleToSize:(CGSize)size {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    //UIGraphicsBeginImageContext(size); // 会模糊
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]); // 不会模糊
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

// 根据宽度等比例压缩
+ (CGSize)scaleSizeWithWidth:(CGFloat)width image:(UIImage *)image {
    if (!image) {
        return CGSizeMake(0, 0);
    }
    CGFloat newWidth = width;
    CGFloat newHeight = newWidth * image.size.height / image.size.width;
    return CGSizeMake(newWidth, newHeight);
}

// 根据高度等比例压缩
+ (CGSize)scaleSizeWithHeight:(CGFloat)height image:(UIImage *)image {
    if (!image) {
        return CGSizeMake(0, 0);
    }
    CGFloat newHeight = height;
    CGFloat newWidth = newHeight * image.size.width / image.size.height;
    return CGSizeMake(newWidth, newHeight);
}

@end
