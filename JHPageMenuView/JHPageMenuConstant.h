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
static const NSInteger JHMENU_COLLECTION_VIEW_TAG         = 11;
static const NSInteger JHDECORATE_COLLECTION_VIEW_TAG     = 22;
static NSString *JHDECORATE_DEFAULT_CELL_IDENTIFIER        = @"jh_decorate_default_cell_identifier";

typedef NS_ENUM(NSInteger, JHPageMenuItemStyle) {
    JHPageMenuItemStyleNormal,  // 正常样式
    JHPageMenuItemStyleSelected // 选中样式
};

#endif /* JHPageMenuConstant_h */
