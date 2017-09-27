//
//  PageControllerViewController.m
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/26.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "PageControllerViewController.h"

@interface PageControllerViewController ()<JHPageControllerDelegate, JHPageControllerDataSource>
@property (nonatomic, strong) NSMutableArray *childControllers;
@property (nonatomic, strong) NSMutableArray *menus;
@property (nonatomic, strong) JHPageController *pageController;
@end

@implementation PageControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JHPageController";
    [self setupData];
    [self setupView];
}

- (void)setupData {
    self.menus = [NSMutableArray array];
    for (int i = 0; i < 1000; i ++) {
        [self.menus addObject:[NSString stringWithFormat:@"标题%i",i + 1]];
    }
    self.childControllers = [NSMutableArray array];
    for (int i = 0; i < 1000; i ++) {
        UIViewController *childVc = [[UIViewController alloc] init];
        childVc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:arc4random_uniform(256)/255.0];
        [self.childControllers addObject:childVc];
    }
}

- (void)setupView {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"切换下标" style:UIBarButtonItemStylePlain target:self action:@selector(switchIndex)];
    self.navigationItem.rightBarButtonItem = item;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pageController.view];
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.leading.bottom.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - getter

- (JHPageController *)pageController {
    if (!_pageController) {
        _pageController = [[JHPageController alloc] initWithMenuLocationStyle:self.menuLocationStyle navBarController:self];
        _pageController.menuItemSize = self.menuLocationStyle == JHPageMenuLocationStyleNavBar ? CGSizeMake(80, 30) : CGSizeMake(80, 50);
        _pageController.delegate = self;
        _pageController.dataSource = self;
        if (self.menuLocationStyle == JHPageMenuLocationStyleNavBar) {
            _pageController.decorateStyle = JHPageDecorateStyleFlood;
            // 设置菜单视图本身的样式
            _pageController.menuBackgroundColor = [UIColor whiteColor];
            _pageController.menuSize = CGSizeMake(160, 30);
            _pageController.menuCornerRadius = 15.0;
            _pageController.menuBorderWidth = 1.0;
            _pageController.menuBorderColor = [UIColor redColor];
        } else {
            _pageController.decorateStyle = JHPageDecorateStyleLine;
            _pageController.decorateSize = (self.menuLocationStyle == JHPageMenuLocationStyleTop || self.menuLocationStyle == JHPageMenuLocationStyleBottom || self.menuLocationStyle == JHPageMenuLocationStyleNavBar ) ? CGSizeMake(40, 2) : CGSizeMake(2, 40);
            _pageController.selectIndex = 5;
        }
    }
    return _pageController;
}

#pragma mark - JHPageControllerDataSource

- (NSInteger)numbersOfViewControllerInPageController:(JHPageController *)pageController {
    return self.menuLocationStyle == JHPageMenuLocationStyleNavBar ? 2 : self.childControllers.count;
}

- (NSInteger)indexOfViewController:(UIViewController *)viewController {
    return [self.childControllers indexOfObject:viewController];
}

- (UIViewController *)pageController:(JHPageController *)pageController viewContrlllerAtIndex:(NSInteger)index {
    return [self.childControllers objectAtIndex:index];
}

- (JHPageMenuItem *)pageController:(JHPageController *)pageController menuView:(JHPageMenuView *)menuView menuItemAtIndex:(NSInteger)index {
    JHPageMenuItem *item = [JHPageMenuItem menuView:menuView itemForIndex:index];
    item.titleLabel.text = self.menus[index];
    __weak typeof(item)weakItem = item;
    __weak typeof(self)weakSelf = self;
    // 样式
    item.menuItemNormalStyleBlock = ^{
        if (weakSelf.menuLocationStyle == JHPageMenuLocationStyleNavBar) {
            weakItem.titleLabel.textColor = [UIColor redColor];
        } else {
            weakItem.titleLabel.textColor = [UIColor grayColor];
        }
    };
    item.menuItemSelectedStyleBlock = ^{
        if (weakSelf.menuLocationStyle == JHPageMenuLocationStyleNavBar) {
            weakItem.titleLabel.textColor = [UIColor whiteColor];
        } else {
            weakItem.titleLabel.textColor = [UIColor redColor];
        }
    };
    return item;
}

#pragma mark - JHPageControllerDelegate

- (void)pageController:(JHPageController *)pageController willEnterViewControllerAtIndex:(NSInteger)index {
    NSLog(@"将要进入第 %ld 个控制器",index + 1);
}

- (void)pageController:(JHPageController *)pageController didEnterViewControllerAtIndex:(NSInteger)index {
    NSLog(@"已经进入第 %ld 个控制器",index + 1);
}

#pragma mark - action

- (void)switchIndex {
    self.pageController.selectIndex = 1;
}

@end
