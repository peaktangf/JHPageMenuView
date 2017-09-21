//
//  JHPageMenuView.m
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/21.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "JHPageMenuView.h"
#import "JHPageMenuItem.h"
#import "JHPageMenuConstant.h"

@interface JHPageMenuView ()<UICollectionViewDelegate, UICollectionViewDataSource>

/** collectionView的布局 */
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/** 菜单的高度 */
@property (nonatomic, assign) CGFloat menuHeight;
/** 菜单个数 */
@property (nonatomic, assign) NSInteger menuCount;

@end

@implementation JHPageMenuView

#pragma mark - init

// 代码初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

// xib初始化
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    [self addSubview:self.decorateCollectionView];
    [self.decorateCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
    [self addSubview:self.menuCollectionView];
    [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
}

#pragma mark - getter

- (UICollectionView *)menuCollectionView {
    if (!_menuCollectionView) {
        _menuCollectionView                                = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _menuCollectionView.tag                            = JHMENU_COLLECTIONVIEW_TAG;
        _menuCollectionView.backgroundColor                = [UIColor clearColor];
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        _menuCollectionView.delegate                       = self;
        _menuCollectionView.dataSource                     = self;
    }
    return _menuCollectionView;
}

- (UICollectionView *)decorateCollectionView {
    if (!_decorateCollectionView) {
        _decorateCollectionView                                = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _decorateCollectionView.tag                            = JHDECORATE_COLLECTIONVIEW_TAG;
        _decorateCollectionView.backgroundColor                = [UIColor clearColor];
        _decorateCollectionView.showsHorizontalScrollIndicator = NO;
        _decorateCollectionView.delegate                       = self;
        _decorateCollectionView.dataSource                     = self;
    }
    return _decorateCollectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout                    = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection    = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(menuView:sizeForItemAtIndexPath:)]) {
        return [self.delegate menuView:self sizeForItemAtIndexPath:indexPath];
    }
    return CGSizeZero;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.menuCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == JHMENU_COLLECTIONVIEW_TAG) {
        return [self.dataSource menuView:self menuCellForItemAtIndexPath:indexPath];
    } else {
        return [self.dataSource menuView:self decorateCellForItemAtIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JHPageMenuItem *cell = [self.dataSource menuView:self menuCellForItemAtIndexPath:indexPath];
    if (cell) {
        // 禁用手势 (防止连续点击) 
        self.menuCollectionView.userInteractionEnabled = NO;
        [self refreshContentOffsetItemFrame:cell.frame];
    }
    if ([self.delegate respondsToSelector:@selector(menuView:didSelectIndexPath:)]) {
        [self.delegate menuView:self didSelectIndexPath:indexPath];
    }
}

#pragma makr - UIScrollViewDelegate

// 当有滚动的时候就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    //同步两个collectionView的滚动
    if (collectionView.tag == JHMENU_COLLECTIONVIEW_TAG) {
        [self.decorateCollectionView setContentOffset:collectionView.contentOffset];
    } else {
        [self.menuCollectionView setContentOffset:collectionView.contentOffset];
    }
}

#pragma mark - JHMenuViewDataSource

- (NSInteger)menuCount {
    return [self.dataSource numbersOfItemsInMenuView:self];
}

#pragma mark - private

// 让选中的item位于中间
- (void)refreshContentOffsetItemFrame:(CGRect)frame {
    CGFloat itemX = frame.origin.x;
    CGFloat width = self.menuCollectionView.frame.size.width;
    CGSize contentSize = self.menuCollectionView.contentSize;
    if (itemX > width/2) {
        CGFloat targetX;
        if ((contentSize.width-itemX) <= width/2) {
            targetX = contentSize.width - width;
        } else {
            targetX = frame.origin.x - width/2 + frame.size.width/2;
        }
        // 应该有更好的解决方法
        if (targetX + width > contentSize.width) {
            targetX = contentSize.width - width;
        }
        [self.menuCollectionView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    } else {
        [self.menuCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

@end
