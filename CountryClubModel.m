//
//  CountryClubModel.m
//  WebServicesCalling
//
//  Created by ATS-Purna on 4/15/14.
//  Copyright (c) 2014 ATS-MacMini3. All rights reserved.
//

#import "CountryClubModel.h"


//my custom keys more used
#define Error    @"error"
#define Message  @"message"

#define kSelectorName @"SelectorName"
#define kDataValues       @"DataValues"
#define kDataKeys         @"DataKyes"


//user defaults keys
#define ProfieDetails @"ProfileDetails"
#define LoginKey    @"LoginKey"
#define MemshipNumber @"memShipNo"
#define CustomerCareDetailsValues @"CustomerCareDetailsValues"
#define CurrentDBName @"dbname"
#define LoginDetailsDic @"LoginDetailsDic"


@interface CountryClubModel()
{
    NSString *currentEventKey,*currentEventValue;
    
    NSDictionary *reciveDataDictionary;
}


@property(nonatomic,strong) NSMutableOrderedSet *delegateObjectsSet;
@property (nonatomic, strong) NSDictionary *offlinePaymentDic;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation CountryClubModel


+(CountryClubModel *)sharedInstance
{
    static CountryClubModel *countryClub = nil;
    if (!countryClub)
    {
        countryClub = [[super allocWithZone:nil]init];
        countryClub.loginKey = [[NSUserDefaults standardUserDefaults] stringForKey:LoginKey];
        countryClub.loginDetailsDictionary = [[NSUserDefaults standardUserDefaults]objectForKey:LoginDetailsDic];
        
    }
    
    return countryClub;
}
+(id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.loginKey = [[NSUserDefaults standardUserDefaults] stringForKey:LoginKey];
        _delegateObjectsSet = [[NSMutableOrderedSet alloc]init];
        self.loginDetailsDictionary = [[NSUserDefaults standardUserDefaults]objectForKey:LoginDetailsDic];
        
    }
    return self;
}

-(void)setDelegate:(id)delegate
{
    
    for (int i = 0 ; i < [_delegateObjectsSet count]; i++)
        if ([[_delegateObjectsSet objectAtIndex:i] isKindOfClass:[delegate class]])
            [_delegateObjectsSet removeObjectAtIndex:i];
    
    [_delegateObjectsSet addObject:delegate];
    _delegate = delegate;
}


-(void)callDelegateMethods:(NSDictionary *)currentDic
{
    
    
    SEL presentSelector = NSSelectorFromString([currentDic objectForKey:kSelectorName]);
    
    for (id<CountryClubModelDelegate> delegate in _delegateObjectsSet)
    {
        if ([delegate respondsToSelector:presentSelector])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [delegate performSelector:presentSelector withObject:[currentDic objectForKey:kDataValues] withObject:[currentDic objectForKey:kDataKeys]];
#pragma clang diagnostic pop
        }
        
    }
    
}
#pragma -mark - Login and Logout
#pragma mark -
-(NSArray *)isLogin
{
    self.loginKey = [[NSUserDefaults standardUserDefaults]stringForKey:LoginKey];
    if (self.loginKey)
    {
        self.memshipnumber = [[NSUserDefaults standardUserDefaults]stringForKey:MemshipNumber];
        return @[@YES];
        
    }
    else
    {
        return @[@NO,@0];
    }
    return NO;
}


-(void)checkLoginFileds:(NSDictionary *)filedsData
{
    //method number 10
    [self sendAsynchronousUrlRequest:Login andMethodType:MethodType_POST HeaderFiledAuthorization:Authorization_NO andBody:filedsData andMethodNumber:10];
    
}
-(void)socialLogin:(NSDictionary *)dataDictionary
{
    [self sendAsynchronousUrlRequest:SocialLogin andMethodType:MethodType_POST HeaderFiledAuthorization:Authorization_NO andBody:dataDictionary andMethodNumber:10];
}
#pragma mark - Net dependent method
-(void)getMemberCitys
{
    [self sendAsynchronousUrlRequest:MemberCitys andMethodType:MethodType_GET HeaderFiledAuthorization:Authorization_NO andBody:nil andMethodNumber:9];
}



-(void)getMemberProfileDetails
{
    //  NSDictionary *dataDic =[[NSUserDefaults standardUserDefaults]dictionaryForKey:ProfieDetails];
    
    [ self  sendAsynchronousUrlRequest:MemberProfile andMethodType:MethodType_GET HeaderFiledAuthorization:Authorization_YES andBody:nil andMethodNumber:3];
    
    
    //    if ([[dataDic valueForKey:Error] integerValue] == 0)
    //    {
    //        return dataDic;
    //    }
    //    else
    //    {
    //        //NSLog(@"data dic %@",dataDic);
    //        return dataDic;
    //    }
    //    return 0;
}

#pragma -mark -  Locations
#pragma mark -
-(void)getLocationsData
{
    [self sendAsynchronousUrlRequest:AllVenues andMethodType:MethodType_GET HeaderFiledAuthorization:Authorization_NO andBody:nil andMethodNumber:5];
}
-(NSMutableArray *)getVenues:(NSString *)filterName
{
    
    
    
    NSDictionary *dataDic;
    NSMutableArray *filterVenuesArray;
    
    if (!self.allVenuesMutableArray)
    {
        dataDic =  [self sendSynchronousUrlRequest:AllVenues andMethodType:MethodType_GET HeaderFiledAuthorization:Authorization_NO andBody:nil];
        //        //NSLog(@"data dic %@",dataDic);
    }
    
    
    if ([[dataDic valueForKey:Error] integerValue] == 0 || self.allVenuesMutableArray)
    {
        if (dataDic)
            self.allVenuesMutableArray = [dataDic objectForKey:@"venues"];
        
        if (![filterName isEqualToString:@"All"])
        {
            filterVenuesArray  = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in self.allVenuesMutableArray)
            {
                if ([[dic objectForKey:@"Type"] isEqualToString:filterName])
                    [filterVenuesArray addObject:dic];
            }
        }
        else
        {
            filterVenuesArray = self.allVenuesMutableArray;
        }
        
    }
    return filterVenuesArray;
}

-(void)getDetailsOfVenue:(NSString *)idValue
{
    NSString *dynamicStringUrl = [AllVenues stringByAppendingPathComponent:idValue];
    [self sendAsynchronousUrlRequest:dynamicStringUrl andMethodType:MethodType_GET HeaderFiledAuthorization:Authorization_NO andBody:nil andMethodNumber:6];
    
}

#pragma -mark - holidays and resorts and avialble dates
#pragma mark -
-(void)getHolidays
{
    [self sendAsynchronousUrlRequest:Holidays andMethodType:MethodType_GET HeaderFiledAuthorization:Authorization_YES andBody:nil andMethodNumber:1];
}



#pragma  -mark - imagesData
#pragma mark -
-(void)dataUpdating
{
    self.updatingImagesArray = nil;
    self.allVenuesMutableArray = nil;
    self.allTypesOfVenuesDictionary = nil;
    timer = nil;
    
    //    //NSLog(@"data updating");
}

-(void)getResorts:(NSString *)hid
{
    
    NSString *dynamicUrlString = [Resorts stringByAppendingPathComponent:hid];
    [self sendAsynchronousUrlRequest:dynamicUrlString andMethodType:MethodType_GET HeaderFiledAuthorization:Authorization_YES andBody:nil andMethodNumber:8];
    
}


-(void)getAvailableDates:(NSDictionary *)dic
{
    [self sendAsynchronousUrlRequest:AvailableDates andMethodType:MethodType_POST HeaderFiledAuthorization:Authorization_YES andBody:dic andMethodNumber:7];
    
}


#pragma -mark - Payments & Recepts
#pragma mark -


-(void)sendMemberFeeData
{
    [self  sendAsynchronousUrlRequest:Member_Payments andMethodType:MethodType_GET HeaderFiledAuthorization:Authorization_YES andBody:nil andMethodNumber:2];
    
}
-(void)sendAMCFeeData
{
    [self  sendAsynchronousUrlRequest:Member_Receipts andMethodType:MethodType_GET HeaderFiledAuthorization:Authorization_YES andBody:nil andMethodNumber:4];
    
}

#pragma mark - EvetnsData Added1.1
#pragma mark -

-(void)sendAllEventsData
{
    
    //method  number 12
    [self sendAsynchronousUrlRequest:GetAllEvents andMethodType:MethodType_GET HeaderFiledAuthorization:Authorization_YES andBody:nil andMethodNumber:12];
    
}
-(void)sendEventDataByEventId:(NSString *)eid
{
    //method number 13
    NSString *dynamicURLString = [GetAllEvents stringByAppendingPathComponent:eid];
    [self sendAsynchronousUrlRequest:dynamicURLString andMethodType:MethodType_GET HeaderFiledAuthorization:Authorization_NO andBody:nil andMethodNumber:13];
}

-(void)sendMemberCards
{
    [self sendAsynchronousUrlRequest:MemberCards andMethodType:MethodType_GET HeaderFiledAuthorization:Authorization_YES andBody:nil andMethodNumber:14];
}
-(void)sendClubLogs
{
    [self sendAsynchronousUrlRequest:ClubLogs andMethodType:MethodType_GET HeaderFiledAuthorization:Authorization_YES andBody:nil andMethodNumber:15];
}
-(void)sendEventsByVenuCity:(NSString *)idValue
{
    [self sendAsynchronousUrlRequest:EventAtVenueDetails andMethodType:MethodType_POST HeaderFiledAuthorization:Authorization_NO andBody:@{@"city":idValue} andMethodNumber:12];
}

-(void)sendOfflinePaymentDetails:(NSDictionary *)dic
{
    NSMutableDictionary *modDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    [modDic removeObjectForKey:@"payBelt"];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"OffPaymentData"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isOfflinePayment"];
    //    [modDic setValue:@"0.10" forKey:@"amount"];
    self.offlinePaymentDic = [[NSDictionary alloc]initWithDictionary:dic];
    [self sendAsynchronousUrlRequest:HashKeyGenrationURL andMethodType:MethodType_POST HeaderFiledAuthorization:Authorization_NO andBody:modDic andMethodNumber:16];
}

