//
//  UIViewController+JHTransition.h
//  JHTransitionsDemo
//
//  Created by 黄俊煌 on 2017/7/26.
//  Copyright © 2017年 yunshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTransitionAnimator.h"

@interface UIViewController (JHTransition)

- (void)jh_presentViewController:(UIViewController *)viewController withAnimator:(JHTransitionAnimator *)animator;

#pragma mark - 神奇移动相关 JHMagicMoveAnimator

/**
 *  注册神奇移动起始视图
 *
 *  @param group 神奇移动起始视图数组
 */
- (void)addMagicMoveStartViewGroup:(NSArray<UIView *> *)group;

/**
 *  注册神奇移动终止视图
 *
 *  @param group 神奇移动终止视图数组，注意起始视图数组和终止视图数组的视图需要一一对应才能有正确的效果
 */
- (void)addMagicMoveEndViewGroup:(NSArray<UIView *> *)group;

@end
