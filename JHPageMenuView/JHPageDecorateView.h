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

- (instancetype)initWithDecorateItem:(UIView *)decorateItem menuscrollDirection:(JHPageMenuScrollDirection)scrollDirection decorateNumbers:(NSInteger)decorateNumbers decorateSize:(CGSize)decorateSize;
- (void)moveToIndex:(NSInteger)index;

@end
