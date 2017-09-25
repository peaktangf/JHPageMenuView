//
//  NavTabMenuViewController.m
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/25.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "NavTabMenuViewController.h"
#import "JHPageMenuView.h"
#import <Masonry.h>

@interface NavTabMenuViewController ()<JHPageMenuViewDelegate, JHPageMenuViewDataSource>
@property (nonatomic, strong) JHPageMenuView *menuView;
@property (nonatomic, copy) NSArray *datas;
@end

@implementation NavTabMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupView];
}

- (void)setupData {
    self.datas = @[@"标题1",@"标题2"];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.menuView setFrame:CGRectMake(0, 0, 160, 30)];
    self.navigationItem.titleView = self.menuView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - getter

- (JHPageMenuView *)menuView {
    if (!_menuView) {
//        _menuView = [[JHPageMenuView alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
        _menuView = [[JHPageMenuView alloc] init];
        _menuView.backgroundColor = [UIColor whiteColor];
        _menuView.layer.cornerRadius = 15.0;
        _menuView.layer.borderWidth = 1.0;
        _menuView.layer.borderColor = [UIColor redColor].CGColor;
        _menuView.menuSize = CGSizeMake(80, 30);
        _menuView.decorateStyle = JHPageDecorateStyleFlood;
        _menuView.decorateColor = [UIColor redColor];
        _menuView.delegate = self;
        _menuView.dataSource = self;
    }
    return _menuView;
}

#pragma mark - JHMenuViewDataSource

- (NSInteger)numbersOfItemsInMenuView:(JHPageMenuView *)menuView {
    return self.datas.count;
}

- (JHPageMenuItem *)menuView:(JHPageMenuView *)menuView menuCellForItemAtIndex:(NSInteger)index {
    JHPageMenuItem *item = [JHPageMenuItem menuView:menuView itemForIndex:index];
    item.titleLabel.text = self.datas[index];
    __weak typeof(item)weakItem = item;
    item.menuItemNormalStyleBlock = ^{
        weakItem.titleLabel.textColor = [UIColor redColor];
    };
    item.menuItemSelectedStyleBlock = ^{
       weakItem.titleLabel.textColor = [UIColor whiteColor];
    };
    return item;    
}

#pragma mark - JHMenuViewDelegate

- (void)menuView:(JHPageMenuView *)menuView didSelectIndex:(NSInteger)index {
    NSLog(@"当前选中的菜单 = %ld",index);
}

@end

