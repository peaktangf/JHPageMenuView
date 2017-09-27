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
/** 装饰器当前的下标 */
@property (nonatomic, assign) NSInteger selectIndex;
/** 装饰器当前的位置 */
@property (nonatomic, assign) CGFloat position;


/** 定时器 */
@property (nonatomic, weak) CADisplayLink *displayLink;
/** 装饰器需要移动的距离绝对值（差距） */
@property (nonatomic, assign) CGFloat gap;
/** 装饰器每一步需要移动的距离（步伐） */
@property (nonatomic, assign) CGFloat step;
/** 装饰器移动的方向： 1代表正方向，-1代表反方向 */
@property (nonatomic, assign) int sign;

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

- (void)moveToIndex:(NSInteger)index withAnimation:(BOOL)animation {
    if (self.selectIndex == index) {
        [self moveToPosition:self.position];
    } else {
        self.gap = (self.scrollDirection == JHPageMenuScrollDirectionHorizontal ? self.decorateSize.width : self.decorateSize.height) * labs(index -  self.selectIndex);
        self.sign = self.selectIndex > index ? -1 : 1;
        self.step = animation ? self.gap / 15 : self.gap;
        self.selectIndex = index;
        if (self.displayLink) {
            [self.displayLink invalidate];
        }
        // 通过 CADisplayLink 来执行动画
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(progressChanged)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        self.displayLink = link;
    }
}

#pragma mark - private

- (void)progressChanged {
    if (self.gap > 0.00001) {
        self.gap -= self.step;
        if (self.gap < 0.0) {
            [self moveToPosition:self.position + self.sign * self.step];
            return;
        }
        [self moveToPosition:self.position + self.sign * self.step];
    } else {
        [self moveToPosition:self.position];
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)moveToPosition:(CGFloat)pos {
    self.position = pos;
    [self.decorateItem mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.scrollDirection == JHPageMenuScrollDirectionHorizontal) {
            make.leading.mas_equalTo(pos);
        } else {
            make.top.mas_equalTo(pos);
        }
    }];
    [self layoutIfNeeded];
}

@end
