//
//  JHPageDecorateView.m
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/23.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "JHPageDecorateView.h"

@interface JHPageDecorateView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, weak) UIView *decorateItem;
@property (nonatomic, assign) NSInteger decorateNumbers;
@property (nonatomic, assign) CGSize decorateSize;
@property (nonatomic, assign) JHPageMenuScrollDirection scrollDirection;

@end

@implementation JHPageDecorateView

#pragma mark - init

- (instancetype)initWithDecorateItem:(UIView *)decorateItem menuscrollDirection:(JHPageMenuScrollDirection)scrollDirection decorateNumbers:(NSInteger)decorateNumbers decorateSize:(CGSize)decorateSize {
    if (self = [super init]) {
        _decorateNumbers = decorateNumbers;
        _decorateSize = decorateSize;
        _decorateItem = decorateItem;
        _scrollDirection = scrollDirection;
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

#pragma mark - getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView                                = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.backgroundColor                = [UIColor clearColor];
        CGSize contentSize = CGSizeZero;
        if (self.scrollDirection == JHPageMenuScrollDirectionHorizontal) {
            contentSize = CGSizeMake(self.decorateSize.width * self.decorateNumbers, self.decorateSize.height);
        } else {
            contentSize = CGSizeMake(self.decorateSize.width, self.decorateSize.height * self.decorateNumbers);
        }
        _scrollView.contentSize                    = contentSize;
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

- (void)moveToIndex:(NSInteger)index {
    if (self.scrollDirection == JHPageMenuScrollDirectionHorizontal) {
        CGFloat x = index * self.decorateSize.width;
        [UIView animateWithDuration:.3 animations:^{
            [self.decorateItem mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(x);
            }];
            [self layoutIfNeeded];
        }];
    } else {
        CGFloat y = index * self.decorateSize.height;
        [UIView animateWithDuration:.3 animations:^{
            [self.decorateItem mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(y);
            }];
            [self layoutIfNeeded];
        }];
    }
}

@end
