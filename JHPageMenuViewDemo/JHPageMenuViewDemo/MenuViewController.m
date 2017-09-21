//
//  MenuViewController.m
//  JHMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/20.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "MenuViewController.h"
#import "JHPageMenuView.h"
#import "CustomMenuCell.h"
#import "CustomDecorateCell.h"
#import <Masonry.h>

@interface MenuViewController ()<JHPageMenuViewDelegate, JHPageMenuViewDataSource>
@property (nonatomic, strong) JHPageMenuView *menuView;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupView];
}

- (void)setupData {

}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - getter

- (JHPageMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[JHPageMenuView alloc] init];
        _menuView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [CustomMenuCell registerMenuItemNibCollectionView:_menuView.menuCollectionView];
        [CustomDecorateCell registerMenuItemNibCollectionView:_menuView.decorateCollectionView];
        _menuView.delegate = self;
        _menuView.dataSource = self;
        [_menuView selectItemAtIndex:5];
    }
    return _menuView;
}

#pragma mark - JHMenuViewDataSource

- (NSInteger)numbersOfItemsInMenuView:(JHPageMenuView *)menuView {
    return 10;
}

- (JHPageMenuItem *)menuView:(JHPageMenuView *)menuView menuCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomMenuCell *cell = [CustomMenuCell collectionView:menuView.menuCollectionView itemForIndexPath:indexPath];
    return cell;
}
 
- (JHPageMenuItem *)menuView:(JHPageMenuView *)menuView decorateCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomDecorateCell *cell = [CustomDecorateCell collectionView:menuView.decorateCollectionView itemForIndexPath:indexPath];
    return cell;
}

#pragma mark - JHMenuViewDelegate

- (CGSize)menuView:(JHPageMenuView *)menuView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
