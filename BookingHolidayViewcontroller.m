//
//  BookingHolidayViewcontroller.m
//  CountryClub
//
//  Created by atsmacmini4 on 4/16/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import "BookingHolidayViewcontroller.h"
#import "UITextField+CustomInputViews.h"
//#import "BookingDetailsViewController.h"
#import "MBProgressHUD.h"
@interface BookingHolidayViewcontroller ()<MBProgressHUDDelegate,UITextViewDelegate,UIActionSheetDelegate>
{
    UITextField *currentTextFiled;
    int c;
    NSInteger d;
    UILabel *Navlbl,*lbl,*lbl1;
    MBProgressHUD *hud;
    UIView *captureView,*GenralFeedbackView,*btnsView;
    UITextView *messageTextview,*subjectTextview;
    int feedbackViewStatus,daysint;
}
//@property (weak, nonatomic) IBOutlet UILabel *roomLbl;
@property(nonatomic,strong)IBOutlet UILabel *hotelNameLabel;
@property (nonatomic,strong) NSDictionary *datesDic;
@property (nonatomic,strong) NSMutableArray *datesArray,*holidaylenghtArray,*possiblehlydays,*mainPickerArray;
//@property(nonatomic,strong)IBOutlet UILabel *checkkinLbl,*checkoutLbl,*adultsLbl,*childLbl;

@end

@implementation BookingHolidayViewcontroller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSMutableArray*)calculatehlydays:(NSString*)Hlylen{
    int d11;
    NSMutableArray *hlydayslen=[[NSMutableArray alloc]init];
    char d1=[self.hldyLength characterAtIndex:0];
    int days=[[NSString stringWithFormat:@"%c", d1] intValue];
    if ([self.city isEqualToString:@"Philippines"]) {
         [hlydayslen addObject:@"2 Nights 3 Days"];
         [hlydayslen addObject:@"3 Nights 4 Days"];
    }
    else if ([self.city isEqualToString:@"Dubai"]){
         [hlydayslen addObject:@"2 Nights 3 Days"];
        
    }
     else if ([self.type isEqualToString:@"no"]) {
        int d111= days>4?4:days;
        for (int i=2; i<d111+1; i++) {
            d11=i+1;
            
            [hlydayslen addObject:[NSString stringWithFormat:@"%d Nights %d Days",i,d11]];
        }
        
        
    }
    else{
        for (int i=2; i<days+1; i++) {
            d11=i+1;
            
            [hlydayslen addObject:[NSString stringWithFormat:@"%d Nights %d Days",i,d11]];
        }
    }

    return hlydayslen;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
    font=[UIFont fontWithName:@"Avenir Heavy" size:17.0];
      font1=[UIFont fontWithName:@"Avenir Heavy" size:20.0];
    app= (AppDelegate*)[[UIApplication sharedApplication]delegate];
    Navlbl=[[UILabel alloc]init];
    
       if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
        Navlbl.frame=CGRectMake(184, 3, 400, 40);
    }
    else{
        Navlbl=[[UILabel alloc]init];
        if (app.window.frame.size.width>380) {
            Navlbl.frame=CGRectMake(130, 2, 150, 40);
        }
        else if (app.window.frame.size.width>320){
            Navlbl.frame=CGRectMake(110, 2, 150, 40);
            
        }
        else{
            Navlbl.frame=CGRectMake(85, 2, 150, 40);
        }
    }
    Navlbl.textAlignment=NSTextAlignmentCenter;
    Navlbl.textColor=[UIColor whiteColor];
    Navlbl.backgroundColor=[UIColor clearColor];
    [self.navigationController.navigationBar addSubview:Navlbl];
    Navlbl.text=@"Booking Details";

