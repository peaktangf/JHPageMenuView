//
//  JHPageMenuConstant.h
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/21.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#ifndef JHPageMenuConstant_h
#define JHPageMenuConstant_h

#import <Masonry.h>
static const NSInteger JHMENU_COLLECTION_VIEW_TAG = 1111;

/**
 菜单选中和未选中的样式
 */
typedef NS_ENUM(NSInteger, JHPageMenuItemStyle) {
    JHPageMenuItemStyleNormal,  // 正常样式
    JHPageMenuItemStyleSelected // 选中样式
};

/**
 菜单滚动方向
 */
typedef NS_ENUM(NSInteger, JHPageMenuScrollDirection) {
    JHPageMenuScrollDirectionHorizontal, // 水平
    JHPageMenuScrollDirectionVertical    // 垂直
};

/**
 菜单装饰的自带样式
 */
typedef NS_ENUM(NSInteger, JHPageDecorateStyle) {
    JHPageDecorateStyleDefault,     // 默认样式（就是没有样式）
    JHPageDecorateStyleLine,        // 带下划线，需要设置高度和宽度，不设置高度和宽度，默认和菜单的大小一样
    JHPageDecorateStyleFlood,       // 涌入效果 (填充)，需要设置高度和宽度，不设置高度和宽度，默认和菜单的大小一样
    JHPageDecorateStyleFloodHollow  // 涌入效果 (空心的)，需要设置高度和宽度，不设置高度和宽度，默认和菜单的大小一样
};

#endif /* JHPageMenuConstant_h */
