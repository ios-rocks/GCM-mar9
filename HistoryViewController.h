//
//  HistoryViewController.h
//  Employee
//
//  Created by Country Club on 06/01/16.
//  Copyright © 2016 Country Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController
@property (strong,nonatomic)NSDictionary *memberDictionary;
@property (strong,nonatomic)NSArray *memberArray;

@property (strong, nonatomic) IBOutlet UITableView *table;

@end
