//
//  AppDelegate.h
//  Employee
//
//  Created by Country Club on 31/10/15.
//  Copyright © 2015 Country Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CountryClubModel.h"

#define _gAppDelegate   (AppDelegate*)[[UIApplication sharedApplication] delegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate,CountryClubModelDelegate>
@property(nonatomic,strong)CountryClubModel *countryClub;
@property(nonatomic,readwrite)int viewControllerStatus;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MFMailComposeViewController *globalMailComposer;
@property(nonatomic,strong)NSMutableArray *eventsArray;
@property(nonatomic)BOOL isEventBtn;
@property (strong,nonatomic)NSDictionary *memberDictionary;
@property(strong,nonatomic) NSString *string_uid;
@property(nonatomic,readwrite)NSInteger AmcRmem;
@property(nonatomic,strong)NSString *amcPrice,*amcDue,*mfDue;
@property(nonatomic,readwrite)BOOL checkHldayStatus,checkBookinghotel,locationscheck,paymentviewStatus,isAuthenticate;
@property(nonatomic,strong)NSString *ResortName,*City,*RoomType,*chickin,*chickout,*adultNum,*childNum,*HlyLen,*hid,*rid;


@property(nonatomic, readonly, strong) NSString *registrationKey;
@property(nonatomic, readonly, strong) NSString *messageKey;
@property(nonatomic, readonly, strong) NSString *gcmSenderID;
@property(nonatomic, readonly, strong) NSDictionary *registrationOptions;


- (void)showLoadingView:(BOOL)isShown activityTitle:(NSString*)title;
- (void)showAlertView:(BOOL)isShown message:(NSString*)message;


@end

