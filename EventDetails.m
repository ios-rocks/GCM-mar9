//
//  EventDetails.m
//  CountryClubLive
//
//  Created by atsmacmini4 on 8/25/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import "EventDetails.h"

#import "SelectLocationViewcontroller.h"
@interface EventDetails ()<UIAlertViewDelegate,UITextViewDelegate,UIActionSheetDelegate>{
    UILabel *Navlbl,*lbl,*lbl1;
    NSString *btnTagstr;
    UIView *captureView,*GenralFeedbackView,*btnsView;
    UITextView *messageTextview,*subjectTextview;
    int feedbackViewStatus;
    BOOL isShowAlert;

}

@end

@implementation EventDetails
@synthesize idvalue,dic1;
- (void)viewDidLoad {
    [super viewDidLoad];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    app.countryClub.delegate=self;
    defaultScreenRect=app.window.bounds;
    reqSysVer = @"6.2";
    currSysVer = [[UIDevice currentDevice] systemVersion];
//    //NSLog(@"%f",app.window.frame.size.width);
    self.automaticallyAdjustsScrollViewInsets=NO;

    [self.view addSubview:img];

      img.image=[self.dic1 objectForKey:@"eventImg"];
    titleLbl.text=[self.dic1 objectForKey:@"eventName"];
    NSString *str=[self.dic1 objectForKey:@"eventDate"];
    NSString *changedate=[self changeDateformater:str];
    self.dateLbl.text=changedate;
    self.timeLbl.text=[self.dic1 objectForKey:@"eventTime"];
    self.infoLbl.text=[self.dic1 objectForKey:@"eventDesc"];
    self.infoLbl.adjustsFontSizeToFitWidth=YES;
    self.memcharge.text=[self.dic1 objectForKey:@"memFee"];
    self.guestcharge.text=[self.dic1 objectForKey:@"guestFee"];
    self.address.text=[self.dic1 objectForKey:@"eventAddress"];
        img.frame=CGRectMake(0, 0, app.window.frame.size.width, 230);
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
            
            if (defaultScreenRect.size.height == 480)
            {
                scrollview.frame=CGRectMake(0, 30, 320,450);
                
            }
            else{
                scrollview.frame=CGRectMake(0, 0, app.window.frame.size.width, app.window.frame.size.height);

            }
        
        }
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
    
    Navlbl.textAlignment=NSTextAlignmentCenter;
    //    Navlbl.adjustsFontSizeToFitWidth=YES;
    Navlbl.textColor=[UIColor whiteColor];
    Navlbl.backgroundColor=[UIColor clearColor];
    [self.navigationController.navigationBar addSubview:Navlbl];
    Navlbl.text=@"Event Details";
    scrollview.contentSize = CGSizeMake(app.window.frame.size.width, 580);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
     Navlbl.hidden=NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

     Navlbl.hidden=NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];

    Navlbl.hidden=YES;
}


-(IBAction)cal:(id)sender{
   
   
 
}
-(IBAction)email:(id)sender
{
    
    
    
   }
#pragma  mark book event

-(IBAction)map:(id)sender{
    app.locationscheck=YES;
    
    NSString *urlStrr = [NSString stringWithFormat:@"comgooglemaps-x-callback://?saddr=&daddr=%f,%f&center=37.423725,-122.0877&x-success=CountryClub://?resume=true&x-source=CountryClubLive", [[self.dic1 objectForKey:@"latitude"]floatValue], [[self.dic1 objectForKey:@"longitude"]floatValue]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStrr]];
//    SelectLocationViewcontroller *vi;
//    
//    vi=[[SelectLocationViewcontroller alloc]init];
//   
//    
//    vi.Latitude=[[self.dic1 objectForKey:@"latitude"]floatValue];
//    vi.Longitude=[[self.dic1 objectForKey:@"longitude"]floatValue];
//    vi.annotationTitle=[self.dic1 objectForKey:@"eventVenue"];
////    vi.annotationSubtitle=[self.dic1 objectForKey:@"City"];
//    [self presentViewController:vi animated:YES completion:nil];

}
#pragma mark alertview delegate
#pragma mark contact details
-(void)calToNumber{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (feedbackViewStatus==1){
        GenralFeedbackView.hidden=YES;
        btnsView.hidden=YES;
        feedbackViewStatus=0;
    }
}
#pragma mark textView delegate methods
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.tag==4000) {
        lbl1.hidden=YES;
    }
    else{
        lbl.hidden=YES;
    }
    textView.textColor = [UIColor blackColor];
    //    if (textView.textColor == [UIColor lightGrayColor]) {
    //        textView.text = @"";
    //        textView.textColor = [UIColor blackColor];
    //    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        if(textView.tag==4000)
        {
            lbl1.hidden=NO;
            lbl1.textColor=[UIColor lightGrayColor];
            lbl1.text = @"Subject:";
        }
        else
        {
            lbl.hidden=NO;
            lbl.textColor=[UIColor lightGrayColor];
            lbl.text = @"Message";
        }
        [textView resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(textView.text.length == 0){
            
            textView.textColor = [UIColor lightGrayColor];
            if(textView.tag==4000)
            {
                lbl1.hidden=NO;
                lbl1.textColor=[UIColor lightGrayColor];
                
                lbl1.text = @"Subject:";
            }
            else
            {
                lbl.hidden=NO;
                lbl.textColor=[UIColor lightGrayColor];
                lbl.text = @"Message";
            }
            
            [textView resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}
#pragma mark cal buttons

-(void)countyClubModel_ResponseOfUserFeedback:(NSDictionary *)dic
{
    GenralFeedbackView.hidden=YES;
    feedbackViewStatus=0;
    btnsView.hidden=YES;
    if (isShowAlert)
    {
    
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:[dic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        alert.view.tag=10;
    
        isShowAlert=NO;
    }
    
}
-(void)countyClubModel_ResponseOfBookEvent:(NSDictionary *)dic
{
      UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:[dic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
    alert.view.tag=12;
    
  

}
@end
