//
//  CountryClubModel.h
//  WebServicesCalling
//
//  Created by ATS-Purna on 4/15/14.
//  Copyright (c) 2014 ATS-MacMini3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "CountryClubServices.h"
#import "CountryClubNewWebServices.h"
#define PayDetails @"OfflinelinePayData"
#define isPressedFacebook 1

#define kUserFeedbackNotification @"UserFeedbackNotification"


@protocol CountryClubModelDelegate <NSObject>

@optional
// Delegate methods
-(void)resultLoginDetails:(NSString *)resultsString;
-(void)sendHolidaysData:(NSDictionary *)dic;
-(void)updatingImagesData:(NSMutableArray *)dataArray;
-(void)getProfileDetailsData:(NSDictionary *)dic andKeysArray:(NSMutableArray *)KeysArray;
-(void)getMemberFeeData:(NSDictionary *)dic;
-(void)getAMCFeeData:(NSDictionary *)dic;
-(void)sendLocationsData:(NSMutableDictionary *)locationsDictionary;
-(void)sendDetailsOfVenue:(NSDictionary *)dic;
-(void)sendPaymentDetails:(NSString *)passString;
-(void)sendAvailableDates:(NSDictionary *)dic;
-(void)sendMemberLoginCities:(NSMutableArray *)citiesArray;
-(void)paymentResponseDic:(NSDictionary *)dic;

//new 1.1
-(void)getAllEventsData:(NSDictionary *)dic;
-(void)getSelectedEvent:(NSDictionary *)dic;
-(void)getClubLogs:(NSDictionary *)dic;
-(void)getMemberCards:(NSDictionary *)dic;
-(void)getOfflinePayments:(NSDictionary *)dic;
//1.2
-(void)getStatusOfMembershipEnquiry:(NSString *)message;
-(void)getCitysOfMembershipEnquiry:(NSArray *)citiesArray;
-(void)getEventDetailsOfSelectedVenue:(NSDictionary *)dic;
-(void)send_KYC_uploadImageDetais:(NSString *)message;
-(void)send_KYC_Image_StatusDetails:(NSDictionary *)dic;

  //verison 1.3

-(void)countyClubModel_ResponseOfHoildayFeedBack:(NSDictionary *)dic;
-(void)countyClubModel_ResponseOfUserFeedback:(NSDictionary *)dic;
-(void)countyClubModel_ResponseOfClubFeedback :(NSDictionary *)dic;
-(void)countyClubModel_ResponseOfBookEvent:(NSDictionary *)dic;
-(void)countyClubModel_ResponseOfCancelEvent:(NSDictionary *)dic;
-(void)countyClubModel_ResponseOfReferMessage:(NSDictionary *)dic;
-(void)countyClubModel_ResponseOfReferContactDetails:(NSDictionary *)dic;
-(void)countyClubModel_ResponseOfBookedEvents:(NSDictionary *)dic;
 -(void)countyClubModel_ResponseGetInfoSelectedUsedHoliday:(NSDictionary *)dic;




@end


@interface CountryClubModel : NSObject
{
    NSMutableURLRequest *globalRequest;
    NSString *presentUrlString,*txnid;
    NSURL *globalUrl;
    NSTimer *timer;
   
}

@property(nonatomic,strong) NSString *loginKey;
@property (nonatomic,strong) NSDictionary *profileDictionary,*holidayDictionary,*bookingHolidayData;
@property (nonatomic,strong) NSMutableArray *allVenuesMutableArray,*updatingImagesArray,*storedProfileKeysArray;
@property (nonatomic,strong) NSMutableDictionary *allTypesOfVenuesDictionary;
@property (nonatomic, strong) id <CountryClubModelDelegate> delegate;
@property (nonatomic,strong)  NSString *memshipnumber;
@property NSMutableDictionary *loginDetailsDictionary;



//*customerCareDetailsDictionary;

+(CountryClubModel *)sharedInstance;
-(NSArray *)isLogin;
-(void)checkLoginFileds:(NSDictionary *)filedsData;
-(void)getMemberCitys;
-(void)getMemberProfileDetails;
-(NSMutableArray *)getVenues:(NSString *)filterName;
-(void)getResorts:(NSString *)hid;
-(void)getAvailableDates:(NSDictionary *)dic;
//-(NSMutableArray *)getReceipts;
-(void)getHolidays;
-(void)sendMemberFeeData;
-(void)sendAMCFeeData;
-(void)getLocationsData;
-(void)getDetailsOfVenue:(NSString *)idValue;

-(void)paymentDetails:(NSString *)productInfo andAmount:(CGFloat)amount andCurrencyType:(NSString *)currencyType andDic:(NSDictionary *)dataDic;
-(void)detailsOfPayment;
-(NSDictionary *)getusedDetails:(NSString*)hid;
-(NSDictionary *)sentDataToServer:(id)receiveData;



// new 1.1
-(void)sendAllEventsData;
-(void)sendEventDataByEventId:(NSString *)eid;
-(void)sendClubLogs;
-(void)sendMemberCards;
-(void)sendOfflinePaymentDetails:(NSDictionary *)dic;
-(NSDictionary *)sendToServerOffPaymentData:(id)receiveData;
-(void)sendEventsByVenuCity:(NSString *)idValue;


//1.2
-(void)socialLogin:(NSDictionary *)dataDictionary;
-(void)membershipEnquiryDetails:(NSDictionary *)dic;
-(void)findEventOfSelectedVenue:(NSString *)venuid;
-(void)KYC_uploadImage:(UIImage *)image andTitle:(NSString *)title;
-(void)KYC_Image_StatusDetails:(NSString *)string;
-(void)membershipEnquiryCitys;



  //1.3

-(void)sendHoildayFeedBack:(NSDictionary *)dic;
-(void)sendUserFeedback:(NSDictionary *)dic;
-(void)sendClubFeedback :(NSDictionary *)dic;
-(void)sendBookEvent:(NSDictionary *)dic;
-(void)sendCancelEvent:(NSDictionary *)dic;
-(void)getReferMessage;
-(void)sendReferContactDetails:(NSArray *)givenArray;
-(void)getBookedEvents;
-(void)getInfoSelectedUsedHoliday:(NSString *)hid;


//-(NSDictionary *)fileteringEventData:(NSString *)key andValue:(NSString *)value;
//bankcode,mihpayid,txnid,PG_TYPE,productinfo,amount,addedOn,name,mo bile,email,curncy,payBelt,paidAmt

@end
