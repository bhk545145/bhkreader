//
//  MainTableViewController.h
//  bhkreader
//
//  Created by bai on 15/11/3.
//  Copyright © 2015年 bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *siderbarBtn;

- (IBAction)Refresh:(id)sender;


@end