-(void)membershipEnquiryDetails:(NSDictionary *)dic
{
    //here method number 17
    [self sendAsynchronousUrlRequest:MembershipEnquiry andMethodType:MethodType_POST HeaderFiledAuthorization:NO andBody:dic andMethodNumber:17];
}
-(void)findEventOfSelectedVenue:(NSString *)venuid
{
    //here method numbe 18
    NSString *currentURLString = [GetEventSelectedVenue stringByAppendingPathComponent:venuid];
    
    [self sendAsynchronousUrlRequest:currentURLString andMethodType:MethodType_GET HeaderFiledAuthorization:NO andBody:nil andMethodNumber:18];
    
}
-(void)KYC_uploadImage:(UIImage *)image andTitle:(NSString *)title
{
    
    NSString *imageName = [[NSUserDefaults standardUserDefaults]stringForKey:@"ImageName"];
    NSInteger imageNumber;
    if (!imageName)
        imageNumber = 1;
    else
        imageNumber = [[[imageName componentsSeparatedByString:@"_"]lastObject]integerValue];
    
    imageName = [NSString stringWithFormat:@"%@-image_00%ld.png",self.memshipnumber,(long)++imageNumber];
    [self imageUpload:image andFileName:imageName andImageTypeTitle:title andImageParameter:@"image" andUrlString:[NSURL URLWithString:KYC_ImageUpload_Url]];
    
}
-(void)KYC_uploadImageDetais:(NSString *)imageName andandTitle:(NSString *)title
{
    //method number 19
    
    [self sendAsynchronousUrlRequest:KYC_ImageDetailsUpload_Url andMethodType:MethodType_POST HeaderFiledAuthorization:NO andBody:@{@"image":imageName,@"title":title,@"memno":self.memshipnumber} andMethodNumber:19];
    
}


-(void)KYC_Image_StatusDetails:(NSString *)string
{
    //metrhod number 20
    [self sendAsynchronousUrlRequest:KYC_Image_Status andMethodType:MethodType_POST HeaderFiledAuthorization:YES andBody:@{@"type":string} andMethodNumber:20];
    
}
-(void)membershipEnquiryCitys
{
    //metrhod number 21
    [self sendAsynchronousUrlRequest:MembershipEnquiryCitys andMethodType:MethodType_GET HeaderFiledAuthorization:YES andBody:nil andMethodNumber:21];
}




//MARK:1.3 verision

-(void)sendHoildayFeedBack:(NSDictionary *)dic
{
    //method 22
    
    //email, memname, memMobile,city,memid, membershipno, dbname, servicerate,cleanessrate,foodrate,moneyrate,kidrate,overallrate,recmend,hid
    
    
    NSArray *keys = @[@"email",@"memName",@"city",@"memid",@"memShipNo",@"dbname",@"memMobile"];
    NSArray *serviceKeys = @[@"email",@"memname",@"city",@"memid",@"membershipno",@"dbname",@"memMobile"];
    
    
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    for(int i = 0 ; i< keys.count ; i++)
    {
        NSString *key = keys[i];
        NSString *value = [self.loginDetailsDictionary objectForKey:key];
        
        [dataDictionary setObject:value forKey:serviceKeys[i]];
    }
    
    
    [dataDictionary addEntriesFromDictionary:dic];
    
    [self sendAsynchronousUrlRequest:HolidayFeedback_Url andMethodType:MethodType_POST HeaderFiledAuthorization:NO andBody:dataDictionary andMethodNumber:22];
    
    
}
-(void)sendUserFeedback:(NSDictionary *)dic
{
    //method 23
    // remark,subject,email,memname,apikey,memMobile
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"memname":[self.loginDetailsDictionary objectForKey:@"memName"],@"memMobile":[self.loginDetailsDictionary objectForKey:@"memMobile"],@"apikey":[self.loginDetailsDictionary objectForKey:@"apiKey"]}];
    [dataDictionary addEntriesFromDictionary:dic];
    
    [self sendAsynchronousUrlRequest:UserFeedback_Url andMethodType:MethodType_POST HeaderFiledAuthorization:YES andBody:dataDictionary andMethodNumber:23];
}
-(void)sendClubFeedback :(NSDictionary *)dic
{
    //method 24
    //Parameters: email,memname,memMobile,city,memid,membershipno,servicerate,cleanessrate,foodrate,moneyrate,kidrate,overallrate,recmend,clubcity,clubname
    
    NSArray *keys = @[@"email",@"memName",@"city",@"memid",@"memShipNo",@"dbname",@"memMobile"];
    NSArray *serviceKeys = @[@"email",@"memname",@"city",@"memid",@"memshipno",@"dbname",@"mobileno"];
    
    
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    for(int i = 0 ; i< keys.count ; i++)
    {
        NSString *key = keys[i];
        NSString *value = [self.loginDetailsDictionary objectForKey:key];
        
        [dataDictionary setObject:value forKey:serviceKeys[i]];
    }
    
    //  NSDictionary *modelDic = @{@"email":[self.loginDetailsDictionary objectForKey:@"email"],@"memname":[self.loginDetailsDictionary objectForKey:@"memname"],@"city":[self.loginDetailsDictionary objectForKey:@"city"],@"memid":[self.loginDetailsDictionary objectForKey:@"memid"],@"membershipno":[self.loginDetailsDictionary objectForKey:@"membershipno"],@"dbname":[self.loginDetailsDictionary objectForKey:@"dbname"],@"memMobile":[self.loginDetailsDictionary objectForKey:@"memMobile"]};
    //
    //
    //
    //
    //  [dataDictionary addEntriesFromDictionary:modelDic];
    [dataDictionary addEntriesFromDictionary:dic];
    
    
    [self sendAsynchronousUrlRequest:ClubFeedback_Url andMethodType:MethodType_POST HeaderFiledAuthorization:NO andBody:dataDictionary andMethodNumber:24];
}
-(void)sendBookEvent:(NSDictionary *)dic
{
    //method 25
    //Parameters: memid,dbname,eventdate,eventname,eventtime,event_id,nospot,type,resort
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"memid":[self.loginDetailsDictionary objectForKey:@"memid"],@"type":@"book",@"dbname":[self.loginDetailsDictionary objectForKey:@"dbname"]}];
    [dataDictionary addEntriesFromDictionary:dic];
    
    
    [self sendAsynchronousUrlRequest:BookEvent_Url andMethodType:MethodType_POST HeaderFiledAuthorization:YES andBody:dataDictionary andMethodNumber:25];
}

-(void)sendCancelEvent:(NSDictionary *)dic
{
    //method 26
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"memid":[self.loginDetailsDictionary objectForKey:@"memid"],@"type":@"cancel",@"dbname":[self.loginDetailsDictionary objectForKey:@"dbname"]}];
    
    [dataDictionary addEntriesFromDictionary:dic];
    
    [self sendAsynchronousUrlRequest:BookEvent_Url andMethodType:MethodType_POST HeaderFiledAuthorization:YES andBody:dataDictionary andMethodNumber:26];
    
    
}
-(void)getReferMessage
{
    //method 27
    [self sendAsynchronousUrlRequest:ReferOfferMessage_Url andMethodType:MethodType_GET HeaderFiledAuthorization:YES andBody:nil andMethodNumber:27];
    
    
}
-(void)sendReferContactDetails:(NSArray *)givenArray
{
    //method 28
    //Parameters: memid[],membershipno[],memname[],city[],mobileno[],email[],mobiletype[]
    //refernumber[],refername[],employee[]
    
    
    
    NSArray *keys = @[@"email",@"memName",@"city",@"memid",@"memShipNo",@"memMobile"];
    NSArray *serviceKeys = @[@"email[]",@"memname[]",@"city[]",@"memid[]",@"memshipno[]",@"mobileno[]"];
    
    
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (NSDictionary *givenDic  in givenArray)
    {
        NSMutableDictionary *presentDic = [NSMutableDictionary dictionaryWithDictionary:givenDic];
        for(int i = 0 ; i< keys.count ; i++)
        {
            NSString *key = keys[i];
            NSString *value = [self.loginDetailsDictionary objectForKey:key];
            
            [presentDic setObject:value forKey:serviceKeys[i]];
            
            
        }
        
        [presentDic setObject:@"iOS" forKey:@"mobiletype[]"];
        NSString *values = [presentDic objectForKey:@"refernumber[]"];
        values = [self separateNumber:values];
        
        
        [presentDic setObject:values forKey:@"refernumber[]"];
        
        [dataArray addObject:presentDic];
        
        
    }
    
    
    
    
    
    
    
    [self sendAsynchronousUrlRequest:ReferContacts_url andMethodType:MethodType_POST HeaderFiledAuthorization:YES andBody:@{@"GivenData":dataArray} andMethodNumber:28];
    
}

-(NSString *)separateNumber:(NSString *)originalString
{
    //NSString *originalString = @"(123) 123123 abc";
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:originalString.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    return strippedString;
    
}
-(void)getBookedEvents
{
    //method 29
    NSString *urlstring = [GetAllEvents stringByAppendingPathComponent:[NSString stringWithFormat:@"book/%@/%@",[self.loginDetailsDictionary objectForKey:@"memid"],[self.loginDetailsDictionary objectForKey:@"dbname"]]];
    
    [self sendAsynchronousUrlRequest:urlstring andMethodType:MethodType_GET HeaderFiledAuthorization:NO andBody:nil andMethodNumber:29];
    
}
-(void)getInfoSelectedUsedHoliday:(NSString *)hid
{
    //http://www.countryclubworld.com/akhilapp/ccapp/index_v1.php/usedresortinfo/hid/dbname
    NSString *urlstring = [NSString stringWithFormat:@"usedresortinfo/%@/%@",hid,[self.loginDetailsDictionary objectForKey:@"dbname"]];
    [self sendAsynchronousUrlRequest:urlstring andMethodType:MethodType_GET HeaderFiledAuthorization:NO andBody:nil andMethodNumber:30];
    
}

#pragma -mark -  Synchronous and Asyncronous Request
#pragma mark -

