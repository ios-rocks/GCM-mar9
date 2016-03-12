//
//  FinalDeatilsView.h
//  CountryClub
//
//  Created by atsmacmini4 on 5/26/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface FinalDeatilsView : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *table;
    NSArray *keys;
    UILabel *Navlbl;
    CGRect defaultScreenRect;
    NSString *reqSysVer ;
    NSString *currSysVer;
    AppDelegate *app;
}
@property(nonatomic,strong)NSDictionary *dic,*valuesDic;
@property(nonatomic,strong)NSArray *keysArray;
@property (nonatomic,assign)BOOL isOfflinePay;
@end
