//
//  PageControllerStyleViewController.m
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/26.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "PageControllerStyleViewController.h"
#import "PageControllerViewController.h"

static NSString *PAGECONTROLLER_STYLE_IDENTIFIER = @"PageControllerStyleCell";

@interface PageControllerStyleViewController ()
@property (nonatomic, copy) NSArray *datas;
@end

@implementation PageControllerStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"菜单样式";
    [self setupData];
    [self setupView];
}

- (void)setupData {
    self.datas = @[@{@"name":@"JHPageMenuLocationStyleTop", @"style":@(JHPageMenuLocationStyleTop)},
                   @{@"name":@"JHPageMenuLocationStyleLeft", @"style":@(JHPageMenuLocationStyleLeft)},
                   @{@"name":@"JHPageMenuLocationStyleBottom", @"style":@(JHPageMenuLocationStyleBottom)},
                   @{@"name":@"JHPageMenuLocationStyleRight", @"style":@(JHPageMenuLocationStyleRight)}];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:PAGECONTROLLER_STYLE_IDENTIFIER];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PAGECONTROLLER_STYLE_IDENTIFIER forIndexPath:indexPath];
    cell.textLabel.text = [self.datas[indexPath.row] objectForKey:@"name"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PageControllerViewController *vc = [[PageControllerViewController alloc] init];
    vc.menuLocationStyle = [[self.datas[indexPath.row] objectForKey:@"style"] integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