#pragma -mark changelabelframes for ios 6
    reqSysVer = @"6.2";
    currSysVer = [[UIDevice currentDevice] systemVersion];
    
    self.hotelNameLabel.text = self.resortName;
   //   self.hotelNameLabel.adjustsFontSizeToFitWidth=YES;
    self.cityLbl.adjustsFontSizeToFitWidth=YES;
    self.roomLbl.adjustsFontSizeToFitWidth=YES;
    self.hotelNameLabel.adjustsFontSizeToFitWidth=YES;
    self.hotelNameLabel.numberOfLines=2;
    self.cityLbl.text = self.city;
    self.label_infodates.hidden=YES;
    self.possiblehlydays=[self calculatehlydays:self.hldyLength];
    
    self.datesArray = [[NSMutableArray alloc]init];
    self.mainPickerArray=[[NSMutableArray alloc]init];
    [self.mainPickerArray addObject:self.possiblehlydays];
    
 

    for (int i = 200; i <= 205;i++)
    {
        
        currentTextFiled = (UITextField *)[self.view viewWithTag:i];
        [currentTextFiled AddCustomToolBarAndStartTextFiledTag:200 andEndFieldTag:201];
      

        currentTextFiled = (UITextField *)[self.view viewWithTag:i];
        if (i==200||i==203|| i == 202||i==204||i==205) {
            
        }
        else{
         [currentTextFiled changeInputViewAsPickerView:[self.mainPickerArray objectAtIndex:d]];
        
        d++;
        }
    }
    
    if([self.roomtype isEqualToString:@"superior"])
    {
        [self.mainPickerArray addObject:@[@"Studio",@"Superior"]];
        [self.roomtypeTextfield changeInputViewAsPickerView:(NSMutableArray *)@[@"Studio",@"Superior"]];
    }
    else
    {
        self.roomtypeTextfield.hidden=YES;
        self.roomLbl.text= @"Studio";
        
        self.roomtypeTextfield.text = @"Studio";
        
    }
    [self.holidayslength changeInputViewAsPickerView:self.possiblehlydays];
    self.checkIn.hidden=YES;
    _label_static.hidden=YES;
   
   
    self.hotelNameLabel.font=[UIFont fontWithName:@"Avenir Heavy" size:18.0];
    self.cityLbl.font=[UIFont fontWithName:@"Avenir Heavy" size:15.0];
   
    self.roomLbl.font=[UIFont fontWithName:@"Avenir Heavy" size:15.0];
    self.roomtypeTextfield.font=font;
    self.checkIn.font=font;
   
        // Do any additional setup after loading the view from its nib.
}
-(void)viewWillDisappear:(BOOL)animated{
    
    Navlbl.hidden=YES;
    [super viewWillDisappear:YES];

}
-(void)viewWillAppear:(BOOL)animated{
    
    Navlbl.hidden=NO;
    [super viewWillAppear:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark Textfield Delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==202) {
        [currentTextFiled AddCustomToolBarAndStartTextFiledTag:200 andEndFieldTag:202];
 
    }
        [textField myTextFieldDidBeginEditing:textField];
   
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
        
    [textField myTextFieldDidEndEditing:textField];
    
    if (currentTextFiled.tag==202)
    {
        
//        self.label_infodates.backgroundColor=[UIColor brownColor];
//        self.label_infodates.text=currentTextFiled.text;
//        self.label_infodates.text=self.checkIn.text;

    }
    
    if (textField.tag == 200||textField.tag==201)
    {
        if ([self.holidayslength.text length]>0&&[_roomtypeTextfield.text length]>0)
        {
            
            
 //   NSDictionary *dic=@{@"resortid":self.rid,@"rtype":_roomtypeTextfield.text,@"city":self.city,@"hid":self.hid2};
            //NSLog(@"resort dic is %@ ",dic);
            app.countryClub.delegate=self;
            self.checkIn.text=nil;
            [self getDates];
            
            
       //  [app.countryClub getAvailableDates:dic];
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"Loading...";
          
        }
       
    }
    
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag==202)
    {
        
        
        if ([UIScreen mainScreen].bounds.size.height>300)
        {
            
            _label_infodates.frame=CGRectMake(0, _label_infodates.frame.origin.y, self.view.frame.size.width,40);
            
            _label_static.frame=CGRectMake(0, CGRectGetMaxY(_label_infodates.frame), self.view.frame.size.width, self.view.frame.size.height/5);
            _label_static.numberOfLines=4;
            _label_static.adjustsFontSizeToFitWidth=YES;
            _label_static.font=[UIFont fontWithName:@"Helvetica" size:12];
            _label_static.textAlignment=NSTextAlignmentCenter;
            [self.view addSubview:_label_infodates];
            
        }
        
        self.label_infodates.hidden=NO;
        self.label_static.hidden=NO;
        self.label_infodates.backgroundColor=[UIColor lightGrayColor];
       
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        
        NSDate *selectdate=[dateFormatter dateFromString:self.checkIn.text];
        
        char d1=[self.holidayslength.text characterAtIndex:0];
        int days=[[NSString stringWithFormat:@"%c", d1] intValue];
        NSDate *newDate1 = [selectdate dateByAddingTimeInterval:60*60*24*days];
        NSString *str = [dateFormatter stringFromDate:newDate1];
        
        self.label_infodates.text=str;
        
        
    }

    return YES;
}
#define myurl2 @"http://www.countryclubworld.com/akhilapp/ccapp/index_v1.php/EmployeecheckResortsDates"

