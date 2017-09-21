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
/** 当前选中的菜单下标 */
@property (nonatomic, assign) NSInteger selectIndex;

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
        JHPageMenuItem *item = [self.dataSource menuView:self menuCellForItemAtIndexPath:indexPath];
        if (indexPath.row == self.selectIndex) {
            [item setSelected:YES withAnimation:NO];
        } else {
            [item setSelected:NO withAnimation:NO];
        }
        return item;
    } else {
        JHPageMenuItem *item = [self.dataSource menuView:self decorateCellForItemAtIndexPath:indexPath];
        return item;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self selectItemAtIndex:indexPath.row];
}

#pragma makr - UIScrollViewDelegate

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

#pragma mark - Private

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.selectIndex == 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        // 当有设置初始菜单下标的时候，等待主队列空闲再执行该方法
        [self selectItemAtIndex:self.selectIndex];
    });
}

- (void)selectItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    JHPageMenuItem *item = [self.dataSource menuView:self menuCellForItemAtIndexPath:indexPath];
    if (!item) {
        return;
    }
    self.selectIndex = index;
    [self.menuCollectionView reloadData];
    if ([self.delegate respondsToSelector:@selector(menuView:didSelectIndexPath:)]) {
        [self.delegate menuView:self didSelectIndexPath:indexPath];
    }
    [self refreshContentOffsetItemFrame:item.frame];
}

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
