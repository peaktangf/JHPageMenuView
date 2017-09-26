//
//  ViewController.m
//  JHMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/20.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "MenuDirectionViewController.h"
#import "MenuStylesViewController.h"
#import "NavTabMenuViewController.h"
#import "PageControllerStyleViewController.h"


static NSString *MENU_DIRECTION_IDENTIFIER = @"MenuDirectionCell";

@interface MenuDirectionViewController ()
@property (nonatomic, copy) NSArray *datas;

@end

@implementation MenuDirectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"菜单类型";
    [self setupData];
    [self setupView];
}

- (void)setupData {
    self.datas = @[@"横向菜单",@"竖向菜单",@"网易选项卡",@"JHPageController"];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MENU_DIRECTION_IDENTIFIER];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MENU_DIRECTION_IDENTIFIER forIndexPath:indexPath];
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        NavTabMenuViewController *tabMenuVc = [[NavTabMenuViewController alloc] init];
        [self.navigationController pushViewController:tabMenuVc animated:YES];
    } else if (indexPath.row == 3) {
        PageControllerStyleViewController *pageStyleVc = [[PageControllerStyleViewController alloc] init];
        [self.navigationController pushViewController:pageStyleVc animated:YES];
    } else {
        MenuStylesViewController *styleVc = [[MenuStylesViewController alloc] init];
        styleVc.menuScrollDirection = indexPath.row == 0 ? JHPageMenuScrollDirectionHorizontal : JHPageMenuScrollDirectionVertical;
        [self.navigationController pushViewController:styleVc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