-(NSDictionary  *)sendSynchronousUrlRequest:(NSString *)endUrlString andMethodType:(NSString *)method HeaderFiledAuthorization:(BOOL)authorization andBody:(NSDictionary *)inputValuesDictionary
{
    
    
    globalRequest = [[NSMutableURLRequest alloc]init];
    presentUrlString = [MainUrlString stringByAppendingPathComponent:endUrlString];
    globalUrl = [NSURL URLWithString:presentUrlString];
    [globalRequest setURL:globalUrl];
    [globalRequest setHTTPMethod:method];   //passing method type
    [globalRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    if (authorization)
    {
        //if you authorizations then pass YES
        [globalRequest addValue:self.loginKey forHTTPHeaderField:@"Authorization"];
    }
    if (inputValuesDictionary)
    {
        //if you have Body data
        NSMutableString *bodyString = [[NSMutableString alloc]init];
        for (NSString *keyObject in inputValuesDictionary.allKeys)
        {
            [bodyString appendFormat:@"%@=%@&",keyObject,[inputValuesDictionary valueForKey:keyObject]];
        }
        NSData *inputData = [[NSData alloc]initWithBytes:[bodyString UTF8String] length:[bodyString length]];
        [globalRequest setHTTPBody:inputData];
        
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:globalRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if (!error) {
                                          reciveDataDictionary =  [[NSMutableDictionary alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]];
                                          
                                          for (NSString *keySting in reciveDataDictionary.allKeys)
                                          {
                                              if ([reciveDataDictionary objectForKey:keySting] == [NSNull null])
                                                  [reciveDataDictionary setValue:@"NA" forKey:keySting];
                                          }
                                          return ;
                                          
                                      }
                                      
                                      else
                                      {
                                          
                                          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"please enter correct data" preferredStyle:UIAlertControllerStyleAlert];
                                          
                                          UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                          [alertController addAction:ok];
                                          [alertController performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                          
                                          return;
                                          
                                          reciveDataDictionary= @{Error:@1,Message:error};
                                          
                                      }
                                      
                                      
                                  }];
    
    [task resume];
    
    return reciveDataDictionary;
}


-(void)sendAsynchronousUrlRequest:(NSString *)endUrlString andMethodType:(NSString *)method HeaderFiledAuthorization:(BOOL)authorization andBody:(NSDictionary *)inputValuesDictionary andMethodNumber:(int)methodNumber
{
    [NSURLConnection cancelPreviousPerformRequestsWithTarget:self];
    
    globalRequest = [[NSMutableURLRequest alloc]init];
    
    
    presentUrlString = [MainUrlString stringByAppendingPathComponent:endUrlString];
    if (methodNumber == 16)
        presentUrlString = endUrlString;
    
    
    
    globalUrl = [NSURL URLWithString:presentUrlString];
    [globalRequest setURL:globalUrl];
    [globalRequest setHTTPMethod:method];   //passing method type
    [globalRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    if (authorization)
    {
        //if you authorizations then pass YES
        [globalRequest addValue:self.loginKey forHTTPHeaderField:@"Authorization"];
    }
    
    if (inputValuesDictionary)
    {
        //if you have Body data
        NSMutableString *bodyString = [[NSMutableString alloc]init];
        for (id currentKey in inputValuesDictionary.allKeys)
        {
            if([[inputValuesDictionary valueForKey:currentKey] isKindOfClass:[NSString class]])
            {
                NSString *keyObject = (NSString *)currentKey;
                [bodyString appendFormat:@"%@=%@&",keyObject,[inputValuesDictionary valueForKey:keyObject]];
            }
            else if([[inputValuesDictionary valueForKey:currentKey] isKindOfClass:[NSArray class]])
            {
                NSArray *currentArray = [inputValuesDictionary valueForKey:currentKey];
                for (NSDictionary *currentDic in currentArray)
                {
                    for(NSString *lastKey in currentDic.allKeys)
                        [bodyString appendFormat:@"%@=%@&",lastKey,[currentDic valueForKey:lastKey]];
                }
            }
            
        }
        
        NSData *inputData = [[NSData alloc]initWithBytes:[bodyString UTF8String] length:[bodyString length]];
        [globalRequest setHTTPBody:inputData];
        
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:globalRequest
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *connectionError)
                                      {
                                          
                                          NSMutableDictionary *dic;
                                          
                                          
                                          //  //NSLog(@"recevied data string is %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                                          
                                          if (data.length > 0 && connectionError == nil)
                                          {
                                              //            //NSLog(@" data is %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                                              dic =[[NSMutableDictionary alloc]initWithDictionary: [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&connectionError]];
                                              
                                              
                                              for (NSString *keySting in dic.allKeys)
                                              {
                                                  if ([dic objectForKey:keySting] == [NSNull null])
                                                      [dic setValue:@"NA" forKey:keySting];
                                              }
                                              
                                              [self callResponseMethods:dic andMethodNumber:methodNumber];
                                          }
                                          else
                                          {
                                              [self errorHandlingMethod:response andError:connectionError andMethodNumber:methodNumber];
                                          }
                                      }];
    [datatask resume];

    
}

-(void)callResponseMethods:(NSDictionary *)dic andMethodNumber:(NSInteger)methodNumber
{
    NSDictionary *selectorsDictionary = @{@1:@"gettingHolidaysData:",@2:@"sendMembersPaymentDetails:",@3:@"sendProfileDetails:",@4:@"sendAMCPaymentDetails:",@5:@"locationsDataFromWeb:",@6:@"passDetailsofVenue:",@7:@"passDates:",@8:@"sendDetailsResorts:",@9:@"sendMemberCities:",@10:@"passLoginDetails:",@12:@"sendDataOfAllEventsData:",@13:@"sendDataBySelectedEventDetails:",@14:@"sendDataOfMemberCards:",@15:@"sendDataOfClubLogs:",@16:@"passPaymentDetails:",@17:@"sendMembershipEnquiry:",@18:@"send_EventDetailsByGivenVenue:",@19:@"send_ImageUploadDetails:",@20:@"send_KYC_Image_Status:",@21:@"send_MembershipEnquiryCitys:",@22:@"responseOfHoildayFeedBack:",@23:@"responseOfUserFeedback:",@24:@"responseOfClubFeedback:",@25:@"responseOfBookEvent:",@26:@"responseOfCancelEvent:",@27:@"responseOfReferMessage:",@28:@"responseOfReferContactDetails:",@29:@"responseOfBookedEvents:",@30:@"responseGetInfoSelectedUsedHoliday:",@31:@":",@32:@":",@33:@":"};
    
    NSString *selectorName = [selectorsDictionary objectForKey:[NSNumber numberWithInteger:methodNumber]];
    if(selectorName)
    {
        SEL currentSelector = NSSelectorFromString(selectorName);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [self performSelector:currentSelector withObject:dic];
#pragma clang diagnostic pop
    }
    
}


-(void)errorHandlingMethod:(NSURLResponse *)response andError:(NSError *)error  andMethodNumber:(NSInteger)methodNumber
{
    
    NSString *alertTitle;
    NSString *alertMessage;
    if (error)
    {
        //    //NSLog(@" Error is %@",error);
        alertTitle = [error.userInfo objectForKey:@"NSErrorFailingURLStringKey"];
        alertMessage = [NSString stringWithFormat:@"Error code:%ld  message: %@ for Domain: %@",(long)error.code,[error.userInfo valueForKey:NSLocalizedDescriptionKey] ,error.domain];
        
    }
    else
    {
        alertTitle = @"Response";
        alertMessage = [response description];
        
    }
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    
    
    [self callResponseMethods:@{Error:@0} andMethodNumber:methodNumber];
    
}


#pragma -mark- Response Delegate methods...........
#pragma mark -



