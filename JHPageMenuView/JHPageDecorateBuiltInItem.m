//
//  JHPageDecorateBuiltInItem.m
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/23.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "JHPageDecorateBuiltInItem.h"

@interface JHPageDecorateBuiltInItem ()
@property (nonatomic, weak) UIView *contentView; 
@end

@implementation JHPageDecorateBuiltInItem

#pragma mark - init

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - setter

- (void)setDecorateStyle:(JHPageDecorateStyle)decorateStyle {
    [self.contentView removeFromSuperview];
    switch (decorateStyle) {
        case JHPageDecorateStyleDefault:
            break;
        case JHPageDecorateStyleLine:
            [self addLineView];
            break;
        case JHPageDecorateStyleFlood:
            [self addFloodView];
            break;
        case JHPageDecorateStyleFloodHollow:
            [self addFloodHollowView];
            break;
    }
}

#pragma mark - private

- (void)addLineView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = self.decorateColor;
    self.contentView = lineView;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.scrollDirection == JHPageMenuScrollDirectionHorizontal) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
        } else {
            make.centerY.equalTo(self);
            make.right.equalTo(self);
        }
        make.height.mas_equalTo(self.decorateSize.height);
        make.width.mas_equalTo(self.decorateSize.width);
    }];
}

- (void)addFloodView {
    UIView *floodView = [[UIView alloc] init];
    floodView.layer.cornerRadius = self.decorateSize.height/2;
    floodView.backgroundColor = self.decorateColor;
    self.contentView = floodView;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(self.decorateSize.width);
        make.height.mas_equalTo(self.decorateSize.height);
    }];
}

- (void)addFloodHollowView {
    UIView *floodHollowView = [[UIView alloc] init];
    floodHollowView.backgroundColor = [UIColor clearColor];
    floodHollowView.layer.borderWidth = 1;
    floodHollowView.layer.borderColor = self.decorateColor.CGColor;
    floodHollowView.layer.cornerRadius = self.decorateSize.height/2;
    self.contentView = floodHollowView;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(self.decorateSize.width);
        make.height.mas_equalTo(self.decorateSize.height);
    }];
}

@end
