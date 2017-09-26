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
        _pageController = [[JHPageController alloc] initWithMenuLocationStyle:self.menuLocationStyle];
        _pageController.decorateStyle = JHPageDecorateStyleLine;
        _pageController.menuSize = CGSizeMake(80, 50);
        _pageController.decorateSize = (self.menuLocationStyle == JHPageMenuLocationStyleTop || self.menuLocationStyle == JHPageMenuLocationStyleBottom) ? CGSizeMake(40, 2) : CGSizeMake(2, 40);
        _pageController.delegate = self;
        _pageController.dataSource = self;
        _pageController.selectIndex = 5;
    }
    return _pageController;
}

#pragma mark - JHPageControllerDataSource

- (NSInteger)numbersOfViewControllerInPageController:(JHPageController *)pageController {
    return self.childControllers.count;
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
    // 样式
    item.menuItemNormalStyleBlock = ^{
        weakItem.titleLabel.textColor = [UIColor grayColor];
    };
    item.menuItemSelectedStyleBlock = ^{
        weakItem.titleLabel.textColor = [UIColor redColor];
    };
    return item;
}

#pragma mark - JHPageControllerDelegate

- (void)pageController:(JHPageController *)pageController willEnterViewControllerAtIndex:(NSInteger)index {
    NSLog(@"将要进入第 %ld 个控制器",index);
}

- (void)pageController:(JHPageController *)pageController didEnterViewControllerAtIndex:(NSInteger)index {
    NSLog(@"已经进入第 %ld 个控制器",index);
}

#pragma mark - action

- (void)switchIndex {
    self.pageController.selectIndex = 2;
}

@end
