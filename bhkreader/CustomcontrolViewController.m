//
//  CustomcontrolViewController.m
//  bhkreader
//
//  Created by bai on 15/12/3.
//  Copyright © 2015年 bai. All rights reserved.
//

#import "CustomcontrolViewController.h"
#import "SWRevealViewController.h"

@interface CustomcontrolViewController ()

@end

@implementation CustomcontrolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _siderbarBtn.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    _siderbarBtn.target = self.revealViewController;
    _siderbarBtn.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
