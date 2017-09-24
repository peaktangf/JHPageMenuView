//
//  JHPageDecorateView.m
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/23.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "JHPageDecorateView.h"

@interface JHPageDecorateView ()<UIScrollViewDelegate>

/** 滚动内容视图 */
@property (nonatomic, strong) UIView *progressView;
/** 滚动方向 */
@property (nonatomic, assign) JHPageMenuScrollDirection scrollDirection;
/** 装饰器视图 */
@property (nonatomic, weak) UIView *decorateItem;
/** 装饰器个数 */
@property (nonatomic, assign) NSInteger decorateNumbers;
/** 装饰器大小 */
@property (nonatomic, assign) CGSize decorateSize;

@end

@implementation JHPageDecorateView

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
    [self.scrollView addSubview:self.progressView];
}

#pragma mark - getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView                                = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.backgroundColor                = [UIColor clearColor];
    }
    return _scrollView;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView                 = [[UIView alloc] init];
        _progressView.backgroundColor = [UIColor clearColor];
    }
    return _progressView;
}

#pragma mark - public

- (void)moveToIndex:(NSInteger)index withAnimation:(BOOL)animation {
    if (self.scrollDirection == JHPageMenuScrollDirectionHorizontal) {
        CGFloat x = index * self.decorateSize.width;
        if (animation) {
            [UIView animateWithDuration:.3 animations:^{
                [self.decorateItem mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(x);
                }];
                [self layoutIfNeeded];
            }];
        } else {
            [self.decorateItem mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(x);
            }];
        }
    } else {
        CGFloat y = index * self.decorateSize.height;
        if (animation) {
            [UIView animateWithDuration:.3 animations:^{
                [self.decorateItem mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(y);
                }];
                [self layoutIfNeeded];
            }];
        } else {
            [self.decorateItem mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(y);
            }];
        }
    }
}

- (void)setDecorateItem:(UIView *)decorateItem menuscrollDirection:(JHPageMenuScrollDirection)scrollDirection decorateNumbers:(NSInteger)decorateNumbers decorateSize:(CGSize)decorateSize {
    if (self.decorateItem) { 
        [self.decorateItem removeFromSuperview];
    }
    self.decorateNumbers = decorateNumbers;
    self.decorateSize = decorateSize;
    self.decorateItem = decorateItem;
    self.scrollDirection = scrollDirection;
    CGSize contentSize = CGSizeZero;
    if (self.scrollDirection == JHPageMenuScrollDirectionHorizontal) {
        contentSize = CGSizeMake(self.decorateSize.width * self.decorateNumbers, self.decorateSize.height);
    } else {
        contentSize = CGSizeMake(self.decorateSize.width, self.decorateSize.height * self.decorateNumbers);
    }
    self.scrollView.contentSize = contentSize;
    if (self.scrollDirection == JHPageMenuScrollDirectionHorizontal) {
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.equalTo(self.scrollView);
            make.width.mas_equalTo(self.scrollView.contentSize.width);
        }];
    } else {
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.equalTo(self.scrollView);
            make.height.mas_equalTo(self.scrollView.contentSize.height);
        }];
    }
    [self.progressView addSubview:self.decorateItem];
    [self.decorateItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.progressView);
        make.width.mas_equalTo(self.decorateSize.width);
        make.height.mas_equalTo(self.decorateSize.height);
    }];
}

@end
