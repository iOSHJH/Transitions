//
//  ViewController.m
//  JHTransitionsDemo
//
//  Created by 黄俊煌 on 2017/7/25.
//  Copyright © 2017年 yunshi. All rights reserved.
//

#import "ViewController.h"
#import "ToVC.h"
#import "JHMagicMoveAnimator.h"
#import "UIViewController+JHTransition.h"
#import "MagicMoveAnimatorFromVC.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];

}

- (IBAction)buttonAction:(id)sender {
    
    JHMagicMoveAnimator *move = [JHMagicMoveAnimator new];
    move.toDuration = 2.0f;
    move.backDuration = 2.0f;
    
    ToVC *vc = [ToVC new];
    [self jh_presentViewController:vc withAnimator:move];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"MagicMoveAnimator";
    }else {
        cell.textLabel.text = @"15";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MagicMoveAnimatorFromVC *fromVC = [MagicMoveAnimatorFromVC new];
    [self.navigationController pushViewController:fromVC animated:YES];
}

#pragma mark - get

- (UITableView *)tableView {
    if (_tableView) return _tableView;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, width, height)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    return _tableView;
}

@end
