//
//  JHPageDecorateView.h
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/23.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPageMenuConstant.h"

@interface JHPageDecorateView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

/**
 初始化方法

 @param decorateItem 装饰器
 @param scrollDirection 滚动方向
 @param decorateNumbers 装饰器个数
 @param decorateSize 装饰器大小
 @return 装饰视图
 */
- (instancetype)initWithDecorateItem:(UIView *)decorateItem menuscrollDirection:(JHPageMenuScrollDirection)scrollDirection decorateNumbers:(NSInteger)decorateNumbers decorateSize:(CGSize)decorateSize;

/**
 装饰器移动到指定位置

 @param index 指定位置
 */
- (void)moveToIndex:(NSInteger)index;

@end
