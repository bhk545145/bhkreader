//
//  leftviewTableViewController.m
//  bhkreader
//
//  Created by bai on 15/12/3.
//  Copyright © 2015年 bai. All rights reserved.
//

#import "leftviewTableViewController.h"
#import "ViewController.h"
#import "CustomcontrolViewController.h"


@interface leftviewTableViewController (){
    NSArray *_array1;
    
}

@end

@implementation leftviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工具";
    _array1 = @[@"一键配置",@"自定义"];
    [self setExtraCellLineHidden:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array1.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [_array1 objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = CellIdentifier;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ViewController *vc = [[ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        CustomcontrolViewController *customvc = [[CustomcontrolViewController alloc]init];
        [self.navigationController pushViewController:customvc animated:YES];
    }
}

/*该方法仅为了解决UITableView多余的分割线*/
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}


@end
