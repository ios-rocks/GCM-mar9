//
//  LocationsDetails.h
//  CountryClub
//
//  Created by atsmacmini4 on 5/5/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AppDelegate.h"
@interface LocationsDetails : UIViewController<MFMailComposeViewControllerDelegate,CountryClubModelDelegate>{
    IBOutlet UIImageView *imageview,*lblImageview,*btnsBackimg,*firstbackimg;
    IBOutlet UIButton *contactBtn,*emailBtn,*directionsBtn,*eventsBtn,*banquetMenuBtn;
    UIScrollView *scrollview;
    AppDelegate *app;
    CGRect defaultScreenRect;
    NSString *reqSysVer ;
    NSString *currSysVer;
    IBOutlet UISwitch *switchbtn;
    

}
@property (strong, nonatomic) IBOutlet UIScrollView *backScrollview;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *resortName;
@property(weak,nonatomic)IBOutlet UILabel *Type,*cityname;
@property(nonatomic,strong)NSDictionary *locationsDic,*mainDic;
@property(nonatomic,strong)NSString *idvalue;

@end