-(void)getDates
{
    
       [_gAppDelegate showLoadingView:YES activityTitle:@"Loading"];
    
    NSMutableDictionary *jsonDict=[NSMutableDictionary new];
    [jsonDict setObject:self.hid2 forKey:@"hid"];
    [jsonDict setObject:self.rid forKey:@"resortid"];
    [jsonDict setObject:self.season forKey:@"season"];
    [jsonDict setObject:self.memid forKey:@"memberid"];
    [jsonDict setObject:self.memcity forKey:@"city"];
    
    
//    if ([self.currency isEqual:@"INR"])
//    {
//        
//    }
//    else
//    {
//        [jsonDict setObject:self.currency forKey:@"rcurrency"];
//    
//    }
    
    NSURL *url=[NSURL URLWithString:myurl2];
    NSMutableString *bodyString = [[NSMutableString alloc]init];
    for (id currentKey in jsonDict.allKeys)
    {
        if([[jsonDict valueForKey:currentKey] isKindOfClass:[NSString class]])
        {
            NSString *keyObject = (NSString *)currentKey;
            [bodyString appendFormat:@"%@=%@&",keyObject,[jsonDict valueForKey:keyObject]];
        }
    }
    NSData *inputData = [[NSData alloc]initWithBytes:[bodyString UTF8String] length:[bodyString length]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPBody:inputData];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[inputData length]] forHTTPHeaderField:@"Content-Length"];
    //  //NSLog(@"the data posting is %@", bodyString);
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
                                      {
                                          id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                          NSDictionary *jsonDictionary=obj;
                                          //NSLog(@"pw  is %@ ",jsonDictionary);
                                          
                                          //NSLog(@" eerror dis %@ ",[error description]);
                                          
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:jsonDictionary waitUntilDone:YES];
      
                                          
                                          
                                          
                                      }];
    
    
    [dataTask resume];
    
       [_gAppDelegate showLoadingView:NO activityTitle:nil];
}
#pragma -mark segmentcontrol actions

#pragma -mark getavailbledate delegate method
-(void)sendAvailableDates:(NSDictionary *)dic
{
    //[self performSelectorOnMainThread:@selector(updateUI:) withObject:dic waitUntilDone:YES];
}
-(NSString *)changeDateformater:(NSString*)str{
//    //NSLog(@"%@",str);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    NSDate *currentDate = [NSDate date];
    NSDate *dateFromString ;
    dateFromString = [dateFormatter dateFromString:str];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *str1=[dateFormatter stringFromDate:dateFromString];
//    //NSLog(@"%@....%@",str1,dateFromString);
    return str1;
}
-(NSString *)changeReverseDateformater:(NSString*)str{
//    //NSLog(@"%@",str);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
     [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    //    NSDate *currentDate = [NSDate date];
    NSDate *dateFromString ;
    dateFromString = [dateFormatter dateFromString:str];
   
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str1=[dateFormatter stringFromDate:dateFromString];
//    //NSLog(@"%@....%@",str1,dateFromString);
    return str1;
}

-(void)updateUI:(NSDictionary *)dic

{
    currentTextFiled = (UITextField *)[self.view viewWithTag:202];
    //NSLog(@"dic data is  %@ ",dic);
    char d1=[self.holidayslength.text characterAtIndex:0];
     daysint=[[NSString stringWithFormat:@"%c", d1] intValue];
    //NSLog(@"%d",daysint);
//    NSMutableArray *dates=[[NSMutableArray alloc]init];
    NSArray *citysdata =[dic objectForKey:[NSString stringWithFormat:@"datesArray%d",daysint]];
    for (NSDictionary *dic in  citysdata)
    {
        NSString *str=[dic objectForKey:@"dates"];
        NSString *str1=[self changeDateformater:str];
        [self.datesArray addObject:str1];
    }
    if (self.datesArray.count==0)
    {
        [_gAppDelegate showAlertView:YES message:@"No dates available for selected option"];
     
    }
    else{
        
        self.checkIn.hidden=NO;
        self.label_infodates.hidden=NO;
        [currentTextFiled changeInputViewAsPickerView:self.datesArray];
        
    }
    [hud hide:YES];
}


@end
