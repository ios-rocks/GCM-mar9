//
//  BookingHolidayViewcontroller.h
//  CountryClub
//
//  Created by atsmacmini4 on 4/16/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface BookingHolidayViewcontroller : UIViewController<UITextFieldDelegate,CountryClubModelDelegate>
{
    AppDelegate *app;
    int p;
    NSString *reqSysVer ;
    NSString *currSysVer;
    CGRect defaultScreenRect;
    UIFont *font,*font1;
    
}
@property(nonatomic,strong)NSString *city,*roomtype,*rid,*hldyLength,*resortName,*type,*season,*currency;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;
@property (weak, nonatomic) IBOutlet UITextField *roomtypeTextfield;

@property (strong,nonatomic)NSString *memid,*memcity,*hid2;
@property (strong, nonatomic) IBOutlet UILabel *label_static;

@property (weak, nonatomic) IBOutlet UITextField *holidayslength;
@property (weak, nonatomic) IBOutlet UITextField *checkIn;
@property (weak, nonatomic) IBOutlet UILabel *roomLbl;

@property (strong, nonatomic) IBOutlet UILabel *label_infodates;

@end