-(void)sendProfileDetails:(NSDictionary *)dataDic
{
    if (dataDic)
    {
        // method number is 3
        NSMutableDictionary  *dic = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
        
        
        NSArray *keysArray = @[@"Name",@"Email",@"Mobile",@"MemShipNo"];
        NSArray *valuesArray = @[@"Name",@"email",@"mobile",@"memShipNo"];
        
        NSMutableDictionary *paydicValues = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < 4; i++)
        {
            [paydicValues setValue:[dic objectForKey:[valuesArray objectAtIndex:i]] forKey:[keysArray objectAtIndex:i]];
        }
        [[NSUserDefaults standardUserDefaults]setValue:paydicValues forKey:PayDetails];
        
        
        if ([[dic valueForKey:Error] integerValue] == 0)
        {
            
            NSArray *profileKeysArray,*memberkeys,*addressDetailsKey,*paymentArrayKeys,*profileValuesArray,*memberValuesArray,*paymentValuesArray,*addressDetailsValues;
            
            [[NSUserDefaults standardUserDefaults]setValue:dic forKey:ProfieDetails];
            //profile my key names & profile original key values
            profileKeysArray = @[@"Name",@"DOB",@"Gender",@"Email",@"Mobile",@"Image"];
            profileValuesArray = @[@"Name",@"dob",@"gender",@"email",@"mobile",@"image"];
            
            
            //member keys  and  original values
            memberkeys=@[@"Membership NO",@"Category",@"Date of Birth",@"Start Date"];
            memberValuesArray = @[@"memShipNo",@"memCat",@"dob",@"regDate"];
            
            //paymeny details and values
            paymentArrayKeys=@[@"Mem Fee",@"Sub Fee"];
            paymentValuesArray = @[@"memFee",@"subFee"];
            
            
            
            
            
            
            addressDetailsKey=@[@"address",@"city",@"state",@"country"];
            addressDetailsValues = @[@"address",@"city",@"state",@"country"];
            
            
            
            
            
            
            
            NSArray * datesArray =  @[@"dob",@"regDate"];
            //  NSArray *imagesArray = @[@"image"];
            NSMutableArray *totalKeysArray = [[NSMutableArray alloc]initWithArray: @[profileKeysArray,memberkeys,paymentArrayKeys,addressDetailsKey]];
            
            NSArray *totalValuesArray = @[profileValuesArray,memberValuesArray,paymentValuesArray,addressDetailsValues];
            
            
            NSMutableDictionary *totalDictionary = [[NSMutableDictionary alloc]initWithObjects:totalValuesArray forKeys:totalKeysArray];
            
            //        //NSLog(@"befor ModifedData %@\n\n",dic);
            
            
            
            for (id value in dic.allKeys)
            {
                NSString *opString;
                if ([value isKindOfClass:[NSString class]] && [datesArray containsObject:value])
                {
                    opString = [self DatesConvertOurFormat:[dic objectForKey:value]];
                    
                    [dic setObject:opString forKey:value];
                }
                else if([value isKindOfClass:[NSArray class]])
                {
                    NSMutableArray *currentDataArray =[[NSMutableArray alloc]initWithArray:value];
                    for (NSDictionary *currentDic in currentDataArray)
                    {
                        NSMutableDictionary *currentModifiedDic = [[NSMutableDictionary alloc]initWithDictionary:currentDic];
                        for (NSString *keyString in currentModifiedDic.allKeys)
                        {
                            if ([datesArray containsObject:keyString])
                            {
                                opString =  [self DatesConvertOurFormat:[currentDic objectForKey:keyString]];
                                [currentModifiedDic setValue:opString forKey:keyString];
                            }
                        }
                        
                        [currentDataArray replaceObjectAtIndex:[currentDataArray indexOfObject:currentDic]  withObject:currentModifiedDic];
                    }
                    [dic setValue:currentDataArray forKey:value];
                    
                }
            }
            //        //NSLog(@"after ModifedData %@",dic);
            
            
            for (NSArray *array in totalKeysArray)
            {
                NSMutableArray *dataArray =[[NSMutableArray alloc]init];
                NSArray *valuesArray =[totalDictionary objectForKey:array];
                for (NSString  *value in valuesArray)
                {
                    NSString *opString = [dic objectForKey:value];
                    if (!opString)
                        opString = @"NA";
                    else
                    {
                        
                    }
                    [dataArray addObject:opString];
                }
                [totalDictionary setObject:dataArray forKey:array];
                
            }
            
            
            
            
            NSArray *mainDicNamesForFamilyArray = @[@"spouse",@"children",@"mem_parent",@"mem_parent",@"spouse_parent",@"spouse_parent"];
            
            NSArray *familyDetails=@[@[@"SpouseName",@"DOB",@"DOM"],@[@"ChildName",@"DOB",@"Gender"],@[@"FatherName",@"DOB"],@[@"MotherName",@"DOB"],@[@"SpouseMother",@"DOB"],@[@"SpouseFather",@"DOB"]];
            
            
            NSArray *originalValuesArray =@[@[@"spouseName",@"spouseDob",@"spouseDom"],@[@"chName",@"chDoB",@"chGender"],@[@"fatherName",@"fatherDoB"],@[@"motherName",@"motherDoB"],@[@"smotherName",@"smotherDoB"],@[@"sfatherName",@"sfatherDoB"]];
            
            
            NSMutableArray *familyModifideKeys = [[NSMutableArray alloc]init];
            NSMutableArray *famliyValuesArray =[[NSMutableArray alloc]init];
            
            NSArray *dateValidationKeysArray = @[@"fatherDoB",@"motherDoB",@"spouseDob",@"spouseDom",@"smotherDoB",@"sfatherDoB",@"chDoB"];
            
            for (int i =0 ; i <mainDicNamesForFamilyArray.count ; i++)
            {
                NSString *currentName  = mainDicNamesForFamilyArray[i];
                NSArray *givenKeysArray = originalValuesArray[i];
                NSArray *myKeysArray = familyDetails[i];
                
                for (NSDictionary *currentDic in [dic objectForKey:currentName])
                {
                    NSMutableArray *myValuesArray = [NSMutableArray array];
                    for (NSString *currentKey in givenKeysArray)
                    {
                        NSString *currentValueData = currentValueData = [currentDic objectForKey:currentKey];
                        if ([dateValidationKeysArray containsObject:currentKey])
                        {
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                            //    NSDate *currentDate = [NSDate date];
                            NSDate *dateFromString ;
                            dateFromString = [dateFormatter dateFromString:currentValueData];
                            [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
                            currentValueData=[dateFormatter stringFromDate:dateFromString];
                            
                        }
                        
                        if (!currentValueData)
                            currentValueData = @"NA";
                        
                        [myValuesArray addObject:currentValueData];
                    }
                    [familyModifideKeys addObject:myKeysArray];
                    [famliyValuesArray addObject:myValuesArray];
                    
                }
                
            }
            
            
            
            NSMutableArray *memberCardsDataArray = [NSMutableArray arrayWithArray:[dataDic objectForKey:@"cards"]];
            NSMutableArray *memberCardsKeysArray = [NSMutableArray array];
            
            
            for (int i = 0; i < memberCardsDataArray.count;i++)
            {
                
                NSArray *arraysKeysArray = @[@"type",@"location",@"time",@"img"];
                [memberCardsKeysArray addObject:arraysKeysArray];
                NSDictionary *dic =[memberCardsDataArray objectAtIndex:i];
                //        //NSLog(@"clublogs dic is %@",dataDic);
                NSString *imageKey =@"img";
                NSString *imageUrl = [dic objectForKey:imageKey];
                NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
                
                imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:set];
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                
                UIImage *image;
                if (imageData)
                    image = [UIImage imageWithData:imageData];
                else
                    image = [UIImage imageNamed:@"logo-2.png"];
                
                NSMutableDictionary *curentModDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                [curentModDic setObject:image forKey:imageKey];
                [memberCardsDataArray replaceObjectAtIndex:i withObject:curentModDic];
                
            }
            
            
            [totalKeysArray insertObject:familyModifideKeys atIndex:3];
            [totalDictionary setObject:famliyValuesArray forKey:familyModifideKeys];
            
            
            [totalKeysArray addObject:memberCardsKeysArray];
            [totalDictionary setObject:memberCardsDataArray forKey:memberCardsKeysArray];
            
            
            
            
            //        //NSLog(@"total dic is %@", totalDictionary);
            
            
            NSDictionary *dic = @{kSelectorName:NSStringFromSelector(@selector(getProfileDetailsData:andKeysArray:)),kDataValues:totalDictionary,kDataKeys:totalKeysArray};
            
            [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
            
            
            //        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(getProfileDetailsData: andKeysArray:)])
            //        {
            //
            //
            //            [[self delegate] getProfileDetailsData:totalDictionary andKeysArray:totalKeysArray];
            //        }
            // [self callMethodSelectorName:<#(SEL)#> andValues:<#(id)#> andKeys:<#(id)#>]
        }
    }
    else
    {
        NSDictionary *dic = @{kSelectorName:NSStringFromSelector(@selector(getProfileDetailsData:andKeysArray:))};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
    }
    
    
    
}

-(void)sendMembersPaymentDetails:(NSDictionary *)dic
{
    // method number is 2
    
    if ([[dic valueForKey:Error] integerValue] == 0)
    {
        NSMutableDictionary *totalDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
        NSMutableArray *receptsArray = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"recpts"]];
        for (NSDictionary *currentDic in [dic objectForKey:@"recpts"])
        {
            if (![[currentDic objectForKey:@"Dr_Amt"]floatValue] && ![[currentDic objectForKey:@"cre_amount"]floatValue]  )
                [receptsArray removeObject:currentDic];
            
        }
        [totalDic setValue:receptsArray forKey:@"recpts"];
        
        
        
        //     [self performSelectorOnMainThread:<#(SEL)#> withObject:<#(id)#> waitUntilDone:<#(BOOL)#>]
        
        
        
        
        NSDictionary *dic = @{kSelectorName:NSStringFromSelector(@selector(getMemberFeeData:)),kDataValues:totalDic};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
        
        
        //        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(getMemberFeeData:)])
        //        {
        //                [[self delegate]getMemberFeeData:totalDic];
        //        }
    }
    else
    {
        //        //NSLog(@"data is %@",dic);
    }
    
}

-(void)sendAMCPaymentDetails:(NSDictionary *)dic
{
    //method number 4
    if ([[dic valueForKey:Error] integerValue] == 0)
    {
        NSMutableDictionary *totalDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
        NSMutableArray *receptsArray = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"recpts"]];
        for (NSDictionary *currentDic in [dic objectForKey:@"recpts"])
        {
            if (![[currentDic objectForKey:@"Dr_Amt"]floatValue] && ![[currentDic objectForKey:@"cre_amount"]floatValue]  )
                [receptsArray removeObject:currentDic];
            
        }
        [totalDic setValue:receptsArray forKey:@"recpts"];
        
        
        
        
        
        NSDictionary *dic = @{kSelectorName:NSStringFromSelector(@selector(getAMCFeeData:)),kDataValues:totalDic};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
        
        
        //      if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(getAMCFeeData:)])
        //        {
        //            [[self delegate]getAMCFeeData:totalDic];
        //        }
    }
    else
    {
        //        //NSLog(@"data is %@",dic);
    }
    
}
-(void)gettingHolidaysData:(NSDictionary *)dataDic
{
    // method is 1
    if (self.holidayDictionary)
    {
        
        NSString *currentSelector = NSStringFromSelector(@selector(sendHolidaysData:));
        NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues:self.holidayDictionary};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
        
        
        //        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(sendHolidaysData:)])
        //            [[self delegate] sendHolidaysData:self.holidayDictionary];
    }
    else
    {
        if ([[dataDic valueForKey:Error] integerValue] == 0)
        {
            
            
            NSString *currentSelector = NSStringFromSelector(@selector(sendHolidaysData:));
            NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues:dataDic};
            
            [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
            
            //            if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(sendHolidaysData:)])
            //            {
            //               // self.holidayDictionary = dataDic;
            //                [[self delegate] sendHolidaysData:dataDic];
            //                //NSLog(@"data is %@",dataDic);
            //            }
        }
        else
        {
            //            //NSLog(@"data is %@",dataDic);
        }
    }
    
}

- (void)LocationSepration:(NSArray *)dataArray
{
    self.allTypesOfVenuesDictionary = nil;
    self.allTypesOfVenuesDictionary = [[NSMutableDictionary alloc]init];
    self.allVenuesMutableArray = [dataArray mutableCopy];
    [self.allTypesOfVenuesDictionary setObject:self.allVenuesMutableArray forKey:@"All"];
    for (NSDictionary *dic in self.allVenuesMutableArray)
    {
        NSString *type =[dic objectForKey:@"Type"];
        NSString *typeName = [[type componentsSeparatedByString:@" "] objectAtIndex:0];
        NSMutableArray *hotels = [self.allTypesOfVenuesDictionary objectForKey:typeName];
        if (hotels)
            [hotels addObject:dic];
        else
        {
            hotels = [[NSMutableArray alloc]init];
            [self.allTypesOfVenuesDictionary setObject:hotels forKey:typeName];
        }
    }
    
    
    
    NSString *currentSelector = NSStringFromSelector(@selector(sendLocationsData:));
    NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues:_allTypesOfVenuesDictionary};
    
    [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
    
    //    if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(sendLocationsData:)])
    //    {
    //        [[self delegate] sendLocationsData:self.allTypesOfVenuesDictionary];
    //    }
    
}

