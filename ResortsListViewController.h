//
//  ResortsListViewController.h
//  CountryClub
//
//  Created by atsmacmini4 on 4/16/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class AppDelegate;
@interface ResortsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    AppDelegate *app;
    CGRect defaultScreenRect;
    NSString *reqSysVer ;
    NSString *currSysVer;
    BOOL searchStatus;
   

}
@property(nonatomic,strong)IBOutlet UITableView *ResortsTable;
@property(nonatomic,strong) NSMutableArray *resortsArray;
@property(nonatomic,strong)NSString *hid,*hlydaylenght;
@property (weak, nonatomic) IBOutlet UILabel *ResultLbl;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (strong,nonatomic)NSString *memid,*memcity;
@property(nonatomic,strong)NSArray *holidaysArray;

@end
