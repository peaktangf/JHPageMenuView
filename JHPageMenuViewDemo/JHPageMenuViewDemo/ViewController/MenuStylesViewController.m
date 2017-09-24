//
//  MenuStylesViewController.m
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/23.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "MenuStylesViewController.h"
#import "MenuViewController.h"

static NSString *MENU_STYLE_IDENTIFIER = @"MenuStyleCell";

@interface MenuStylesViewController ()
@property (nonatomic, copy) NSArray *datas;
@end

@implementation MenuStylesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"菜单样式";
    [self setupData];
    [self setupView];
}

- (void)setupData {
    self.datas = @[@{@"name":@"JHPageDecorateStyleDefault", @"style":@(JHPageDecorateStyleDefault)},
                   @{@"name":@"JHPageDecorateStyleLine", @"style":@(JHPageDecorateStyleLine)},
                   @{@"name":@"JHPageDecorateStyleFlood", @"style":@(JHPageDecorateStyleFlood)},
                   @{@"name":@"JHPageDecorateStyleFloodHollow", @"style":@(JHPageDecorateStyleFloodHollow)},
                   @{@"name":@"自定义菜单", @"style":@(11)},
                   @{@"name":@"自定义装饰器", @"style":@(22)}];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MENU_STYLE_IDENTIFIER];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MENU_STYLE_IDENTIFIER forIndexPath:indexPath];
    cell.textLabel.text = [self.datas[indexPath.row] objectForKey:@"name"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MenuViewController *vc = [[MenuViewController alloc] init];
    vc.menuScrollDirection = self.menuScrollDirection;
    if ([[self.datas[indexPath.row] objectForKey:@"style"] integerValue] == 11) {
        vc.isCustomMenu = YES;
        vc.decorateStyle = JHPageDecorateStyleLine;
    } else if ([[self.datas[indexPath.row] objectForKey:@"style"] integerValue] == 22) {
        vc.isCustomDecorate = YES;
    } else {
        vc.decorateStyle = [[self.datas[indexPath.row] objectForKey:@"style"] integerValue];
    }
    [self.navigationController pushViewController:vc animated:YES];
}




@end