-(void)locationsDataFromWeb:(NSDictionary *)dataDic
{
    // method is 5
    
    if ([[dataDic valueForKey:Error] integerValue] == 0 || self.allTypesOfVenuesDictionary)
    {
        if (dataDic.count)
        {
            [self LocationSepration:[dataDic objectForKey:@"venues"]];
            //        NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
            //        NSInvocationOperation *operation =[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadingAllImagesData:) object:dataDic];
            //            [operationQueue addOperation:operation];
        }
    }
    else
    {
        //        //NSLog(@"got error");
    }
    
    
    //-(void)sendLocationsData:(NSDictionary *)LocationsDictionary;
}

-(void)loadingAllImagesData:(NSDictionary *)dataDic
{
    
    NSArray *resortsArray = [dataDic objectForKey:@"venues"];
    //    //NSLog(@"images array %@",resortsArray);
    
    NSMutableArray *imageDatasArray = [resortsArray mutableCopy];
    for (int i = 0; i < resortsArray.count; i++)
    {
        NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithDictionary:[resortsArray objectAtIndex:i]];
        NSString *imagename = [dic objectForKey:@"img"];
        NSString *imageUrl = [LocationsImagesUrl stringByAppendingPathComponent:imagename];
        
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        
        imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:set];
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        
        UIImage *image;
        if (imageData)
            image = [UIImage imageWithData:imageData];
        else
            image = [UIImage imageNamed:@"logo-2.png"];
        
        [dic setValue:image forKeyPath:@"img"];
        [imageDatasArray replaceObjectAtIndex:i withObject:dic];
        
        
        if (i%10 == 0 || i+1 == resortsArray.count)
        {
            [self LocationSepration:imageDatasArray];
        }
        
    }
    
}



-(void)passDetailsofVenue:(NSDictionary *)dic
{
    // method number 6
    
    if ([[dic valueForKey:Error] integerValue] == 0 )
    {
        
        NSMutableDictionary *dicData = [[NSMutableDictionary alloc]initWithDictionary:dic];
        NSMutableArray *imagesArray  = [[NSMutableArray alloc]initWithArray:[dicData objectForKey:@"image"]];
        
        for (int i = 0 ; i < imagesArray.count; i++)
        {
            NSString *imagename = [[imagesArray objectAtIndex:i] objectForKey:@"img"];
            NSString *urlString = [LocationsImagesUrl stringByAppendingPathComponent:imagename];
            
            NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
            
            urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
            [imagesArray replaceObjectAtIndex:i withObject:urlString];
        }
        
        if (!imagesArray.count)
        {
            [imagesArray addObject:[UIImage imageNamed:@"defaultPadicon.png"]];
        }
        [dicData setObject:imagesArray forKey:@"image"];
        
        
        
        NSString *currentSelector = NSStringFromSelector(@selector(sendDetailsOfVenue:));
        NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues:dicData};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
        
        
        //        if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(sendDetailsOfVenue:)])
        //        {
        //            [[self delegate]sendDetailsOfVenue:dicData];
        //        }
    }
    
}
-(void)passDates:(NSDictionary *)givenDic
{
    //method number 7
    
    if ([[givenDic valueForKey:Error] integerValue] == 0 )
    {
        
        NSString *currentSelector = NSStringFromSelector(@selector(sendAvailableDates:));
        NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues:givenDic};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
        //
        //        if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(sendAvailableDates:)])
        //        {
        //            [[self delegate]sendAvailableDates:dic];
        //        }
    }
    
}


-(void)sendDetailsResorts:(NSDictionary *)dataDic
{
    // method number 8..
    
    if ([[dataDic valueForKey:Error] integerValue] == 0 || self.updatingImagesArray)
    {
        if (dataDic)
        {
            NSArray *resortsArray = [dataDic objectForKey:@"resort"];
            NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
            NSInvocationOperation *operation =[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadingImagesData:) object:dataDic];
            [operationQueue addOperation:operation];
            //        //NSLog(@"images array %@",resortsArray);
            NSMutableArray *imageDatasArray = [resortsArray mutableCopy];
            
            NSString *currentSelector = NSStringFromSelector(@selector(updatingImagesData:));
            NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues:imageDatasArray};
            
            [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
            //
            
            
            
            //        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(updatingImagesData:)])
            //        {
            //            [[self delegate] updatingImagesData:imageDatasArray];
            //            //NSLog(@"data is %@",dataDic);
            //        }
        }
        
        else
        {
            
            
            
            NSString *currentSelector = NSStringFromSelector(@selector(updatingImagesData:));
            NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues:self.updatingImagesArray};
            
            [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
            
            //        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(updatingImagesData:)])
            //        {
            //            [[self delegate] updatingImagesData:self.updatingImagesArray];
            //            //NSLog(@"data is %@",dataDic);
            //        }
            
        }
    }
    
}

-(void)loadingImagesData:(NSDictionary *)dataDic
{
    
    NSArray *resortsArray = [dataDic objectForKey:@"resort"];
    //    //NSLog(@"images array %@",resortsArray);
    
    if (!self.updatingImagesArray)
    {
        NSMutableArray *imageDatasArray = [resortsArray mutableCopy];
        for (int i = 0; i < resortsArray.count; i++)
        {
            NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithDictionary:[resortsArray objectAtIndex:i]];
            NSString *imagename = [dic objectForKey:@"image"];
            NSString *imageUrl = [ImagesUrlString stringByAppendingPathComponent:imagename];
            
            NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
            
            imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:set];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            
            UIImage *image;
            if (imageData)
                image = [UIImage imageWithData:imageData];
            else
                image = [UIImage imageNamed:@"logo-2.png"];
            
            [dic setValue:image forKeyPath:@"image"];
            [imageDatasArray replaceObjectAtIndex:i withObject:dic];
            if (i%10 == 0 || i+1 == resortsArray.count)
            {
                
                
                
                NSString *currentSelector = NSStringFromSelector(@selector(updatingImagesData:));
                NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues:imageDatasArray};
                
                [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
                
                //                if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(updatingImagesData:)])
                //                {
                //                    [[self delegate] updatingImagesData:imageDatasArray];
                //                  //  self.updatingImagesArray = [imageDatasArray mutableCopy];
                //                    //NSLog(@"data is %@",dataDic);
                //                }
            }
        }
    }
    else
    {
        
        
        NSString *currentSelector = NSStringFromSelector(@selector(updatingImagesData:));
        NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues:self.updatingImagesArray};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
        
        //        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(updatingImagesData:)])
        //        {
        //            [[self delegate] updatingImagesData:self.updatingImagesArray];
        //            //NSLog(@"data is %@",dataDic);
        //        }
    }
}

-(void)sendMemberCities:(NSDictionary *)dataDic
{
    // method number 9..
    if ([[dataDic valueForKey:Error] integerValue] == 0)
    {
        NSArray *citysdata =[dataDic objectForKey:@"city"];
        
        NSMutableArray *citysArray = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic in  citysdata)
        {
            [citysArray addObject:[dic objectForKey:@"city"]];
        }
        
        
        
        NSString *currentSelector = NSStringFromSelector(@selector(sendMemberLoginCities:));
        NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues:citysArray};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
        
        //        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(sendMemberLoginCities:)])
        //        {
        //            [[self delegate] sendMemberLoginCities:citysArray];
        //            //NSLog(@"data is %@",dataDic);
        //        }
        
    }
    
}
-(void)passLoginDetails:(NSDictionary *)dataDic
{
    // method number 10..
    
    
    if ([[dataDic valueForKey:Error] integerValue] == 0)
    {
        //        //NSLog(@"data dic %@",dataDic);
        
        [[NSUserDefaults standardUserDefaults]setObject:[dataDic objectForKey:@"apiKey"] forKey:LoginKey];
        
        self.loginDetailsDictionary = [NSMutableDictionary dictionaryWithDictionary:dataDic];
        [[NSUserDefaults standardUserDefaults]setObject:self.loginDetailsDictionary forKey:LoginDetailsDic];
        
        self.loginKey = [[NSUserDefaults standardUserDefaults]stringForKey:LoginKey];
        self.memshipnumber = [dataDic objectForKey:@"memShipNo"];
        [[NSUserDefaults standardUserDefaults]setObject:self.memshipnumber forKey:MemshipNumber];
        [[NSUserDefaults standardUserDefaults] setObject:[dataDic objectForKey:CurrentDBName] forKey:CurrentDBName];
        
        NSArray *keysArray = @[@"ccphone",@"ccemail"];
        NSMutableArray *customerDetails = [[NSMutableArray alloc]init];
        
        for (NSString *key in keysArray)
        {
            NSString *value =[dataDic objectForKey:key];
            if(value)
            {
                if ([key isEqualToString:@"ccphone"])
                {
                    value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    value= [@"+" stringByAppendingString:value];
                }
                [customerDetails addObject:value];
            }
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:customerDetails forKey:CustomerCareDetailsValues];
        //        //NSLog(@"login key is%@",self.loginKey);
        
        
    }
    else
    {
        //        //NSLog(@"error  %@",dataDic);
    }
    
    
    
    NSString *currentSelector = NSStringFromSelector(@selector(resultLoginDetails:));
    NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues: [dataDic valueForKey:Message]};
    
    [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
    
    
    
    //
    //    if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(resultLoginDetails:)])
    //    {
    //        [[self delegate] resultLoginDetails: [dataDic valueForKey:Message]];
    //        //NSLog(@"data is %@",dataDic);
    //    }
    
    
}
#pragma - mark Newly added 1.1

-(void)sendDataOfAllEventsData:(NSDictionary *)dataDic
{
    //Method numbe 12
    
    if ([[dataDic valueForKey:Error] integerValue] == 0)
    {
        
        
        
        
        NSString *currentSelector = NSStringFromSelector(@selector(getAllEventsData:));
        NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues: dataDic};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
        
        
        //    if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getAllEventsData:)])
        //            [self.delegate getAllEventsData:dataDic];
    }
    else
    {
        //        //NSLog(@"error  %@",dataDic);
    }
    
}



