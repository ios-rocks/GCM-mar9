//
//  CCHHLiveViewController.h
//  Employee
//
//  Created by Country Club on 08/12/15.
//  Copyright © 2015 Country Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface CCHHLiveViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  UITableView *mainTableView;
@property (strong, nonatomic)  UITableView *helperTableView;
@end
