//
//  MenuViewController.m
//  JHMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/20.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "MenuViewController.h"
#import "CustomMenuItem.h"
#import "CustomDecorateItem.h"
#import <Masonry.h>


@interface MenuViewController ()<JHPageMenuViewDelegate, JHPageMenuViewDataSource>
@property (nonatomic, strong) JHPageMenuView *menuView;
@property (nonatomic, assign) NSInteger dataCounts;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupView];
}

- (void)setupData {
    self.dataCounts = 5;
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = item;
    [self.view addSubview:self.menuView];
    if (self.menuScrollDirection == JHPageMenuScrollDirectionHorizontal) {
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.view);
            make.height.mas_equalTo(self.isCustomMenu ? 100 : 50);
        }];
    } else {
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.equalTo(self.view);
            make.width.mas_equalTo(self.isCustomMenu ? 100 : 80);
        }];
    }
}

#pragma mark - getter

- (JHPageMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[JHPageMenuView alloc] init];
        _menuView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _menuView.delegate = self;
        _menuView.dataSource = self;
        _menuView.scrollDirection = self.menuScrollDirection;
        _menuView.menuSize = self.isCustomMenu ? CGSizeMake(100, 100) : CGSizeMake(80, 50);
        switch (self.decorateStyle) {
            case JHPageDecorateStyleDefault:
                break;
            case JHPageDecorateStyleLine:
                _menuView.decorateStyle = JHPageDecorateStyleLine;
                if (self.isCustomMenu) {
                    _menuView.decorateSize = self.menuScrollDirection == JHPageMenuScrollDirectionHorizontal ? CGSizeMake(90, 2) : CGSizeMake(2, 90);
                } else {
                    _menuView.decorateSize = self.menuScrollDirection == JHPageMenuScrollDirectionHorizontal ? CGSizeMake(40, 2) : CGSizeMake(2, 40);
                }
                
                break;
            case JHPageDecorateStyleFlood:
                _menuView.decorateStyle = JHPageDecorateStyleFlood;
                _menuView.decorateSize = CGSizeMake(70, 30);
                break;
            case JHPageDecorateStyleFloodHollow:
                _menuView.decorateStyle = JHPageDecorateStyleFloodHollow;
                _menuView.decorateSize = CGSizeMake(70, 30);
                break;
        }
    }
    return _menuView;
}

#pragma mark - JHMenuViewDataSource

- (NSInteger)numbersOfItemsInMenuView:(JHPageMenuView *)menuView {
    return self.dataCounts;
}

- (JHPageMenuItem *)menuView:(JHPageMenuView *)menuView menuCellForItemAtIndex:(NSInteger)index {
    if (self.isCustomMenu) {
        CustomMenuItem *item = [CustomMenuItem menuView:menuView itemForIndex:index];
        return item;
    } else {
        JHPageMenuItem *item = [JHPageMenuItem menuView:menuView itemForIndex:index];
        __weak typeof(self)weakSelf = self;
        __weak typeof(item)weakItem = item;
        item.menuItemNormalStyleBlock = ^{
            weakItem.titleLabel.text = @"未选中";
            weakItem.titleLabel.textColor = weakSelf.decorateStyle == JHPageDecorateStyleFlood ? [UIColor redColor] : [UIColor grayColor];
        };
        item.menuItemSelectedStyleBlock = ^{
            weakItem.titleLabel.text = @"选中";
            weakItem.titleLabel.textColor = weakSelf.decorateStyle == JHPageDecorateStyleFlood ? [UIColor whiteColor] : [UIColor redColor];
        };
        return item;
    }    
}

- (UIView *)decorateItemInMenuView:(JHPageMenuView *)menuView {
    if (self.isCustomDecorate) {
        CustomDecorateItem *item = [[[NSBundle mainBundle] loadNibNamed:@"CustomDecorateItem" owner:nil options:nil] firstObject];
        if (self.menuScrollDirection == JHPageMenuScrollDirectionHorizontal) {
            item.imgView.image = [UIImage imageNamed:@"triangle_top"];
            [item.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(item);
                make.width.mas_equalTo(15);
                make.height.mas_equalTo(10);
                make.centerX.equalTo(item);
            }];
        } else {
            item.imgView.image = [UIImage imageNamed:@"triangle_left"];
            [item.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(item);
                make.width.mas_equalTo(10);
                make.height.mas_equalTo(15);
                make.centerY.equalTo(item);
            }];
        }
        return item;
    } 
    return nil;
}

#pragma mark - JHMenuViewDelegate

- (void)menuView:(JHPageMenuView *)menuView didSelectIndex:(NSInteger)index {
    NSLog(@"当前选中的菜单 = %ld",index);
}

#pragma mark - action

- (void)refreshData {
    self.dataCounts = 8 + arc4random() % 10;
    [self.menuView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
