//
//  SelectedEventsDedtails.h
//  CountryClubLive
//
//  Created by atsmacmini4 on 9/1/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface SelectedEventsDedtails : UIViewController<UITableViewDataSource,UITableViewDelegate,CountryClubModelDelegate>{
    IBOutlet UITableView *table;
    CountryClubModel *countryClub;
    AppDelegate *app;
    CGRect defaultScreenRect;
    NSString *reqSysVer ;
    NSString *currSysVer;
}
@property(nonatomic,strong)NSMutableArray *filteredarray;
@end
