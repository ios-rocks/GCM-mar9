//
//  EventDetails.h
//  CountryClubLive
//
//  Created by atsmacmini4 on 8/25/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AppDelegate.h"
@interface EventDetails : UIViewController<CountryClubModelDelegate,MFMailComposeViewControllerDelegate>{
    AppDelegate *app;
    IBOutlet UIScrollView *scrollview;
    IBOutlet UIImageView *img,*eventimg;
    IBOutlet UILabel *titleLbl;
    CGRect defaultScreenRect;
    NSString *reqSysVer ;
    NSString *currSysVer;
}
@property(nonatomic,strong)NSString *idvalue;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *infoLbl;
@property (weak, nonatomic) IBOutlet UILabel *guestcharge;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *memcharge;
@property(nonatomic,strong)NSDictionary *dic1;
@end
