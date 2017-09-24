//
//  JHPageMenuItem.m
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/21.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "JHPageMenuItem.h"
#import "JHPageMenuView.h"

@implementation JHPageMenuItem

#pragma mark - init

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
}

+ (instancetype)menuView:(JHPageMenuView *)menuView itemForIndex:(NSInteger)index {
    [self registerItemCollectionView:menuView.menuCollectionView];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    return [menuView.menuCollectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

+ (void)registerItemCollectionView:(UICollectionView *)collectionView {
    
    // 如果存在对应的xib，就注册nib。如果捕获到异常，就注册class
    @try {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([self class])];
    } @catch (NSException *exception) {
        [collectionView registerClass:[self class] forCellWithReuseIdentifier:NSStringFromClass([self class])];
    } 
}

#pragma mark - Overwrite

- (void)menuItemNormalStyle {
    // 告知item选中时的样式，自定义的菜单需要重写该方法
    if (self.menuItemNormalStyleBlock) {
        self.menuItemNormalStyleBlock();
    }
}

- (void)menuItemSelectedStyle {
    // 告知item未选中时的样式，自定义的菜单需要重写该方法
    if (self.menuItemSelectedStyleBlock) {
        self.menuItemSelectedStyleBlock();
    }
}

#pragma mark - Public

- (void)setSelected:(BOOL)selected withAnimation:(BOOL)animation {
    self.itemSelected = selected;
    if (selected) {
        [self menuItemSelectedStyle];
    } else {
        [self menuItemNormalStyle];
    }
}

@end
