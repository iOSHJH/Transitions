//
//  UIViewController+JHTransition.m
//  JHTransitionsDemo
//
//  Created by 黄俊煌 on 2017/7/26.
//  Copyright © 2017年 yunshi. All rights reserved.
//

#import "UIViewController+JHTransition.h"
#import "JHMagicMoveAnimator.h"
#import <objc/runtime.h>

@implementation UIViewController (JHTransition)

- (void)jh_presentViewController:(UIViewController *)viewController withAnimator:(JHTransitionAnimator *)animator {
    if (!viewController) return;
    if (!animator) animator = [JHTransitionAnimator new];
    viewController.transitioningDelegate = animator;
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - 神奇移动相关 JHMagicMoveAnimator

- (void)addMagicMoveStartViewGroup:(NSArray<UIView *> *)group {
    if (!group.count) return;
    objc_setAssociatedObject(self, &kJHMagicMoveAnimatorStartViewVCKey, group, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addMagicMoveEndViewGroup:(NSArray<UIView *> *)group {
    if (!group.count) return;
    objc_setAssociatedObject(self, &kJHMagicMoveAnimatorEndViewVCKey, group, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
