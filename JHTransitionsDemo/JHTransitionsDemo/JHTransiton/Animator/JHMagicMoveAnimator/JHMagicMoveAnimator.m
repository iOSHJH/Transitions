//
//  JHMagicMoveAnimator.m
//  JHTransitionsDemo
//
//  Created by 黄俊煌 on 2017/7/26.
//  Copyright © 2017年 yunshi. All rights reserved.
//

#import "JHMagicMoveAnimator.h"
#import "PictureView.h"
#import <objc/runtime.h>

NSString *const kJHMagicMoveAnimatorStartViewVCKey = @"kJHMagicMoveAnimatorStartViewVCKey";
NSString *const kJHMagicMoveAnimatorEndViewVCKey = @"kJHMagicMoveAnimatorEndViewVCKey";

@implementation JHMagicMoveAnimator

- (void)jh_setToAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {    [self setAnimation:transitionContext isTo:YES];
}

- (void)jh_setBackAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self setAnimation:transitionContext isTo:NO];
}

- (void)setAnimation:(id<UIViewControllerContextTransitioning>)transitionContext isTo:(BOOL)isTo {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *realFromVC = [self getRealContainsGroupViewController:fromVC];
    UIViewController *realToVC = [self getRealContainsGroupViewController:toVC];
    
    NSArray<UIView *> *startViewGroup = objc_getAssociatedObject(realFromVC, &kJHMagicMoveAnimatorStartViewVCKey);
    NSArray<UIView *> *endViewGroup = objc_getAssociatedObject(realToVC, &kJHMagicMoveAnimatorEndViewVCKey);
    if (!startViewGroup.count || !endViewGroup.count || startViewGroup.count != endViewGroup.count) {
        NSLog(@"神奇移动的视图为空，或者移动前后视图不相等");
        [transitionContext completeTransition:NO];
        return;
    }
    
    UIView *containerView = [transitionContext containerView];
    toVC.view.alpha = 0.0f;
    [containerView addSubview:toVC.view];
    
    NSArray *toRects = [self getFrameValueFromViewGroup:endViewGroup inContainerView:realToVC.view];
    NSArray<UIView *> *tempViewGroup = [self makeTempViewGroupWithViewGroup:startViewGroup inContainerView:containerView];
    
    [UIView animateWithDuration:self.backDuration animations:^{
        toVC.view.alpha = 1.0f;
        [tempViewGroup enumerateObjectsUsingBlock:^(UIView *tempSubView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (isTo) { // to View
                tempSubView.frame = CGRectMake(0, (ScreenHeight - ScreenWidth)*0.5, ScreenWidth, ScreenWidth);
            }else { // back View
                CGRect toRect = [toRects[idx] CGRectValue];
                tempSubView.frame = toRect;
            }
        }];
    } completion:^(BOOL finished) {
        [tempViewGroup makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [transitionContext completeTransition:YES];
    }];
}

/**
 *  判断当前控制器的类型，从而找到从出存有移动视图组的控制器
 */
- (UIViewController *)getRealContainsGroupViewController:(UIViewController *)controller{
    UIViewController *realVC = controller;
    if ([controller isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)realVC;
        if ([tabBarVC.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navVC = (UINavigationController *)tabBarVC.selectedViewController;
            realVC = navVC.topViewController;
        }else{
            realVC = tabBarVC.selectedViewController;
        }
    }
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)controller;
        realVC = navVC.topViewController;
    }
    return realVC;
}

- (NSArray *)getFrameValueFromViewGroup:(NSArray<UIView *> *)group inContainerView:(UIView *)containerView{
    NSMutableArray *temp = @[].mutableCopy;
    [group enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = [view convertRect:view.bounds toView:containerView];
        [temp addObject:[NSValue valueWithCGRect:rect]];
    }];
    return temp.copy;
}

- (NSArray<UIView *> *)makeTempViewGroupWithViewGroup:(NSArray<UIView *> *)group inContainerView:(UIView *)containerView{
    NSMutableArray *temp = @[].mutableCopy;
    [group enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *tempView = [self snapshotView:view];
        tempView.frame = [view convertRect:view.bounds toView:containerView];
        [containerView addSubview:tempView];
        [temp addObject:tempView];
    }];
    return temp.copy;
}

- (UIView *)snapshotView:(UIView *)view{
    CALayer *layer = view.layer;
    UIView *snapView = [UIView new];
    snapView.frame = view.frame;
    
    UIImage *img = nil;
    if ([view isKindOfClass:[UIImageView class]]) {//取imageView中的image
        img = [(UIImageView *)view image];
    }else if ([view isKindOfClass:[UIButton class]]){//取button中的image
        img = [(UIButton *)view currentImage];
    }
    if (!img && [view isKindOfClass:[UIView class]]) {//没取到尝试取content
        img = [UIImage imageWithCGImage:(__bridge CGImageRef)view.layer.contents];
    }
    //若都没有取到，则截图
    if (!img) {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.opaque, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [layer renderInContext:context];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    snapView.layer.contents = (__bridge id)img.CGImage;
    return snapView;
}





@end
