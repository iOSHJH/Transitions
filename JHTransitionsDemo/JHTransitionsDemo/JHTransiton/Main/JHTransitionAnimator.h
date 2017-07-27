//
//  JHTransitionAnimator.h
//  JHTransitionsDemo
//
//  Created by 黄俊煌 on 2017/7/25.
//  Copyright © 2017年 yunshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JHTransitionAnimator : NSObject<UIViewControllerTransitioningDelegate>

//to转场时间 默认0.5
@property (nonatomic, assign) NSTimeInterval toDuration;
//back转场时间 默认0.5
@property (nonatomic, assign) NSTimeInterval backDuration;

/// 配置To过程动画(push, present),自定义转场动画应该复写该方法
- (void)jh_setToAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;
/// 配置back过程动画（pop, dismiss）,自定义转场动画应该复写该方法
- (void)jh_setBackAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
