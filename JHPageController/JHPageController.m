//
//  JHPageController.m
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/26.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "JHPageController.h"

@interface JHPageController ()<JHPageMenuViewDelegate, JHPageMenuViewDataSource, UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) JHPageMenuView *menuView;
@property (nonatomic, assign) JHPageMenuLocationStyle menuLocationStyle;
@property (nonatomic, weak) UIViewController *navBarController;
@property (nonatomic, assign) NSInteger dataCount;
@property (nonatomic, assign) BOOL isDragPageContrller;// 是否是拖拽pageController完成的页面切换
@end

@implementation JHPageController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - init

- (instancetype)initWithMenuLocationStyle:(JHPageMenuLocationStyle)menulocationStyle navBarController:(UIViewController *)navBarController {
    if (self == [super init]) {
        _menuLocationStyle = menulocationStyle;
        _navBarController = navBarController;
        [self initialization];
    }
    return self;
}

- (void)initialization {
    [self initializationMenuView];
    [self initializationPageViewController];
}

- (void)initializationMenuView {
    if (self.menuLocationStyle == JHPageMenuLocationStyleNavBar) {
        self.navBarController.navigationItem.titleView = self.menuView;
    } else {
        [self.view addSubview:self.menuView];
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            switch (self.menuLocationStyle) {
                case JHPageMenuLocationStyleTop: {
                    make.top.leading.trailing.equalTo(self.view);
                    make.height.mas_equalTo(self.menuView.menuSize.height);
                }
                    break;
                case JHPageMenuLocationStyleBottom: {
                    make.bottom.leading.trailing.equalTo(self.view);
                    make.height.mas_equalTo(self.menuView.menuSize.height);
                }
                    break;
                case JHPageMenuLocationStyleLeft: {
                    make.top.leading.bottom.equalTo(self.view);
                    make.width.mas_equalTo(self.menuView.menuSize.width);
                }
                    break;
                case JHPageMenuLocationStyleRight: {
                    make.top.bottom.trailing.equalTo(self.view);
                    make.width.mas_equalTo(self.menuView.menuSize.width);
                }
                    break;
                case JHPageMenuLocationStyleNavBar:
                    break;
            }
        }];
    }
}

- (void)initializationPageViewController {
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        switch (self.menuLocationStyle) {
            case JHPageMenuLocationStyleTop: {
                make.leading.trailing.bottom.equalTo(self.view);
                make.top.equalTo(self.menuView.mas_bottom);
            }
                break;
            case JHPageMenuLocationStyleBottom: {
                make.leading.trailing.top.equalTo(self.view);
                make.bottom.equalTo(self.menuView.mas_top);
            }
                break;
            case JHPageMenuLocationStyleLeft: {
                make.top.trailing.bottom.equalTo(self.view);
                make.leading.equalTo(self.menuView.mas_trailing);
            }
                break;
            case JHPageMenuLocationStyleRight: {
                make.leading.top.bottom.equalTo(self.view);
                make.trailing.equalTo(self.menuView.mas_leading);
            }
                break;
            case JHPageMenuLocationStyleNavBar: {
                make.top.leading.trailing.bottom.equalTo(self.view);
            }
                break;
        }
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // 菜单视图布局
    if (self.menuLocationStyle != JHPageMenuLocationStyleNavBar) {
        [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
            switch (self.menuLocationStyle) {
                case JHPageMenuLocationStyleTop: {
                    make.height.mas_equalTo(self.menuView.menuSize.height);
                }
                    break;
                case JHPageMenuLocationStyleBottom: {
                    make.height.mas_equalTo(self.menuView.menuSize.height);
                }
                    break;
                case JHPageMenuLocationStyleLeft: {
                    make.width.mas_equalTo(self.menuView.menuSize.width);
                }
                    break;
                case JHPageMenuLocationStyleRight: {
                    make.width.mas_equalTo(self.menuView.menuSize.width);
                }
                    break;
                case JHPageMenuLocationStyleNavBar:
                    break;
            }
        }];
    }
}

#pragma mark - setter

- (void)setSelectIndex:(NSInteger)selectIndex {
    UIPageViewControllerNavigationDirection direction = selectIndex > self.selectIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    _selectIndex = selectIndex;
    if (self.dataCount == 0) { return; }
    NSAssert(self.selectIndex <= (self.dataCount - 1), @"选中的下标超出了范围");
    [self.menuView selectItemAtIndex:selectIndex withAnimation:YES];
    UIViewController *vc = [self.dataSource pageController:self viewContrlllerAtIndex:selectIndex];
    [self.pageViewController setViewControllers:@[vc] direction:direction animated:YES completion:nil];
}

- (void)setMenuBackgroundColor:(UIColor *)menuBackgroundColor {
    _menuBackgroundColor = menuBackgroundColor;
    self.menuView.backgroundColor = menuBackgroundColor;
}

- (void)setMenuItemSize:(CGSize)menuItemSize {
    _menuItemSize = menuItemSize;
    self.menuView.menuSize = menuItemSize;
    if (self.dataCount == 0) { return; }
    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        switch (self.menuLocationStyle) {
            case JHPageMenuLocationStyleTop: {
                make.height.mas_equalTo(self.menuView.menuSize.height);
            }
                break;
            case JHPageMenuLocationStyleBottom: {
                make.height.mas_equalTo(self.menuView.menuSize.height);
            }
                break;
            case JHPageMenuLocationStyleLeft: {
                make.width.mas_equalTo(self.menuView.menuSize.width);
            }
                break;
            case JHPageMenuLocationStyleRight: {
                make.width.mas_equalTo(self.menuView.menuSize.width);
            }
                break;
            case JHPageMenuLocationStyleNavBar: {
                
            }
                break;
        }
    }];
}

