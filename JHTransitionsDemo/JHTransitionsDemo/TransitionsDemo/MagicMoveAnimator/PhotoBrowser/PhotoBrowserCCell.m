//
//  PhotoBrowserCCell.m
//  ehome
//
//  Created by WONG on 16/8/3.
//  Copyright © 2016年 hongsui. All rights reserved.
//

#import "PhotoBrowserCCell.h"

@interface PhotoBrowserCCell ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;

@end

@implementation PhotoBrowserCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI {
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    //    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    //
    //    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[sv]-0-|" options:0 metrics:nil views:@{@"sv": self.scrollView}]];
    //    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[sv]-0-|" options:0 metrics:nil views:@{@"sv": self.scrollView}]];
}


-(void)setImage:(UIImage *)image {
    _image = image;
    
    self.imageView.image = image;
    self.scrollView.contentOffset = CGPointZero;
    self.scrollView.contentSize = CGSizeZero;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.imageView.transform = CGAffineTransformIdentity;
    
    if (_image) {
        [self layoutImageView:_image];
    }
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_urlStr] placeholderImage:[UIImage imageNamed:@"default_home_rss1"]];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_urlStr]  placeholderImage:[UIImage imageNamed:@"default_home_banner"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = (CGFloat)receivedSize / (CGFloat)expectedSize;
        [SVProgressHUD showProgress:progress];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [SVProgressHUD dismiss];
        self.image = image;
    }];
}

/*
 将图片等比缩放到宽度等于屏幕的宽度
 长图: 高度大于屏幕的高度
 短图: 高度小于屏幕的高度
 */
- (void)layoutImageView:(UIImage *)image {
    if (!image) {
        return;
    }
    
    // 将图片等比缩放到宽度等于屏幕的宽度
    CGSize size = [self displaySize:image];
    
    // 判断是长图还是短图
    // 长图:从左上角开始显示.可以滚动
    // 短图:高度方向居中显示
    if (size.height < ScreenHeight) {
        // 短图：高度方向居中显示
        CGFloat offsetY = (ScreenHeight - size.height) * 0.5;
        self.imageView.frame = CGRectMake(0, 0, size.width, size.height);
        self.scrollView.contentInset = UIEdgeInsetsMake(offsetY, 0, offsetY, 0);
    }else if(size.height >= ScreenHeight){
        self.imageView.frame = CGRectMake(0, 0, size.width, size.height);
        self.scrollView.contentSize = size;
    }else {
        NSLog(@"nan 不是个数字");
        self.imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenWidth);
    }
}

// 将图片等比缩放到宽度等于屏幕的宽度
- (CGSize)displaySize:(UIImage *)image {
    // 新的高度 / 新的宽度 = 旧的高度 / 旧的宽度
    // 新的高度 = 新的宽度(屏幕的宽度) * 旧的高度 / 旧的宽度
    CGFloat newWidth = ScreenWidth;
    CGFloat newHeight = newWidth * image.size.height / image.size.width;
    
    return CGSizeMake(newWidth, newHeight);
}


#pragma mark - UIScrollViewDelegate

// 告诉scrollView要缩放哪个view(缩放其实是修改这个view的transform)
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

/// 缩放结束的时候调用
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    // 移动到中间
    CGFloat offestX = (ScreenWidth - self.imageView.frame.size.width) * 0.5;
    CGFloat offestY = (ScreenHeight - self.imageView.frame.size.height) * 0.5;
    
    if (offestX < 0) {
        offestX = 0;
    }
    if (offestY < 0) {
        offestY = 0;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(offestY, offestX, 0, 0);
    }];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (self.tapBlock) {
        self.tapBlock();
    }
}


#pragma mark - lazy load

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 2;
        _scrollView.minimumZoomScale = 0.5;
        
        // 创建单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tap.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:tap];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

@end
