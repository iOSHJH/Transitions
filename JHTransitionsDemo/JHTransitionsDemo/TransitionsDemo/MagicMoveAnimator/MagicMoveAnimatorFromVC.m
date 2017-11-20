//
//  MagicMoveAnimatorFromVC.m
//  JHTransitionsDemo
//
//  Created by 黄俊煌 on 2017/7/26.
//  Copyright © 2017年 yunshi. All rights reserved.
//

#import "MagicMoveAnimatorFromVC.h"
#import "UIViewController+JHTransition.h"
#import "JHMagicMoveAnimator.h"
#import "PictureView.h"
#import "PhotoBrowserVC.h"

@implementation MagicMoveAnimatorFromVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    NSArray *images = @[[UIImage imageNamed:@"img1"], [UIImage imageNamed:@"aa"], [UIImage imageNamed:@"aa"], [UIImage imageNamed:@"aa"], [UIImage imageNamed:@"aa"], [UIImage imageNamed:@"aa"],[UIImage imageNamed:@"aa"]];
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i <= 9; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"img%d",i]]];
    }
    
    PictureView *pictureView = [[PictureView alloc] initwithImages:images];
    CGSize size = [pictureView calcViewSize];
    pictureView.frame = CGRectMake(0, 100, size.width, size.height);
    pictureView.center = self.view.center;
    
    WeakSelf;
    pictureView.didSelectItemAtIndexPathBlock = ^(NSIndexPath *indexPath, UIView *view) {
        JHMagicMoveAnimator *move = [JHMagicMoveAnimator new];
        move.toDuration = 1;
        move.backDuration = 1;

        PhotoBrowserVC *vc = [PhotoBrowserVC PhotoBrowserWithImages:images selectIndexPath:indexPath];
        
        [weakSelf addMagicMoveStartViewGroup:@[view]];
        [vc addMagicMoveEndViewGroup:@[view]];
        
        vc.addMagicMoveEndViewGroupBlock = ^(NSIndexPath *indexPath) {
            UIView *endView = [pictureView viewWithIndexPaeh:indexPath];
            [weakSelf addMagicMoveEndViewGroup:@[endView]];
        };
        [weakSelf jh_presentViewController:vc withAnimator:move];
    };
    
    [self.view addSubview:pictureView];
}

@end