- (void)setDecorateSize:(CGSize)decorateSize {
    _decorateSize = decorateSize;
    self.menuView.decorateSize = decorateSize;
}

- (void)setDecorateStyle:(JHPageDecorateStyle)decorateStyle {
    _decorateStyle = decorateStyle;
    self.menuView.decorateStyle = decorateStyle;
}

- (void)setDecorateColor:(UIColor *)decorateColor {
    _decorateColor = decorateColor;
    self.menuView.decorateColor = decorateColor;
}

- (void)setMenuSize:(CGSize)menuSize {
    _menuSize = menuSize;
    self.menuView.frame = CGRectMake(0, 0, menuSize.width, menuSize.height);
}

- (void)setMenuBorderWidth:(CGFloat)menuBorderWidth {
    _menuBorderWidth = menuBorderWidth;
    self.menuView.layer.borderWidth = menuBorderWidth;
}

- (void)setMenuBorderColor:(UIColor *)menuBorderColor {
    _menuBorderColor = menuBorderColor;
    self.menuView.layer.borderColor = menuBorderColor.CGColor;
}

- (void)setMenuCornerRadius:(CGFloat)menuCornerRadius {
    _menuCornerRadius = menuCornerRadius;
    self.menuView.layer.cornerRadius = menuCornerRadius;
}

#pragma mark - getter

- (JHPageMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[JHPageMenuView alloc] init];
        _menuView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _menuView.scrollDirection = (self.menuLocationStyle == JHPageMenuLocationStyleTop || self.menuLocationStyle == JHPageMenuLocationStyleBottom || self.menuLocationStyle == JHPageMenuLocationStyleNavBar) ? JHPageMenuScrollDirectionHorizontal : JHPageMenuScrollDirectionVertical;
        _menuView.delegate = self;
        _menuView.dataSource = self;
    }
    return _menuView;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:(self.menuLocationStyle == JHPageMenuLocationStyleTop || self.menuLocationStyle == JHPageMenuLocationStyleBottom || self.menuLocationStyle == JHPageMenuLocationStyleNavBar) ? UIPageViewControllerNavigationOrientationHorizontal : UIPageViewControllerNavigationOrientationVertical options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        [self addChildViewController:_pageViewController];
    }
    return _pageViewController;
}

- (NSInteger)dataCount {
    return [self.dataSource numbersOfViewControllerInPageController:self];
}

#pragma mark - JHMenuView DataSource & Delegate

- (NSInteger)numbersOfItemsInMenuView:(JHPageMenuView *)menuView {
    return self.dataCount;
}

- (JHPageMenuItem *)menuView:(JHPageMenuView *)menuView menuCellForItemAtIndex:(NSInteger)index {
    return [self.dataSource pageController:self menuView:menuView menuItemAtIndex:index];
}

- (UIView *)decorateItemInMenuView:(JHPageMenuView *)menuView { 
    if ([self.dataSource respondsToSelector:@selector(decorateItemInPageController:menuView:)]) {
        return [self.dataSource decorateItemInPageController:self menuView:menuView];
    }
    return nil;
}

- (void)menuView:(JHPageMenuView *)menuView didSelectIndex:(NSInteger)index {
    if (!self.isDragPageContrller) {
        __weak typeof(self)weakSelf = self;
        UIViewController *vc = [self.dataSource pageController:self viewContrlllerAtIndex:index];
        if (vc == nil) { return; }
        
        NSInteger beforeSelectIndex = self.selectIndex;
        _selectIndex = index;
        [self willEnterViewController];
        if (self.selectIndex == 0 && self.selectIndex == beforeSelectIndex) {
            [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
                [weakSelf didEnterViewController];
            }];
        } else if (self.selectIndex > beforeSelectIndex) {
            [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
                [weakSelf didEnterViewController];
            }];
        } else {
            [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
                [weakSelf didEnterViewController];
            }];
        }
    }
    self.isDragPageContrller = NO;
}

#pragma mark - pageView dataSource & delagate

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.dataSource indexOfViewController:viewController];
    if (index == 0 || (index == NSNotFound)) {
        return nil;
    }
    index --;
    return [self.dataSource pageController:self viewContrlllerAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.dataSource indexOfViewController:viewController];
    if (index == self.dataCount - 1 || (index == NSNotFound)) {
        return nil;
    }
    index ++;
    return [self.dataSource pageController:self viewContrlllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    UIViewController *nextVC = [pendingViewControllers firstObject];
    NSInteger index = [self.dataSource indexOfViewController:nextVC];
    _selectIndex = index;
    [self willEnterViewController];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed && finished) {
        self.isDragPageContrller = YES;
        [self.menuView selectItemAtIndex:self.selectIndex withAnimation:YES];
        [self didEnterViewController];
    }
}

#pragma mark - private

- (void)willEnterViewController {
    [self.delegate pageController:self willEnterViewControllerAtIndex:self.selectIndex];
}

- (void)didEnterViewController {
    [self.delegate pageController:self didEnterViewControllerAtIndex:self.selectIndex];
}

#pragma mark - public

- (void)reloadData {
    if (self.selectIndex > (self.dataCount - 1)) {
        _selectIndex = 0;
    }
    [self.menuView reloadData];
    UIViewController *vc = [self.dataSource pageController:self viewContrlllerAtIndex:self.selectIndex];
    [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
