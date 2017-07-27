//
//  JHTransitionAnimator.m
//  JHTransitionsDemo
//
//  Created by 黄俊煌 on 2017/7/25.
//  Copyright © 2017年 yunshi. All rights reserved.
//

#pragma mark - ******************JHTransitionObject**********************

#import "JHTransitionAnimator.h"

typedef void(^JHTransitionAnimationBlock)(id<UIViewControllerContextTransitioning> transitionContext);

@interface JHTransitionObject : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initObjectWithDuration:(NSTimeInterval)duration animationBlock:(JHTransitionAnimationBlock) config;

@end

@implementation JHTransitionObject{
    NSTimeInterval _duration;
    JHTransitionAnimationBlock _config;
}

- (instancetype)initObjectWithDuration:(NSTimeInterval)duration animationBlock:(JHTransitionAnimationBlock)config {
    self = [super init];
    if (self) {
        _duration = duration;
        _config = config;
    }
    return self;
}

#pragma mark - <UIViewControllerAnimatedTransitioning>

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (_config) {
        _config(transitionContext);
    }
}

@end


#pragma mark - ******************JHTransitionAnimator*******************

@interface JHTransitionAnimator ()

@property (nonatomic, strong) JHTransitionObject *toTransition;
@property (nonatomic, strong) JHTransitionObject *backTranstion;

@end

@implementation JHTransitionAnimator

- (instancetype)init
{
    self = [super init];
    if (self) {
        _toDuration = _backDuration = 0.5f;
    }
    return self;
}

#pragma mark - 转场动画实现

- (void)jh_setToAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //交给子类实现
    NSLog(@"jh_setToAnimation");
}

- (void)jh_setBackAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //交给子类实现
    NSLog(@"jh_setBackAnimation");
}

// 前两个方法是针对动画切换的，我们需要分别在呈现VC和解散VC时，给出一个实现了UIViewControllerAnimatedTransitioning接口的对象（其中包含切换时长和如何切换
// 后面两个代理方法(UIViewControllerInteractiveTransitioning)涉及交互式切换，通俗的说就是新添加手势交互切换
#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    // 返回控制 modal时的动画对象
    return self.toTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    // 返回 控制 dismiss时的动画 对象
    return self.backTranstion;
}

//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
//    return self.backInteractive.interation ? self.backInteractive : nil;
//}
//
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
//    return self.toInteractive.interation ? self.toInteractive : nil;
//}


#pragma mark - get

- (JHTransitionObject *)toTransition {
    if (_toTransition) return _toTransition;
    
    _toTransition = [[JHTransitionObject alloc] initObjectWithDuration:_toDuration animationBlock:^(id<UIViewControllerContextTransitioning> transitionContext) {
        [self jh_setToAnimation:transitionContext];
    }];
    
    return _toTransition;
}

- (JHTransitionObject *)backTranstion {
    if (_backTranstion) return _backTranstion;
    
    _backTranstion = [[JHTransitionObject alloc] initObjectWithDuration:_backDuration animationBlock:^(id<UIViewControllerContextTransitioning> transitionContext) {
        [self jh_setBackAnimation:transitionContext];
    }];
    
    return _backTranstion;
}


@end
