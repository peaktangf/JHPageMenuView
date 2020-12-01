<h1 align="center">Welcome to JHPageMenuView 👋</h1>

## ✨ 实现思路

##### 1、我们所知的分页菜单
- 京东

![京东发现页.gif](http://upload-images.jianshu.io/upload_images/1248713-37fea9637385132c.gif?imageMogr2/auto-orient/strip)

- 天猫

![天猫国际页.gif](http://upload-images.jianshu.io/upload_images/1248713-1e7e5d083f9f9950.gif?imageMogr2/auto-orient/strip)


##### 2、```JHPageMenuView```拽写的初衷
- 已有的开源组件有哪些？
> 1、**[WMPageController](https://github.com/wangmchn/WMPageController)**：OC版本，菜单只支持纯文本，装饰只有内置的几种，自定义性太低，可用范围有限；
2、**[PageMenu](https://github.com/PageMenu/PageMenu)**：Swift版本，菜单也是只支持纯文本，装饰器只有两种，自定义性太低，可用范围有限；
3、**[ZJScrollPageView](https://github.com/jasnig/ZJScrollPageView)**：OC版本，菜单支持文本和图片混合，装饰器只有内置的几种样式，自定义性太低，但大部分都够用；
- 为什么做这个组件？
>目前开源的组件无法满足快速变化的需求，UI层面永远是计划赶不上变化，不可能做到未雨绸缪；基于此，可能每个开发者到项目中都会根据当前的UI来重写一个。这样可能会出现一些重复的bug，重要的是浪费时间和精力。
- 这个组件的优势是什么？
>上面已经提到了目前开源组件无法实现UI层面的快速变化，所以这个组件的优势，就是能够以不变应万变。这个组件的UI支持高度自定义，但是接口并没有因此而变得复杂。
- 这个组件源代码复杂吗？
>可能你会想，高度自定义的UI组件，内部一定封装了很多东西来自动化。其实并没有你想的那么复杂，这个组件的内部只使用了一个```UICollectionView```和一个```UIScrollView```来实现功能，可以说是完全使用```UIKit```内置的UI组件，并没有过多复杂的代码。
##### 3、UI分析

![UI结构.png](http://upload-images.jianshu.io/upload_images/1248713-15f51f5078ff4fbd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 4、项目结构

![项目结构.png](http://upload-images.jianshu.io/upload_images/1248713-929220cbe1b6198d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 5、滚动同步
菜单视图滚动会触发装饰视图滚动，以此达到滚动同步的目的

![滚动同步.gif](http://upload-images.jianshu.io/upload_images/1248713-1621cf2e68989eb6.gif?imageMogr2/auto-orient/strip)

```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 菜单视图滚动的时候，装饰视图也要跟着一起滚动
    if (scrollView.tag == JHMENU_COLLECTION_VIEW_TAG) {
        [_decorateView.scrollView setContentOffset:scrollView.contentOffset];
    }
}
```
##### 6、支持内置菜单样式+自定义菜单
- **内置菜单**：组件目前内置的菜单样式只有纯文本的，一些常用的需求基本就够用了，内置菜单样式想要展示选中和未选中的样式，可以通过下面两个block来进行设置：
```
JHPageMenuItem *item = [JHPageMenuItem menuView:menuView itemForIndex:index];

item.menuItemNormalStyleBlock = ^{
    // 告知item正常情况下的样式
};

item.menuItemSelectedStyleBlock = ^{
    // 告知item选中时的样式
};
```
![内置菜单.gif](http://upload-images.jianshu.io/upload_images/1248713-fe88e09a9e0c9fad.gif?imageMogr2/auto-orient/strip)
- **自定义菜单**：自定义菜单才是最核心的，自定义菜单继承自```JHPageMenuItem```基类（```JHPageMenuItem```其实就是继承自```UICollectionViewCell```），并且，需要重写下面两个方法：
```
@interface CustomMenuItem ()
@property (weak, nonatomic) IBOutlet UIView *markView;
@end

- (void)menuItemSelectedStyle {
    // 告知item正常情况下的样式，自定义的菜单需要重写该方法
}

- (void)menuItemNormalStyle {
    // 告知item选中时的样式，自定义的菜单需要重写该方法
}

@end
```
![自定义菜单.gif](http://upload-images.jianshu.io/upload_images/1248713-53db4b5f3b6e6203.gif?imageMogr2/auto-orient/strip)

##### 7、支持内置装饰器+自定义装饰器
- **内置装饰器**：菜单有内置的4中装饰器，基本涵盖了目前一些常用的样式；
```
/**
 菜单装饰的自带样式
 */
typedef NS_ENUM(NSInteger, JHPageDecorateStyle) {
    JHPageDecorateStyleDefault, // 默认样式
    JHPageDecorateStyleLine, // 带下划线
    JHPageDecorateStyleFlood, // 涌入效果 (填充)
    JHPageDecorateStyleFloodHollow // 涌入效果 (空心的)
};
```
![内置样式-JHPageDecorateStyleDefault.gif](http://upload-images.jianshu.io/upload_images/1248713-fe88e09a9e0c9fad.gif?imageMogr2/auto-orient/strip)

![内置样式-JHPageDecorateStyleLine.gif](http://upload-images.jianshu.io/upload_images/1248713-e80a6f8a7e61f1df.gif?imageMogr2/auto-orient/strip)

![内置样式-JHPageDecorateStyleFlood.gif](http://upload-images.jianshu.io/upload_images/1248713-0f8ab4a5e10e36b2.gif?imageMogr2/auto-orient/strip)

![内置样式-JHPageDecorateStyleFloodHollow.gif](http://upload-images.jianshu.io/upload_images/1248713-76128daebb74b121.gif?imageMogr2/auto-orient/strip)

- **自定义装饰器**：难免会有与众不同的UI，这个时候自定义装饰器就可以大显神通了，很简单，你只要实现一个数据源代理方法，把你想要的装饰器设置进去，就OK了
```
- (UIView *)decorateItemInMenuView:(JHPageMenuView *)menuView {
    // 在这里设置你的自定义装饰器
}
```
![自定义装饰器.gif](http://upload-images.jianshu.io/upload_images/1248713-b71f248d2a23c24f.gif?imageMogr2/auto-orient/strip)

##### 8、菜单切换可嵌入自定义动画
菜单切换默认是没有动画的，不过已经提供了接口
- 内置菜单切换动画，可以通过下面提供的block来实现：
```
item.menuItemNormalStyleAnimationBlock = ^{
    // 告知item 从 选中 - 未选中 时执行的动画，可以通过这个block进行设置
};

item.menuItemSelectedStyleAnimationBlock = ^{
    // 告知item 从 未选中 - 选中 时执行的动画，可以通过这个block进行设置 
};
```
- 自定义菜单切换动画，可以重写下面两个方法
```
- (void)menuItemNormalStyleAnimation {
    // 告知item 从 选中 - 未选中 时执行的动画，自定义的菜单如果需要执行动画，需要重写该方法
}

- (void)menuItemSelectedStyleAnimation {
    // 告知item 从 未选中 - 选中 时执行的动画，自定义的菜单如果需要执行动画，需要重写该方法
}
```

##### 9、菜单支持垂直和水平的滚动方向
菜单支持横向和竖向的滚动，可用范围更广
```
/**
 菜单滚动方向
 */
typedef NS_ENUM(NSInteger, JHPageMenuScrollDirection) {
    JHPageMenuScrollDirectionHorizontal, // 水平
    JHPageMenuScrollDirectionVertical    // 垂直
};
```
![水平滚动的菜单.gif](http://upload-images.jianshu.io/upload_images/1248713-e80a6f8a7e61f1df.gif?imageMogr2/auto-orient/strip)

![垂直滚动的菜单.gif](http://upload-images.jianshu.io/upload_images/1248713-c43b909aaac8f4c1.gif?imageMogr2/auto-orient/strip)

##### 10、JHPageController
```JHPageController```是基于```JHPageMenuVeiw```和```UIPageViewController```进行封装的一个分页控制器，控制器内部已经把这两个组件的关联进行了封装，并且暴露了代理出来，只需要简单的几行代码，就能实现一个炫酷的分页控制器，依赖于```JHPageMenuVeiw```高度可自定义功能，```JHPageController```的功能依旧强大。

![项目结构.png](http://upload-images.jianshu.io/upload_images/1248713-8d0916dd5b34687b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![JHPageController展示-顶部.gif](http://upload-images.jianshu.io/upload_images/1248713-bc22c9d614db47dc.gif?imageMogr2/auto-orient/strip)

![JHPageController展示-左边.gif](http://upload-images.jianshu.io/upload_images/1248713-422643a5f4ef1013.gif?imageMogr2/auto-orient/strip)

![JHPageController展示-底部.gif](http://upload-images.jianshu.io/upload_images/1248713-a5111347ef9dc9b8.gif?imageMogr2/auto-orient/strip)

![JHPageController展示-右边.gif](http://upload-images.jianshu.io/upload_images/1248713-b596cb59216d2f56.gif?imageMogr2/auto-orient/strip)

![JHPageController展示-导航栏.gif](http://upload-images.jianshu.io/upload_images/1248713-ef9006d970218357.gif?imageMogr2/auto-orient/strip)

##### 11、遇到的问题
- 如何简单的实现装饰器视图
>一开始是有尝试用```UICollectionView```来承载装饰器的，直接用iOS9的新特性，对单元格进行重排来实现移动动画，因为是内置的动画，而且```UICollectionView```已经是比较成熟的集合视图，所以才会有这个想法。但后来经过尝试发现还是存在不少未知问题，所以就放弃了，改用```UIScollView```来封装一个装饰器视图。
- UIScrollView的滚动和View的移动动画同时进行导致的卡顿
>导致这种现象的原因就是```runloop```在作怪；解决办法就是启动一个定时器，把定时器添加到```NSRunLoopCommonModes```的mode下，然后在这个定时器下定时移动View，达到一种动画的效果。
- CADisplayLink定时器替代NSTimer定时器（[关于CADisplayLink](http://www.jianshu.com/p/c35a81c3b9eb)）
>```CADisplayLink``` 是一个能让我们以和屏幕刷新率相同的频率将内容画到屏幕上的定时器，精确度相当高。一但 ```CADisplayLink``` 以特定的模式注册到```runloop```之后，每当屏幕需要刷新的时候，```runloop```就会调用```CADisplayLink```绑定的```target```上的```selector```。至此，动画卡顿问题解决。
