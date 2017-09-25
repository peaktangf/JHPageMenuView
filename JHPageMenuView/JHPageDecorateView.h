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

/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 设置属性
 
 @param decorateItem 装饰器
 @param scrollDirection 滚动方向
 @param decorateNumbers 装饰器个数
 @param decorateSize 装饰器大小
 */
- (void)setDecorateItem:(UIView *)decorateItem menuscrollDirection:(JHPageMenuScrollDirection)scrollDirection decorateNumbers:(NSInteger)decorateNumbers decorateSize:(CGSize)decorateSize;

/**
 装饰器移动到指定下标

 @param index 指定下标
 @param animation 是否动画执行
 */
- (void)moveToIndex:(NSInteger)index withAnimation:(BOOL)animation;

@end