//-(void)loadAllEventImagesWithDictionary:(NSDictionary *)dic
//{
//    NSMutableDictionary *totalDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
//    NSMutableArray *dataArray = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"event"]];
//
//    for (int i = 0; i < dataArray.count ; i++)
//    {
//        if(isStopLoadImages)
//            break;
//
//        NSMutableDictionary *currentDic = [[NSMutableDictionary alloc]initWithDictionary:[dataArray objectAtIndex:i]];
//        NSString *imageKey =@"eventImg";
//        NSString *imageUrl = [currentDic objectForKey:imageKey];
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//
//
//             UIImage *image;
//             if (imageData)
//                 image = [UIImage imageWithData:imageData];
//
//             if (image)
//             {
//                 [currentDic setObject:image forKey:imageKey];
//                 [dataArray replaceObjectAtIndex:i withObject:currentDic];
//                 [totalDic setObject:dataArray forKey:@"event"];
//             }
//
//             if (i%10 == 0 || i == dataArray.count-1)
//             {
//                 if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getAllEventsData:)])
//                     [self.delegate getAllEventsData:totalDic];
//             }
//
//    }
//
//}




-(NSArray *)fileteringEventData:(NSString *)key Value:(NSString *)value andDic:(NSDictionary *)dic
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", value];
    NSArray *array=[[dic valueForKey:key] filteredArrayUsingPredicate:predicate];
    
    return array;
}
-(void)sendDataBySelectedEventDetails:(NSDictionary *)dataDic
{
    //method numbe 13
    
    if ([[dataDic valueForKey:Error] integerValue] == 0)
    {
        //        //NSLog(@"Event details dic is %@",dataDic);
        
        NSString *imageKey =@"eventImg";
        NSString *imageUrl = [dataDic objectForKey:imageKey];
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        
        UIImage *image;
        if (imageData)
            image = [UIImage imageWithData:imageData];
        else
        {
            image = [UIImage imageNamed:@"Eventdefault.png"];
        }
        
        
        NSMutableDictionary *curentDic = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
        [curentDic setValue:image forKey:imageKey];
        
        
        NSString *currentSelector = NSStringFromSelector(@selector(getSelectedEvent:));
        NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues: curentDic};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
        
        
        //        if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getSelectedEvent:)])
        //        {
        //            [self.delegate getSelectedEvent:curentDic];
        //        }
        
    }
    
}

-(void)sendDataOfMemberCards:(NSDictionary *)dataDic
{
    if ([[dataDic valueForKey:Error] integerValue] == 0)
    {
        NSMutableDictionary *curentDic = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
        NSMutableArray *dataArray = [[NSMutableArray alloc]initWithArray:[curentDic objectForKey:@"clogs"]];
        
        if (dataArray.count)
        {
            for (int i = 0; i < dataArray.count;i++)
            {
                NSDictionary *dic =[dataArray objectAtIndex:i];
                //            //NSLog(@"clublogs dic is %@",dataDic);
                NSString *imageKey =@"img";
                NSString *imageUrl = [dic objectForKey:imageKey];
                NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
                
                imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:set];
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                
                UIImage *image;
                if (imageData)
                    image = [UIImage imageWithData:imageData];
                else
                    image = [UIImage imageNamed:@"logo-2.png"];
                
                NSMutableDictionary *curentModDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                [curentModDic setObject:image forKey:imageKey];
                [dataArray replaceObjectAtIndex:i withObject:curentModDic];
                [curentDic setObject:dataArray forKey:@"clogs"];
                
                if ( i%10 == 0 || dataArray.count-1 == i)
                {
                    
                    
                    NSString *currentSelector = NSStringFromSelector(@selector(getMemberCards:));
                    NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues: curentDic};
                    
                    [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
                    
                    
                    //        if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getMemberCards:)])
                    //            [self.delegate getMemberCards:curentDic];
                }
            }
        }
        else
        {
            //            if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getMemberCards:)])
            //                [self.delegate getMemberCards:curentDic];
            
            NSString *currentSelector = NSStringFromSelector(@selector(getMemberCards:));
            NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues: curentDic};
            
            [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
            
        }
        
    }
    else
    {
        //        //NSLog(@"Error is %@",[dataDic objectForKey:Message]);
        
        
        NSString *currentSelector = NSStringFromSelector(@selector(getMemberCards:));
        NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues: @{@"clogs":@[],Message:[dataDic objectForKey:Message]}};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
        
        //        if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getMemberCards:)])
        //            [self.delegate getMemberCards:@{@"clogs":@[],Message:[dataDic objectForKey:Message]}];
        
        
    }
}
-(void)sendDataOfClubLogs:(NSDictionary *)dataDic
{
    if ([[dataDic valueForKey:Error] integerValue] == 0)
    {
        NSMutableDictionary *curentDic = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
        NSMutableArray *dataArray = [[NSMutableArray alloc]initWithArray:[curentDic objectForKey:@"clogs"]];
        //        //NSLog(@"data Array %@",dataArray);
        
        if (dataArray.count)
        {
            for (int i = 0; i < dataArray.count;i++)
            {
                NSDictionary *dic =[dataArray objectAtIndex:i];
                //        //NSLog(@"clublogs dic is %@",dic);
                NSString *imageKey =@"img";
                NSString *imageUrl = [dic objectForKey:imageKey];
                
                NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
                
                imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:set];
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                
                UIImage *image;
                if (imageData)
                    image = [UIImage imageWithData:imageData];
                else
                    image = [UIImage imageNamed:@"logo-2.png"];
                
                NSMutableDictionary *curentModDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                // int i =[dataArray indexOfObject:dic];
                [curentModDic setObject:image forKey:imageKey];
                [dataArray replaceObjectAtIndex:i withObject:curentModDic];
                [curentDic setObject:dataArray forKey:@"clogs"];
                
                if ( i%10 == 0 || dataArray.count-1 == i)
                {
                    
                    NSString *currentSelector = NSStringFromSelector(@selector(getClubLogs:));
                    NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues: curentDic};
                    
                    [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
                    
                    //                if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getClubLogs:)])
                    //                    [self.delegate getClubLogs:curentDic];
                }
                
            }
        }
        else
        {
            
            NSString *currentSelector = NSStringFromSelector(@selector(getClubLogs:));
            NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues: curentDic};
            
            [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
            
            //            if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getClubLogs:)])
            //                [self.delegate getClubLogs:curentDic];
        }
        
    }
    else
    {
        //        //NSLog(@"Error is %@",[dataDic objectForKey:Message]);
        
        
        
        NSString *currentSelector = NSStringFromSelector(@selector(getClubLogs:));
        NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues: @{@"clogs":@[],Message:[dataDic objectForKey:Message]}};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
        
        //        if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getClubLogs:)])
        //            [self.delegate getClubLogs:@{@"clogs":@[],Message:[dataDic objectForKey:Message]}];
        
    }
    
}
-(void)sendDataOfOfflinePayment:(NSDictionary *)dataDic
{
    // Method number 17
    
    if ([[dataDic valueForKey:Error] integerValue] == 0)
    {
        //        //NSLog(@"payment dic is %@",dataDic);
        
        NSString *currentSelector = NSStringFromSelector(@selector(getOfflinePayments:));
        NSDictionary *dic = @{kSelectorName:currentSelector,kDataValues:dataDic};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:dic waitUntilDone:YES];
        
        
        //        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(getOfflinePayments:)])
        //        {
        //            [self.delegate getOfflinePayments:dataDic];
        //        }
    }
    else
    {
        //        //NSLog(@"error message is %@",[dataDic objectForKey:Message]);
    }
}


-(void)sendMembershipEnquiry:(NSDictionary *)dic
{
    if ([[dic valueForKey:Error] integerValue] == 0)
    {
        //        //NSLog(@"payment dic is %@",dic);
        
        
        
        
        
        NSString *currentSelector = NSStringFromSelector(@selector(getStatusOfMembershipEnquiry:));
        NSDictionary *currentDic = @{kSelectorName:currentSelector,kDataValues:[dic objectForKey:@"Message"]};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:currentDic waitUntilDone:YES];
        
        //        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(getStatusOfMembershipEnquiry:)])
        //        {
        //            [self.delegate getStatusOfMembershipEnquiry:[dic objectForKey:@"Message"]];
        //        }
    }
    else
    {
        //        //NSLog(@"error message is %@",[dic objectForKey:Message]);
    }
    
}
-(void)send_EventDetailsByGivenVenue:(NSDictionary *)dic
{
    if ([[dic valueForKey:Error] integerValue] == 0)
    {
        //        //NSLog(@"payment dic is %@",dic);
        
        
        
        NSString *currentSelector = NSStringFromSelector(@selector(getEventDetailsOfSelectedVenue:));
        NSDictionary *currentDic = @{kSelectorName:currentSelector,kDataValues:dic};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:currentDic waitUntilDone:YES];
        //
        
        //        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(getEventDetailsOfSelectedVenue:)])
        //        {
        //            [self.delegate getEventDetailsOfSelectedVenue:dic];
        //        }
    }
    else
    {
        //        //NSLog(@"error message is %@",[dic objectForKey:Message]);
    }
    
}
-(void)send_MembershipEnquiryCitys:(NSDictionary *)dataDic
{
    if ([[dataDic valueForKey:Error] integerValue] == 0)
    {
        NSArray *citysdata =[dataDic objectForKey:@"city"];
        
        NSMutableArray *citysArray = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic in  citysdata)
        {
            [citysArray addObject:[dic objectForKey:@"city"]];
        }
        
        
        
        NSString *currentSelector = NSStringFromSelector(@selector(getCitysOfMembershipEnquiry:));
        
        NSDictionary *currentDic = @{kSelectorName:currentSelector,kDataValues:citysArray};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:currentDic waitUntilDone:YES];
        
        //        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(getCitysOfMembershipEnquiry:)])
        //        {
        //            [[self delegate] getCitysOfMembershipEnquiry:citysArray];
        //            //NSLog(@"data is %@",dataDic);
        //        }
        //
    }
    else
    {
        //        //NSLog(@"error %@",[dataDic objectForKey:Error]);
    }
}

#pragma -mark - payment data details
#pragma mark -
//on of dataDic:
//{
//    Name = Test;
//    dob = "2007-08-01";
//    email = "akhil@gmail.com";
//    error = 0;
//    gender = female;
//    memCat = "Kool  Global(Dubai Club + 30Yrs 6N7D St U12)";
//    memFee = 2400;
//    memShipNo = CVOM230LKG1556;
//    mobile = 9951270433;
//    regDate = "2012-08-18";
//    subFee = 80;
//}

