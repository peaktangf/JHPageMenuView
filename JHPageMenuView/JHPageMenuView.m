//
//  JHPageMenuView.m
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/21.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "JHPageMenuView.h"
#import "JHPageDecorateView.h"
#import "JHPageMenuItem.h"
#import "JHPageDecorateBuiltInItem.h"

@interface JHPageMenuView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
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
    self.decorateStyle = JHPageDecorateStyleDefault;
    self.decorateColor = [UIColor redColor];
    [self addSubview:self.menuCollectionView];
    [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
}

#pragma mark - setter

- (void)setScrollDirection:(JHPageMenuScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    self.flowLayout.scrollDirection = scrollDirection == JHPageMenuScrollDirectionHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
}

#pragma mark - getter

- (UICollectionView *)menuCollectionView {
    if (!_menuCollectionView) {
        _menuCollectionView                                = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _menuCollectionView.tag                            = JHMENU_COLLECTION_VIEW_TAG;
        _menuCollectionView.backgroundColor                = [UIColor clearColor];
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        _menuCollectionView.showsVerticalScrollIndicator   = NO;
        _menuCollectionView.delegate                       = self;
        _menuCollectionView.dataSource                     = self;
    }
    return _menuCollectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout                     = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing  = 0;
        _flowLayout.scrollDirection     = self.scrollDirection == JHPageMenuScrollDirectionHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

- (NSInteger)menuCount {
    NSInteger menuCount = [self.dataSource numbersOfItemsInMenuView:self];
    if (menuCount != 0 && self.decorateView == nil) {
        [self addDecorateView];
    }
    return menuCount;
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.menuSize;
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
    // 菜单视图滚动的时候，装饰视图也要跟着一起滚动
    if (scrollView.tag == JHMENU_COLLECTION_VIEW_TAG) {
        [_decorateView.scrollView setContentOffset:scrollView.contentOffset];
    }
}

#pragma mark - Private

- (void)addDecorateView {
    
    UIView *decorateItem = nil;
    if ([self.dataSource respondsToSelector:@selector(decorateItemInMenuView:)] && [self.dataSource decorateItemInMenuView:self]) {
        decorateItem = [self.dataSource decorateItemInMenuView:self];
    } else {
        if (self.decorateStyle == JHPageDecorateStyleDefault) return;
        
        JHPageDecorateBuiltInItem *builtInItem = [[JHPageDecorateBuiltInItem alloc] init];
        builtInItem.scrollDirection = self.scrollDirection;
        builtInItem.decorateSize = self.decorateSize.width == 0 ? self.menuSize : self.decorateSize;
        builtInItem.decorateColor = self.decorateColor;
        builtInItem.decorateStyle = self.decorateStyle;
        decorateItem = builtInItem;
    }
    JHPageDecorateView *decorateView = [[JHPageDecorateView alloc] initWithDecorateItem:decorateItem menuscrollDirection:self.scrollDirection decorateNumbers:[self.dataSource numbersOfItemsInMenuView:self] decorateSize:self.menuSize];
    self.decorateView = decorateView;
    [self insertSubview:self.decorateView atIndex:0];
    [self.decorateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == nil) {
        return;
    }
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
    if ([self.delegate respondsToSelector:@selector(menuView:didSelectIndex:)]) {
        [self.delegate menuView:self didSelectIndex:indexPath.row];
    }
    [self.menuCollectionView reloadData];
    if (self.decorateView) {
        [self.decorateView moveToIndex:self.selectIndex];
    }
    [self refreshContentOffsetItemFrame:item.frame];
}

// 让选中的item位于中间
- (void)refreshContentOffsetItemFrame:(CGRect)frame {
    
    CGSize contentSize = self.menuCollectionView.contentSize;
    if (self.scrollDirection == JHPageMenuScrollDirectionHorizontal) {
        CGFloat itemX = frame.origin.x;
        CGFloat itemWith = self.menuCollectionView.frame.size.width;
        if (itemX > itemWith/2) {
            CGFloat targetX;
            if ((contentSize.width-itemX) <= itemWith/2) {
                targetX = contentSize.width - itemWith;
            } else {
                targetX = itemX - itemWith/2 + frame.size.width/2;
            }
            // 应该有更好的解决方法
            if (targetX + itemWith > contentSize.width) {
                targetX = contentSize.width - itemWith;
            }
            [self.menuCollectionView setContentOffset:CGPointMake(targetX, 0) animated:YES];
        } else {
            [self.menuCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    } else {
        CGFloat itemY = frame.origin.y;
        CGFloat itemHeight = self.menuCollectionView.frame.size.height;
        if (itemY > itemHeight/2) {
            CGFloat targetY;
            if ((contentSize.height-itemY) <= itemHeight/2) {
                targetY = contentSize.height - itemHeight;
            } else {
                targetY = itemY - itemHeight/2 + frame.size.height/2;
            }
            // 应该有更好的解决方法
            if (targetY + itemHeight > contentSize.height) {
                targetY = contentSize.height - itemHeight;
            }
            [self.menuCollectionView setContentOffset:CGPointMake(0, targetY) animated:YES];
        } else {
            [self.menuCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

@end
