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
@property (nonatomic, strong) NSMutableArray *decorateMarks;

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
        UICollectionViewFlowLayout *flowLayout             = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing                      = 0;
        flowLayout.scrollDirection                         = UICollectionViewScrollDirectionHorizontal;
        _menuCollectionView                                = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _menuCollectionView.tag                            = JHMENU_COLLECTION_VIEW_TAG;
        _menuCollectionView.backgroundColor                = [UIColor clearColor];
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        _menuCollectionView.showsVerticalScrollIndicator   = NO;
        _menuCollectionView.delegate                       = self;
        _menuCollectionView.dataSource                     = self;
    }
    return _menuCollectionView;
}

- (UICollectionView *)decorateCollectionView {
    if (!_decorateCollectionView) {
        UICollectionViewFlowLayout *flowLayout             = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing                      = 0;
        flowLayout.scrollDirection                         = UICollectionViewScrollDirectionHorizontal;
        _decorateCollectionView                                = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_decorateCollectionView registerClass:[JHPageMenuItem class] forCellWithReuseIdentifier:JHDECORATE_DEFAULT_CELL_IDENTIFIER];
        _decorateCollectionView.tag                            = JHDECORATE_COLLECTION_VIEW_TAG;
        _decorateCollectionView.backgroundColor                = [UIColor clearColor];
        _decorateCollectionView.showsHorizontalScrollIndicator = NO;
        _decorateCollectionView.showsVerticalScrollIndicator   = NO;
        _decorateCollectionView.delegate                       = self;
        _decorateCollectionView.dataSource                     = self;
    }
    return _decorateCollectionView;
}

- (NSMutableArray *)decorateMarks {
    if(!_decorateMarks) {
        _decorateMarks = [[NSMutableArray alloc] init];
    }
    return _decorateMarks;
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
    JHPageMenuItem *item = nil;
    if (collectionView.tag == JHMENU_COLLECTION_VIEW_TAG) {
        item = [self.dataSource menuView:self menuCellForItemAtIndex:indexPath.row];
    } else {
        if ([self.dataSource respondsToSelector:@selector(menuView:decorateCellForItemAtIndex:)]) {
            item = [self.dataSource menuView:self decorateCellForItemAtIndex:indexPath.row];
        } else {
            item = [collectionView dequeueReusableCellWithReuseIdentifier:JHDECORATE_DEFAULT_CELL_IDENTIFIER forIndexPath:indexPath];
        }
    }
    if (item) {
        if (indexPath.row == self.selectIndex) {
            [item setSelected:YES withAnimation:NO];
        } else {
            [item setSelected:NO withAnimation:NO];
        }
    }
    return item;
}

// 控制移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == JHDECORATE_COLLECTION_VIEW_TAG) {
        return YES;
    } else {
        return NO;
    }
}

// 当移动结束的时候会调用这个方法
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    // 取出标记
    NSString *mark = self.decorateMarks[sourceIndexPath.row];
    // 移除标记
    [self.decorateMarks removeObject:mark];
    // 将标记插入到目标位置
    [self.decorateMarks insertObject:mark atIndex:destinationIndexPath.row];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == JHMENU_COLLECTION_VIEW_TAG) {
        [self selectItemAtIndex:indexPath.row];
    }
}

#pragma makr - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 菜单视图滚动的时候，装饰视图也要跟着一起滚动
    if (scrollView.tag == JHMENU_COLLECTION_VIEW_TAG) {
        [_decorateCollectionView setContentOffset:scrollView.contentOffset];
    }
}

#pragma mark - JHMenuViewDataSource

- (NSInteger)menuCount {
    NSInteger menuCount = [self.dataSource numbersOfItemsInMenuView:self];
    if (menuCount > 0 && self.decorateMarks.count == 0) {
        for (int i = 0; i < menuCount; i++) {
            [self.decorateMarks addObject:[NSString stringWithFormat:@"decorate%d",i]];
        }
    }
    return menuCount;
}

#pragma mark - Private

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
    NSInteger beforeSelectIndex = self.selectIndex;
    self.selectIndex = index;
    [self.menuCollectionView reloadData];
    if ([self.delegate respondsToSelector:@selector(menuView:didSelectIndex:)]) {
        [self.delegate menuView:self didSelectIndex:indexPath.row];
    }
    if ([self.dataSource respondsToSelector:@selector(menuView:decorateCellForItemAtIndex:)]) {
        [self moveFormIndex:beforeSelectIndex toIndex:self.selectIndex];
    }
    [self refreshContentOffsetItemFrame:item.frame];
}

- (void)moveFormIndex:(NSInteger)formIndex toIndex:(NSInteger)toIndex {
    NSIndexPath *formIndexPath = [NSIndexPath indexPathForItem:formIndex inSection:0];
    NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:toIndex inSection:0];
    JHPageMenuItem *toCell = (JHPageMenuItem *)[self.decorateCollectionView cellForItemAtIndexPath:toIndexPath];
    CGRect rect = [self.decorateCollectionView convertRect:toCell.frame toView:self.decorateCollectionView];
    CGPoint point = CGPointMake(rect.origin.x + 80/2, 25);
    if (formIndexPath && toIndexPath) {
        [self.decorateCollectionView beginInteractiveMovementForItemAtIndexPath:formIndexPath];
        [UIView animateWithDuration:.3 animations:^{
            [self.decorateCollectionView updateInteractiveMovementTargetPosition:point];
        } completion:^(BOOL finished) {
            [self.decorateCollectionView endInteractiveMovement];
        }];
    }
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