-(void)paymentDetails:(NSString *)productInfo andAmount:(CGFloat)amount andCurrencyType:(NSString *)currencyType andDic:(NSDictionary *)dataDic
{
    
    NSDictionary *profileDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:ProfieDetails];
    
    if (dataDic)
        self.bookingHolidayData = dataDic;
    
    
    //   amount = 0.10;
    NSArray *keysArray = @[@"Name",@"email",@"mobile"];
    
    NSArray *setKeysForCurrentBodyValuesArray =@[@"firstname",@"email",@"phone",@"amount",@"productinfo"];
    
    
    globalRequest = [[NSMutableURLRequest alloc]init];
    presentUrlString =HashKeyGenrationURL;
    globalUrl = [NSURL URLWithString:presentUrlString];
    [globalRequest setURL:globalUrl];
    [globalRequest setHTTPMethod:MethodType_POST];   //passing method type
    [globalRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSMutableString *bodyString = [[NSMutableString alloc]init];
    
    
    
    for (int i = 0; i < keysArray.count ;i ++)
    {
        NSString *key = [keysArray objectAtIndex:i];
        NSString *data = [profileDic objectForKey:key];
        [bodyString appendFormat:@"%@=%@&",[setKeysForCurrentBodyValuesArray objectAtIndex:i],data];
    }
    
    [bodyString appendFormat:@"%@=%f&",[setKeysForCurrentBodyValuesArray objectAtIndex:3],amount];
    [bodyString appendFormat:@"%@=%@&",[setKeysForCurrentBodyValuesArray objectAtIndex:4],productInfo];
    //NSString *str=@"INR";
    [bodyString appendFormat:@"currency_type=%@",currencyType];
    NSData *inputData = [[NSData alloc]initWithBytes:[bodyString UTF8String] length:[bodyString length]];
    [globalRequest setHTTPBody:inputData];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:globalRequest
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *connectionError) {
                                          
                                          NSDictionary *dic;
                                          
                                          if (data.length > 0 && connectionError == nil)
                                          {
                                              dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&connectionError];
                                              
                                          }
                                          else if(data.length  == 0)
                                          {
                                          }
                                          
                                          if (!dic)
                                          {
                                              dic = @{Error:@1,Message:connectionError};
                                          }
                                          [self passPaymentDetails:dic];
                                      }];
    
    [datatask resume];
    
}

-(void)passPaymentDetails:(NSDictionary *)dic
{
    if ([[dic objectForKey:Error] intValue] == 0)
    {
        NSArray *keysList =@[@"key",@"txnid",@"amount",@"productinfo",@"firstname",@"email",@"mobile",@"surl",@"furl",@"hash",@"udf1",@"udf4"];
        NSMutableString *passwebString = [[NSMutableString alloc]init];
        txnid =[dic objectForKey:@"txnid"] ;
        //        [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"txnid"] forKey:@"Txnid"];
        for (NSString *key in keysList)
        {
            [passwebString appendFormat:@"%@=%@&",key,[dic objectForKey:key]];
        }
        //        //NSLog(@"txr id is %@",[dic objectForKey:@"txnid"]);
        
        
        
        
        NSString *currentSelector = NSStringFromSelector(@selector(sendPaymentDetails:));
        NSDictionary *currentDic = @{kSelectorName:currentSelector,kDataValues:passwebString};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:currentDic waitUntilDone:YES];
        
        
        //        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sendPaymentDetails:)])
        //        {
        //            [[self delegate]sendPaymentDetails:passwebString];
        //        }
        
    }
    else
    {
        //        //NSLog(@" error is %@", [NSString stringWithFormat:@"%@",[dic objectForKey:Error]]);
    }
    
}

-(void)detailsOfPayment
{
    globalRequest = [[NSMutableURLRequest alloc]init];
    presentUrlString =[PaymentMainUrl stringByAppendingPathComponent:PaymentResponse];
    globalUrl = [NSURL URLWithString:presentUrlString];
    [globalRequest setURL:globalUrl];
    [globalRequest setHTTPMethod:MethodType_POST];   //passing method type
    [globalRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSMutableString *bodyString = [[NSMutableString alloc]init];
    [bodyString appendFormat:@"trxid=%@",txnid];
    
    NSData *inputData = [[NSData alloc]initWithBytes:[bodyString UTF8String] length:[bodyString length]];
    [globalRequest setHTTPBody:inputData];
    
    
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:globalRequest
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *connectionError)
                                      
                                      
                                      {
                                          NSDictionary *dic;
                                          
                                          if (data.length > 0 && connectionError == nil)
                                          {
                                              dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&connectionError];
                                              
                                              
                                              NSString *currentSelector = NSStringFromSelector(@selector(paymentResponseDic:));
                                              NSDictionary *currentDic = @{kSelectorName:currentSelector,kDataValues:dic};
                                              
                                              [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:currentDic waitUntilDone:YES];
                                              
                                              
                                              //             if (self.delegate != nil && [self.delegate respondsToSelector:@selector(paymentResponseDic:)])
                                              //             {
                                              //                 [[self delegate]paymentResponseDic:dic];
                                              //             }
                                              
                                              
                                          }
                                          else if(data.length  == 0)
                                          {
                                              //             //NSLog(@"data not download");
                                          }
                                          
                                          
                                      }];
    
    [datatask resume];
    
}


-(NSDictionary *)getusedDetails:(NSString*)hid
{
    
    // memno=@"CVBG1BGCLUB30LW168720";
    NSDictionary *dataDic = [self sendSynchronousUrlRequest:UsedHolidays andMethodType:MethodType_POST HeaderFiledAuthorization:Authorization_YES andBody:@{@"hid":hid,@"memno":self.memshipnumber}];
    
    if ([[dataDic valueForKey:Error] integerValue] == 0)
    {
        //        //NSLog(@"data %@",dataDic);
        return dataDic;
    }
    else
    {
        return 0;
    }
    
}

-(NSDictionary *)sentDataToServer:(id)receiveData
{
    NSArray *payArray;
    
    if ([receiveData isKindOfClass:[NSMutableArray class]] || [receiveData isKindOfClass:[NSArray class]])
        payArray = receiveData;
    else
        self.bookingHolidayData = receiveData;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *serverDataDictionary = [[NSMutableDictionary alloc]init];
    NSArray *serverKeys = @[@"mode",@"mihpayid",@"txnid",@"PG_TYPE",@"productinfo",@"amount"];
    
    
    for (NSString *dataObject in payArray)
    {
        NSArray *currentObjectArray = [dataObject componentsSeparatedByString:@"="];
        [dic setValue:currentObjectArray.lastObject forKey:currentObjectArray.firstObject];
    }
    
    NSString*endurlString ;
    for (NSString *key in serverKeys)
    {
        if ([dic objectForKey:key])
            [serverDataDictionary setValue:[dic objectForKey:key] forKey:key];
        else
            [serverDataDictionary setValue:@"NA" forKey:key];
    }
    
    [serverDataDictionary setObject:[serverDataDictionary objectForKey:@"mode"] forKey:@"bankcode"];
    [serverDataDictionary removeObjectForKey:@"mode"];
    
    
    
    if ([[dic objectForKey:@"productinfo"] isEqualToString:@"holidays"] ||[receiveData isKindOfClass:[NSDictionary class]] )
    {
        endurlString = PostHolidayDataToServer;
        [serverDataDictionary addEntriesFromDictionary:self.bookingHolidayData];
    }
    else
    {
        endurlString = PostAMCAndMFeeDataToServer;
    }
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString *addonDate = [dic objectForKey:@"addedon"];
    if (addonDate)
        addonDate = [[addonDate componentsSeparatedByString:@"+"] objectAtIndex:0];
    else
        addonDate =dateString;
    [serverDataDictionary setValue:addonDate forKey:@"addedOn"];
    
    
    [self sendAsynchronousUrlRequest:endurlString andMethodType:MethodType_POST HeaderFiledAuthorization:YES andBody:serverDataDictionary  andMethodNumber:11];
    // //NSLog(@"data is %@",responseDic);
    
    NSArray *keysArray,*originalKeys;
    if (serverDataDictionary.allKeys.count >= 7)
    {
        keysArray=@[@"BankCode",@"MihPayId",@"Txnid",@"Pg_Type",@"Productinfo",@"Amount",@"AddedOn",@"Amc Due",@"MemberFee Due",@"Adults",@"Children",@"Holiday Length",@"Holiday Id",@"Resort Id",@"Check-In",@"Check-Out"];
        originalKeys = @[@"bankcode",@"mihpayid",@"txnid",@"PG_TYPE",@"productinfo",@"amount",@"addedOn",@"amcDue",@"mfDue",@"noAdult",@"noChild",@"hldLgth",@"hid",@"rid",@"chkin",@"chkout"];
    }
    else
    {
        keysArray=@[@"BankCode",@"MihPayId",@"Txnid",@"Pg_Type",@"Productinfo",@"Amount",@"AddedOn"];
        originalKeys = @[@"bankcode",@"mihpayid",@"txnid",@"PG_TYPE",@"productinfo",@"amount",@"addedOn"];
    }
    
    for (int i = 0; i < keysArray.count ; i++)
    {
        NSString *keyString = [originalKeys objectAtIndex:i];
        NSString *value = [serverDataDictionary objectForKey:keyString];
        [serverDataDictionary removeObjectForKey:keyString];
        [serverDataDictionary setValue:value forKey:[keysArray objectAtIndex:i]];
        
    }
    
    return @{keysArray:serverDataDictionary};
}

