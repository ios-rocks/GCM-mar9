//
//  SidebarViewController.h
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *table;
@property(strong,nonatomic) NSMutableArray *array_EmpInfo;

@property(strong,nonatomic) NSMutableArray *array_EmpInfoimages;
@end

