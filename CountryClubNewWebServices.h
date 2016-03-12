//
//  CountryClubNewWebServices.h
//  CountryClubLive
//
//  Created by ATS-Purna on 1/9/15.
//  Copyright (c) 2015 atsmacmini4. All rights reserved.
//

#ifndef CountryClubLive_CountryClubNewWebServices_h
#define CountryClubLive_CountryClubNewWebServices_h
#define isDevelopement 0 // 1 for Development
//0 for Distribution


#define MethodType_POST @"POST"
#define MethodType_GET  @"GET"
#define Authorization_YES YES
#define Authorization_NO    NO

#define MainUrlString @"http://www.countryclubworld.com/akhilapp/ccapp/index_v1.php/"  //all services

#define ImagesUrlString @"http://countryclubworld.com/resort/photos/" //all images load from server

#define HashKeyGenrationURL @"http://www.countryclubworld.com/akhilapp/ccapp/Confirm2.php" //genrate hash key genration for payment

#define LocationsImagesUrl @"http://countryclubworld.com/club/admin/resort_images/" //location images load from server
#define PaymentMainUrl @"http://countryclubworld.com/akhilapp/"

#define Allvenues @"http://countryclubworld.com/badriapp/index.php/add_details/getVenues/"


//MARK:Login URLS
#define Login @"login"
//MethodType:POST Parameters:email,password,city

#define SocialLogin @"/login/social"   //new url
//MethodType:POST  Parameters : email,type

#define MemberCitys  @"/login/cities"
//MethodType:GET


//MARK: Members URLS

#define MemberProfile @"/members/profile"
//MethodType:POST   *Header:YES

#define Member_Payments   @"/members/recipts/mfee"
//MethodType:GET  *Header:YES

#define Member_Receipts    @"/members/recipts/amc"
//MethodType:GET  *Header:YES

#define Holidays    @"/members/holidays"
//MethodType:GET    *Header:YES

#define ClubLogs @"/members/clublogs"
//MethodType:GET    *Header:YES

#define MemberCards @"/members/cards"
//MethodType:GET    *Header:YES




//MARK: Holiday URLS

#define Resorts     @"/holidays/resorts/" //add dynamic hid of end url
//MethodType:GET   *Header:YES

#define AvailableDates  @"/holidays/getDates"
//MethodType:POST Parameters:resortid,rtype,city,hid   *Header:YES

#define UsedHolidays @"/members/holidays/used" //10  this old one
//MethodType:POST
//Parameters: memno,hid


//MARK: Venues

#define AllVenues   @"venues" //8 this is used for all venues and if you need selected venue details pass venue Id like "venues/123(123 is dynamic id value)"
//MethodType:GET


//MARK: Events

#define GetAllEvents    @"/events" // this is used for all events and if you need selected event details pass event id like "events/123 (123 is dynamic id value)"
//MethodType:GET    *Header:NO

#define GetEventSelectedVenue @"/events/venue/" // this is used for selceted venue for  event by passing venue id"


#define EventAtVenueDetails @"getEventByVenue" //19
//MethodType:POST   *Parameters:city    *Header:NO

//MARK: Payments

#define OfflinePayment @"offPayement"
//MethodType:Post   Parameters: 'bankcode', 'mihpayid', 'txnid', 'PG_TYPE', 'productinfo', 'amount', 'addedOn'   Header:YES

#define PostHolidayDataToServer @"/hldyBook"
//MethodType:POST
//Parameters:'bankcode', 'mihpayid', 'txnid', 'PG_TYPE', 'productinfo', 'hldLgth', 'amount', 'addedOn', 'hid', 'rid', 'chkin', 'chkout', 'amcDue', 'noAdult', 'noChild', 'mfDue'
//Header: YES

#define PostAMCAndMFeeDataToServer @"addRecpts"
//MethodType: POST
//Parameters: 'bankcode', 'mihpayid', 'txnid', 'PG_TYPE', 'productinfo', 'amount', 'addedOn'
//Header:YES



//end payment webservice urls
#define HashKeyGenration @"confirm1.php"
//MethodType:POST  Parameters:

#define PaymentResponse @"curlneww.php" 
//MethodType:POST   Parameters:trxid

//MARK: Non-Member URLS

#define MembershipEnquiry @"nonMember"
//MethodType: POST
//Parameters: name, email, mobile, city, age
//newly added 1.1
#define MembershipEnquiryCitys @"nonMember/city"
//MethodType: GET



// MARK: KYC
#define KYC_ImageUpload_Url @"http://countryclubworld.com/akhilapp/ccapp/fileUpload1.php"
//MethodType:POST   *Parameters:image    *Header:NO



#define KYC_ImageDetailsUpload_Url @"kyc/upload"
//MethodType:POST   *Parameters:image,title,memno    *Header:NO

#define KYC_Image_Status @"/member/kycStatus"
//MethodType:POST   *Parameters:type    *Header:YES


  //MARK: 3rd Verision update on 16th June, 2015

#define HolidayFeedback_Url @"holidyfeedback"
  //Method: POST
  //Parameters: email, memname, memMobile,city,memid, membershipno, dbname, servicerate,cleanessrate,foodrate,moneyrate,kidrate,overallrate,recmend,hid
  //  Header: NO



#define ClubFeedback_Url  @"clubfeedback"
  //Method: POST
  //Parameters: email,memname,memMobile,city,memid,membershipno,servicerate,cleanessrate,foodrate,moneyrate,kidrate,overallrate,recmend,clubcity,clubname
  //Header: NO



#define UserFeedback_Url  @"feedback"
  //Method: POST
  //Parameters:remark,subject,email,memname,apikey,memMobile
  //Header: NO



#define BookEvent_Url  @"bookevent"
  //Method: POST
  //Parameters: memid,dbname,eventdate,eventname,eventtime,event_id,nospot,type,resort
  //type:book/cancel
  //nospot:1/2
  //Header: NO

#define ReferOfferMessage_Url  @"refer"
  //Method:Get Parameters:  Header: NO

#define ReferContacts_url  @"refercontacts"
  //Method: POST
  //Parameters: memid,membershipno,memname,city,mobileno,email,refernumber,refername,mobiletype
  //Header: NO


#endif
