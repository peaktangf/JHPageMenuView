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
    if ([self.delegate respondsToSelector:@selector(menuView:sizeForItemAtIndex:)]) {
        return [self.delegate menuView:self sizeForItemAtIndex:indexPath.row];
    }
    return CGSizeZero;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.menuCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHPageMenuItem *item = [self.dataSource menuView:self menuCellForItemAtIndex:indexPath.row];
    if (indexPath.row == self.selectIndex) {
        [item setSelected:YES withAnimation:NO];
    } else {
        [item setSelected:NO withAnimation:NO];
    }
    return item;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self selectItemAtIndex:indexPath.row];
}

#pragma makr - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
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
    JHPageMenuItem *item = [self.dataSource menuView:self menuCellForItemAtIndex:indexPath.row];
    if (!item) {
        return;
    }
    self.selectIndex = index;
    [self.menuCollectionView reloadData];
    if ([self.delegate respondsToSelector:@selector(menuView:didSelectIndex:)]) {
        [self.delegate menuView:self didSelectIndex:indexPath.row];
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
