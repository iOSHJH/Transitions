//
//  PictureViewCell.m
//  ehome
//
//  Created by WONG on 16/7/21.
//  Copyright © 2016年 hongsui. All rights reserved.
//

#import "PictureViewCell.h"
#import "UIImage+Extension.h"

@interface PictureViewCell ()

@end

@implementation PictureViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI {
    [self.contentView addSubview:self.bkgImageView];
    
    self.bkgImageView.frame = self.contentView.bounds;
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    
//    self.bkgImageView.image = [UIImage imageNamed:@"aa"];
//    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_imageURL] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        if (image) {
//            CGSize size;
//            if (image.size.width > image.size.height) { // 宽大于长，根据高度等比例压缩
//                size = [self scaleSizeWithHeight:self.frame.size.height image:image];
//            }else { // 长大于宽，根据宽度等比例压缩
//                size = [self scaleSizeWithWidth:self.frame.size.width image:image];
//            }
//
//            UIImage *img = [self scaleWithImage:image Size:size];
//            self.bkgImageView.image = img;
//        }
//    }];
    [self.bkgImageView sd_setImageWithURL:[NSURL URLWithString:_imageURL] placeholderImage:[UIImage imageNamed:@"aa"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            CGSize size;
            if (image.size.width > image.size.height) { // 宽大于长，根据高度等比例压缩
                size = [UIImage scaleSizeWithHeight:self.frame.size.height image:image];
            }else { // 长大于宽，根据宽度等比例压缩
                size = [UIImage scaleSizeWithWidth:self.frame.size.width image:image];
            }
            
            UIImage *img = [image scaleToSize:size];
            self.bkgImageView.image = img;
        }
    }];
}

- (void)setImage:(UIImage *)image {
    _image = image;

    CGSize size;
    if (image.size.width > image.size.height) { // 宽大于长，根据高度等比例压缩
        size = [UIImage scaleSizeWithHeight:self.frame.size.height image:image];
    }else { // 长大于宽，根据宽度等比例压缩
        size = [UIImage scaleSizeWithWidth:self.frame.size.width image:image];
    }
    
    UIImage *img = [image scaleToSize:size];
    self.bkgImageView.image = img;
}

- (UIImageView *)bkgImageView {
    if (!_bkgImageView) {
        _bkgImageView = [[UIImageView alloc] init];
//        _bkgImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bkgImageView.contentMode = UIViewContentModeCenter;
        _bkgImageView.layer.masksToBounds = YES;
        _bkgImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bkgImageView;
}

@end