-(NSDictionary *)sendToServerOffPaymentData:(id)receiveData
{
    //bankcode,mihpayid,txnid,PG_TYPE,productinfo,amount,addedOn,name,mo bile,email,curncy,payBelt,paidAmt
    
    
    NSArray *payArray;
    
    if (receiveData)
    {
        if ([receiveData isKindOfClass:[NSMutableArray class]] || [receiveData isKindOfClass:[NSArray class]])
            payArray = receiveData;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *serverDataDictionary = [[NSMutableDictionary alloc]init];
        NSArray *serverKeys = @[@"mihpayid",@"txnid",@"PG_TYPE",@"productinfo",@"firstname",@"amount",@"bankcode",@"email"];
        
        
        for (NSString *dataObject in payArray)
        {
            NSArray *currentObjectArray = [dataObject componentsSeparatedByString:@"="];
            [dic setValue:currentObjectArray.lastObject forKey:currentObjectArray.firstObject];
        }
        
        
        for (NSString *key in serverKeys)
        {
            if ([dic objectForKey:key])
                [serverDataDictionary setValue:[dic objectForKey:key] forKey:key];
            else
                [serverDataDictionary setValue:@"NA" forKey:key];
        }
        [serverDataDictionary setObject:[self.offlinePaymentDic objectForKey:@"email"] forKey:@"email"];
        [serverDataDictionary setObject:[self.offlinePaymentDic objectForKey:@"phone"] forKey:@"mobile"];
        [serverDataDictionary setObject:[self.offlinePaymentDic objectForKey:@"currency_type"] forKey:@"curncy"];
        [serverDataDictionary setObject:@"Dont know" forKey:@"payBelt"];
        
        [serverDataDictionary setObject:[dic objectForKey:@"mode"] forKey:@"bankcode"];
        [serverDataDictionary setObject:[serverDataDictionary objectForKey:@"firstname"] forKey:@"name"];
        [serverDataDictionary removeObjectForKey:@"firstname"];
        [serverDataDictionary setObject:[serverDataDictionary objectForKey:@"amount"] forKey:@"paidAmt"];
        
        
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        
        NSString *addonDate = [dic objectForKey:@"addedon"];
        if (addonDate)
            addonDate = [[addonDate componentsSeparatedByString:@"+"] objectAtIndex:0];
        else
            addonDate =dateString;
        [serverDataDictionary setValue:addonDate forKey:@"addedOn"];
        
        NSDictionary *responseDic = [self sendSynchronousUrlRequest:OfflinePayment andMethodType:MethodType_POST HeaderFiledAuthorization:Authorization_NO andBody:serverDataDictionary];
        
        [serverDataDictionary addEntriesFromDictionary:responseDic];
        [serverDataDictionary setObject:[dic objectForKey:@"udf4"] forKey:@"membershipno"];
        return serverDataDictionary;
    }
    return @{@"Message":@"Error"};
}

#pragma mark - Date Modification And ImageLoading
#pragma mark -
-(NSString *)DatesConvertOurFormat:(NSString *)givenDateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    NSDate *currentDate = [NSDate date];
    NSDate *dateFromString ;
    dateFromString = [dateFormatter dateFromString:givenDateString];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSString  *opString=[dateFormatter stringFromDate:dateFromString];
    if (!opString)
        opString = @"NA";
    
    return opString;
}

#pragma mark - KYC Methods

-(void)imageUpload:(UIImage *)givenImage andFileName:(NSString *)fileName andImageTypeTitle:(NSString *)typeTitle andImageParameter:(NSString *)parameterKey andUrlString:(NSURL *)ImageUploadUrl
{
    
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = parameterKey;
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    //  NSURL* requestURL = [NSURL URLWithString:@"http://localhost:8888/upload_file.php"];
    
    //NSURL* requestURL = [NSURL URLWithString:@"http://countryclubworld.com/akhilapp/ccapp/fileUpload1.php"];
    NSURL* requestURL = ImageUploadUrl;
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    
    // UIImage *image = [UIImage imageNamed:@"logo.png"];
    // add image data
    //  NSData *imageData = UIImageJPEGRepresentation(givenImage, 1.0);
    NSData *imageData = UIImagePNGRepresentation(givenImage);
    
    if (imageData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", FileParamConstant,fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    // set URL
    [request setURL:requestURL];
    
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //    //NSLog(@"%@",returnString );
    
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *connectionError)
                                      {  NSMutableDictionary *dic;
                                          
                                          if (data.length > 0 && connectionError == nil)
                                          {
                                              dic =[[NSMutableDictionary alloc]initWithDictionary: [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&connectionError]];
                                              
                                              
                                              for (NSString *keySting in dic.allKeys)
                                              {
                                                  if ([dic objectForKey:keySting] == [NSNull null])
                                                      [dic setValue:@"NA" forKey:keySting];
                                              }
                                              
                                          }
                                          
                                          if (!dic)
                                          {
                                              dic = [[NSMutableDictionary alloc]initWithDictionary:@{Error:@1,Message:connectionError}];
                                          }
                                          
                                          
                                          if ([[dic valueForKey:Error] integerValue] == 0)
                                          {
                                              
                                              //                //NSLog(@"payment dic is %@",dic);
                                              [self KYC_uploadImageDetais:[dic objectForKey:@"file_name"] andandTitle:typeTitle];
                                          }
                                          else
                                          {
                                              //                //NSLog(@"error message is %@",[dic objectForKey:Message]);
                                              
                                              NSString *currentSelector = NSStringFromSelector(@selector(send_KYC_uploadImageDetais:));
                                              NSDictionary *currentDic = @{kSelectorName:currentSelector,kDataValues:[dic objectForKey:Message]};
                                              
                                              [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:currentDic waitUntilDone:YES];
                                              
                                              // [self.delegate send_KYC_uploadImageDetais:[dic objectForKey:Message]];
                                          }
                                          
                                      }];
    
    [datatask resume];
    
    
}
-(void)send_ImageUploadDetails:(NSDictionary *)dic
{
    if ([[dic valueForKey:Error] integerValue] == 0)
    {
        //        //NSLog(@"payment dic is %@",dic);
        
        
        
        NSString *currentSelector = NSStringFromSelector(@selector(send_KYC_uploadImageDetais:));
        NSDictionary *currentDic = @{kSelectorName:currentSelector,kDataValues:[dic objectForKey:Message]};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:currentDic waitUntilDone:YES];
        
        //        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(send_KYC_uploadImageDetais:)])
        //        {
        //            [self.delegate send_KYC_uploadImageDetais:[dic objectForKey:@"message"]];
        //        }
    }
    else
    {
        //        //NSLog(@"error message is %@",[dic objectForKey:Message]);
    }
    
}

-(void)send_KYC_Image_Status:(NSDictionary *)dic
{
    if ([[dic valueForKey:Error] boolValue] == false)
    {
        //        //NSLog(@"payment dic is %@",dic);
        
        
        NSString *currentSelector = NSStringFromSelector(@selector(send_KYC_Image_StatusDetails:));
        NSDictionary *currentDic = @{kSelectorName:currentSelector,kDataValues:dic};
        
        [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:currentDic waitUntilDone:YES];
        
        
        //        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(send_KYC_Image_StatusDetails:)])
        //        {
        //            [self.delegate send_KYC_Image_StatusDetails:dic];
        //        }
    }
    else
    {
        //        //NSLog(@"error message is %@",[dic objectForKey:Message]);
    }
    
}

#pragma mark -
//MARK: 1.3 features
#pragma mark -

//MRAK:1.3 verision

-(void)responseOfHoildayFeedBack:(NSDictionary *)dic
{
    
    //method 22
    
    NSString *currentSelector = NSStringFromSelector(@selector(countyClubModel_ResponseOfHoildayFeedBack:));
    NSDictionary *selectorDic = @{kSelectorName:currentSelector,kDataValues:dic};
    
    [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:selectorDic waitUntilDone:YES];
    
    
}
-(void)responseOfUserFeedback:(NSDictionary *)dic
{
    //method 23
    //  NSString *currentSelector = NSStringFromSelector(@selector(countyClubModel_ResponseOfUserFeedback:));
    //  NSDictionary *selectorDic = @{kSelectorName:currentSelector,kDataValues:dic};
    //  
    [[NSNotificationCenter defaultCenter]postNotificationName:kUserFeedbackNotification object:dic];
    
    //  [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:selectorDic waitUntilDone:YES];
    
    
    
}
-(void)responseOfClubFeedback :(NSDictionary *)dic
{
    //method 24
    NSString *currentSelector = NSStringFromSelector(@selector(countyClubModel_ResponseOfClubFeedback:));
    NSDictionary *selectorDic = @{kSelectorName:currentSelector,kDataValues:dic};
    
    [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:selectorDic waitUntilDone:YES];
    
}
-(void)responseOfBookEvent:(NSDictionary *)dic
{
    //method 25
    NSString *currentSelector = NSStringFromSelector(@selector(countyClubModel_ResponseOfBookEvent:));
    NSDictionary *selectorDic = @{kSelectorName:currentSelector,kDataValues:dic};
    
    [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:selectorDic waitUntilDone:YES];
    
}

-(void)responseOfCancelEvent:(NSDictionary *)dic
{
    //method 26
    NSString *currentSelector = NSStringFromSelector(@selector(countyClubModel_ResponseOfCancelEvent:));
    NSDictionary *selectorDic = @{kSelectorName:currentSelector,kDataValues:dic};
    
    [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:selectorDic waitUntilDone:YES];
    
    
}
-(void)responseOfReferMessage:(NSDictionary *)dic
{
    //method 27
    NSString *currentSelector = NSStringFromSelector(@selector(countyClubModel_ResponseOfReferMessage:));
    NSDictionary *selectorDic = @{kSelectorName:currentSelector,kDataValues:dic};
    
    [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:selectorDic waitUntilDone:YES];
    
    
    
}
-(void)responseOfReferContactDetails:(NSDictionary *)dic
{
    //method 28
    NSString *currentSelector = NSStringFromSelector(@selector(countyClubModel_ResponseOfReferContactDetails:));
    NSDictionary *selectorDic = @{kSelectorName:currentSelector,kDataValues:dic};
    
    [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:selectorDic waitUntilDone:YES];
    
    
}
-(void)responseOfBookedEvents:(NSDictionary *)dic
{
    //method 29
    NSString *currentSelector = NSStringFromSelector(@selector(countyClubModel_ResponseOfBookedEvents:));
    NSDictionary *selectorDic = @{kSelectorName:currentSelector,kDataValues:dic};
    
    [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:selectorDic waitUntilDone:YES];
    
    
}
-(void)responseGetInfoSelectedUsedHoliday:(NSDictionary *)dic
{
    //method 30
    NSString *currentSelector = NSStringFromSelector(@selector(countyClubModel_ResponseGetInfoSelectedUsedHoliday:));
    NSDictionary *selectorDic = @{kSelectorName:currentSelector,kDataValues:dic};
    
    [self performSelectorOnMainThread:@selector(callDelegateMethods:) withObject:selectorDic waitUntilDone:YES];
    
}



@end
