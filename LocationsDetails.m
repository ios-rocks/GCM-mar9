//
//  LocationsDetails.m
//  CountryClub
//
//  Created by atsmacmini4 on 5/5/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import "LocationsDetails.h"
#import "SelectLocationViewcontroller.h"
#import "SelectedEventsDedtails.h"
#import "MBProgressHUD.h"
#import "DisplayLocationImagesView.h"
#define Food_and_Beverages_Images_Url @"http://www.countryclubworld.com/club/admin/menu/"
@interface LocationsDetails ()<MBProgressHUDDelegate,UITextViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>{
    UILabel *Navlbl,*lbl,*lbl1;
    NSInteger index;
    NSArray *animationImages;
    MBProgressHUD *hud;
    UIView *captureView,*GenralFeedbackView,*btnsView;
    UITextView *messageTextview,*subjectTextview;
    int feedbackViewStatus;
    float h;
    BOOL isShowAlert;
}

@end

@implementation LocationsDetails

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    reqSysVer = @"6.2";
    currSysVer = [[UIDevice currentDevice] systemVersion];
    contactBtn.hidden=YES;
    emailBtn.hidden=YES;
    directionsBtn.hidden=YES;
    eventsBtn.hidden=YES;
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    app.countryClub.delegate=self;
    defaultScreenRect=app.window.bounds;
    self.automaticallyAdjustsScrollViewInsets=NO;
    //self.backScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, app.window.frame.size.width, app.window.frame.size.height)];
    h=50;
  
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
            
            if (defaultScreenRect.size.height == 480)
            {
//                btnsBackimg.frame=CGRectMake(0, 435, 320, 50);
//                contactBtn.frame=CGRectMake(10, 440, 45, 45);
//                emailBtn.frame=CGRectMake(135, 440, 45, 45);
//                directionsBtn.frame=CGRectMake(247, 440, 45, 45);
                btnsBackimg.frame=CGRectMake(0, app.window.frame.size.height-h, app.window.frame.size.width, 50);
                contactBtn.frame=CGRectMake((app.window.frame.size.width-200)/5, app.window.frame.size.height-h, 50, 50);
                emailBtn.frame=CGRectMake(2*(app.window.frame.size.width-200)/5+50, app.window.frame.size.height-h, 50, 50);
                banquetMenuBtn.frame=CGRectMake(3*(app.window.frame.size.width-200)/5+100, app.window.frame.size.height-h, 50, 50);
                directionsBtn.frame=CGRectMake(4*(app.window.frame.size.width-200)/5+150, app.window.frame.size.height-h, 50, 50);
                self.backScrollview.contentSize = CGSizeMake(app.window.frame.size.width, 1000);
                
            }
            else
            {
                self.backScrollview.contentSize = CGSizeMake(app.window.frame.size.width, 1200);

                btnsBackimg.frame=CGRectMake(0, app.window.frame.size.height-h, app.window.frame.size.width, 50);
                contactBtn.frame=CGRectMake((app.window.frame.size.width-200)/5, app.window.frame.size.height-h, 50, 50);
                emailBtn.frame=CGRectMake(2*(app.window.frame.size.width-200)/5+50, app.window.frame.size.height-h, 50, 50);
                banquetMenuBtn.frame=CGRectMake(3*(app.window.frame.size.width-200)/5+100, app.window.frame.size.height-h, 50, 50);
                directionsBtn.frame=CGRectMake(4*(app.window.frame.size.width-200)/5+150, app.window.frame.size.height-h, 50, 50);
            }
           
        }
        else{
            if (defaultScreenRect.size.height == 480)
            {
                
            }
            btnsBackimg.frame=CGRectMake(0, app.window.frame.size.height-h, app.window.frame.size.width, 50);
            contactBtn.frame=CGRectMake((app.window.frame.size.width-200)/5, app.window.frame.size.height-h, 50, 50);
            emailBtn.frame=CGRectMake(2*(app.window.frame.size.width-200)/5+50, app.window.frame.size.height-h, 50, 50);
              banquetMenuBtn.frame=CGRectMake(3*(app.window.frame.size.width-200)/5+100, app.window.frame.size.height-h, 50, 50);
            //                eventsBtn.frame=CGRectMake(3*(app.window.frame.size.width-200)/5+100, app.window.frame.size.height-50, 50, 50);
            directionsBtn.frame=CGRectMake(4*(app.window.frame.size.width-200)/5+150, app.window.frame.size.height-h, 50, 50);
        }
        Navlbl=[[UILabel alloc]init];
         self.backScrollview.frame=CGRectMake(0, 0, app.window.frame.size.width, app.window.frame.size.height);
        if (app.window.frame.size.width>380) {
            Navlbl.frame=CGRectMake(130, 2, 150, 40);
           
        }
        else if (app.window.frame.size.width>320){
            Navlbl.frame=CGRectMake(110, 2, 150, 40);

        }
        else{
            Navlbl.frame=CGRectMake(85, 2, 150, 40);
        }
//    Navlbl=[[UILabel alloc]initWithFrame:CGRectMake(60, 2, 200, 40)];
   
    Navlbl.textAlignment=NSTextAlignmentCenter;
//    Navlbl.adjustsFontSizeToFitWidth=YES;
    Navlbl.textColor=[UIColor whiteColor];
    Navlbl.backgroundColor=[UIColor clearColor];
    [self.navigationController.navigationBar addSubview:Navlbl];
    animationImages = [self.locationsDic objectForKey:@"image"];
//    //NSLog(@" eventCount %@",self.locationsDic);
   
  //  [app.countryClub findEventOfSelectedVenue:[self.locationsDic objectForKey:@"id"]];
    [self Displayimages:animationImages];

//    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(chageScrollviewOffsetvalue) userInfo:nil repeats:YES];
    self.resortName.text=[self.locationsDic objectForKey:@"name"];
    self.resortName.adjustsFontSizeToFitWidth=YES;
    
    self.addressLbl.text=[self.locationsDic objectForKey:@"address"];
   
    self.addressLbl.adjustsFontSizeToFitWidth=YES;

    self.Type.text=[ NSString stringWithFormat:@"%@,%@",[self.locationsDic objectForKey:@"type"],[self.locationsDic objectForKey:@"city"]];
   

    Navlbl.text=[self.locationsDic objectForKey:@"type"];
    NSString *str=[self.locationsDic objectForKey:@"facility"];
    NSString *cuisineStr=[self.locationsDic objectForKey:@"cuisine"];
    NSArray *arr=[str componentsSeparatedByString:@","];
   
    NSString *eventcount=[self.locationsDic objectForKey:@"eventCount"];
    int c= [eventcount intValue];
    if (c>0) {
            if (defaultScreenRect.size.height == 480)
        {
            eventsBtn.hidden=NO;
            

            btnsBackimg.frame=CGRectMake(0, app.window.frame.size.height-h, app.window.frame.size.width, 50);
            contactBtn.frame=CGRectMake((app.window.frame.size.width-250)/6, app.window.frame.size.height-h, 50, 50);
            emailBtn.frame=CGRectMake(2*(app.window.frame.size.width-250)/6+50, app.window.frame.size.height-h, 50, 50);
            eventsBtn.frame=CGRectMake(3*(app.window.frame.size.width-250)/6+100, app.window.frame.size.height-h, 50, 50);
            banquetMenuBtn.frame=CGRectMake(4*(app.window.frame.size.width-250)/6+150, app.window.frame.size.height-h, 50, 50);
            directionsBtn.frame=CGRectMake(5*(app.window.frame.size.width-250)/6+200, app.window.frame.size.height-h, 50, 50);
        }
        else{
        eventsBtn.hidden=NO;
              btnsBackimg.frame=CGRectMake(0, app.window.frame.size.height-h, app.window.frame.size.width, 50);
            contactBtn.frame=CGRectMake((app.window.frame.size.width-250)/6, app.window.frame.size.height-h, 50, 50);
            emailBtn.frame=CGRectMake(2*(app.window.frame.size.width-250)/6+50, app.window.frame.size.height-h, 50, 50);
            eventsBtn.frame=CGRectMake(3*(app.window.frame.size.width-250)/6+100, app.window.frame.size.height-h, 50, 50);
              banquetMenuBtn.frame=CGRectMake(4*(app.window.frame.size.width-250)/6+150, app.window.frame.size.height-h, 50, 50);
            directionsBtn.frame=CGRectMake(5*(app.window.frame.size.width-250)/6+200, app.window.frame.size.height-h, 50, 50);

        }
            [contactBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateHighlighted];
            [directionsBtn setBackgroundImage:[UIImage imageNamed:@"4"] forState:UIControlStateHighlighted];
            [emailBtn setBackgroundImage:[UIImage imageNamed:@"3"] forState:UIControlStateHighlighted];
             [banquetMenuBtn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateHighlighted];
        }
    contactBtn.hidden=NO;
    emailBtn.hidden=NO;
    directionsBtn.hidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:254.0f/255 green:254.0f/255 blue:254.0f/255 alpha:1.0];
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    
    {
        self.backScrollview.contentSize = CGSizeMake(app.window.frame.size.width, 1210);
        
        UIImageView *backimg=[[UIImageView alloc]init];
      
        backimg.image=[UIImage imageNamed:@"upperline"];
        [self.backScrollview addSubview:backimg];
        UILabel *hilights=[[UILabel alloc]initWithFrame:CGRectMake(50, 695, 400, 22)];
        hilights.text=@"HIGHLIGHTS";
        //    hilights.textColor=[UIColor darkTextColor];
        hilights.font=[UIFont fontWithName:@"Helvetica neue" size:22.0f];
        UIFont *currentFont = hilights.font;
        UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:currentFont.pointSize];
        hilights.font = newFont;
        [self.backScrollview addSubview:hilights];
        float width=0;
        float y=720;
        int x=0;
        for (int i=0; i<arr.count; i++) {
            if (width>650) {
                y=y+30;
                x=0;
                width=0;
            }
            
            UILabel *lbl11=[[UILabel alloc]initWithFrame:CGRectMake(x*250+70, y, 300, 30)];
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(x*250+50, y+5, 15, 15)];
            lbl11.text=[arr objectAtIndex:i];
//            //NSLog(@"%@",lbl11.text);
            if ([lbl11.text isEqualToString:@"Non Veg"]) {
                img.image=[UIImage imageNamed:@"nonveg"];
            }
            else if ([lbl11.text isEqualToString:@"Veg"])
            {
                img.image=[UIImage imageNamed:@"radio1"];
                
            }
            else if ([lbl11.text isEqualToString:@"Wifi"])
            {
                img.image=[UIImage imageNamed:@"wifi"];
            }
            else if ([lbl11.text isEqualToString:@"Bar"]){
                img.image=[UIImage imageNamed:@"bar"];
            }
            else{
                img.image=[UIImage imageNamed:@"yes"];
            }
            if (i==arr.count-1) {
                float h1=y-650;
                backimg.frame=CGRectMake(0, 680, app.window.frame.size.width, h1);
                if (width<650) {
                    y=y+22;
                }
            }
            width=width+300;
            
            //        lbl.textColor=[UIColor darkGrayColor];
            lbl11.font=[UIFont fontWithName:@"Helvetica neue" size:18.0f];
            [self.backScrollview addSubview:lbl11];
            [self.backScrollview addSubview:img];
            x++;
            
        }
        UIImageView *backimg1=[[UIImageView alloc]init];
        backimg1.frame=CGRectMake(0, y+25, app.window.frame.size.width, 90);
        backimg1.image=[UIImage imageNamed:@"upperline"];
        [self.backScrollview addSubview:backimg1];
        
        UILabel *Clbl=[[UILabel alloc]initWithFrame:CGRectMake(50, y+30, 600, 22)];
        Clbl.text=@"CUISINE";
        Clbl.font=[UIFont fontWithName:@"Helvetica neue" size:22.0f];
        UIFont *currentFont1 = Clbl.font;
        UIFont *newFont1 = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont1.fontName] size:currentFont1.pointSize];
        Clbl.font = newFont1;
        
        [self.backScrollview addSubview:Clbl];
        UILabel *Clbltext=[[UILabel alloc]initWithFrame:CGRectMake(50, y+45, 600, 80)];
        Clbltext.font=[UIFont fontWithName:@"Helvetica neue" size:18.0f];
        Clbltext.numberOfLines=4;
        
        Clbltext.text=cuisineStr;
        [self.backScrollview addSubview:Clbltext];
        
        NSArray *arr11=[self.locationsDic allKeys];
        if ([arr11 containsObject:@"lunch"]) {
            
            UIImageView *backimg2=[[UIImageView alloc]init];
            backimg2.frame=CGRectMake(0, y+120, 768, 100);
            backimg2.image=[UIImage imageNamed:@"upperline"];
            [self.backScrollview addSubview:backimg2];
            
            UILabel *hourslbl=[[UILabel alloc]initWithFrame:CGRectMake(50, y+125, 180, 22)];
            
            hourslbl.text=@"HOURS";
            hourslbl.font=[UIFont fontWithName:@"Helvetica neue" size:22.0f];
            UIFont *currentFont2 = hourslbl.font;
            UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont2.fontName] size:currentFont2.pointSize];
            hourslbl.font = newFont;
            
            [self.backScrollview addSubview:hourslbl];
            UILabel *breakfast=[[UILabel alloc]initWithFrame:CGRectMake(50, y+150, 400, 20)];
            breakfast.font=[UIFont fontWithName:@"Helvetica neue" size:18.0f];
            NSString *bStr= @"Breakfast ";
            breakfast.text=[NSString stringWithFormat:@"%@: %@",bStr,[self.locationsDic objectForKey:@"breakfast"]];
            
            [self.backScrollview addSubview:breakfast];
            UILabel *lunchlbl=[[UILabel alloc]initWithFrame:CGRectMake(50, y+180, 400, 20)];
            lunchlbl.font=[UIFont fontWithName:@"Helvetica neue" size:18.0f];
            NSString *lStr= @"Lunch      ";
            lunchlbl.text=[NSString stringWithFormat:@"%@: %@",lStr,[self.locationsDic objectForKey:@"lunch"]];
            
            [self.backScrollview addSubview:lunchlbl];
            UILabel *dinnerlbl=[[UILabel alloc]initWithFrame:CGRectMake(50, y+210, 400, 20)];
            dinnerlbl.font=[UIFont fontWithName:@"Helvetica neue" size:18.0f];
            NSString *dStr= @"Dinner     ";
            dinnerlbl.text=[NSString stringWithFormat:@"%@: %@",dStr,[self.locationsDic objectForKey:@"dinner"]];
            
            [self.backScrollview addSubview:dinnerlbl];
        }
        else{
            
        }
        
        if ([[self.locationsDic objectForKey:@"banquet"] length]==0) {
            
        }
        else{
            UIImageView *backimg12=[[UIImageView alloc]init];
            backimg12.frame=CGRectMake(0, y+235, app.window.frame.size.width, 90);
            backimg12.image=[UIImage imageNamed:@"upperline"];
            [self.backScrollview addSubview:backimg12];
            
            UILabel *bnqet=[[UILabel alloc]initWithFrame:CGRectMake(50, y+240, 180, 22)];
            bnqet.text=@"BANQUET";
            bnqet.font=[UIFont fontWithName:@"Helvetica neue" size:18.0f];

            UIFont *Font1 = bnqet.font;
            UIFont *neFont1 = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",Font1.fontName] size:Font1.pointSize];
            bnqet.font = neFont1;
            
            [self.backScrollview addSubview:bnqet];
            UILabel *banquet=[[UILabel alloc]initWithFrame:CGRectMake(50, y+260, app.window.frame.size.width-20, 140)];
            banquet.font=[UIFont fontWithName:@"Helvetica neue" size:18.0f];
;
            banquet.numberOfLines=5;
            
            banquet.text=[self.locationsDic objectForKey:@"banquet"];
            [self.backScrollview addSubview:banquet];
            UIButton *calButton=[[UIButton alloc]initWithFrame:CGRectMake(app.window.frame.size.width-250, y+320, 50, 40)];
            [calButton setImage:[UIImage imageNamed:@"banquet"] forState:UIControlStateNormal];
            [calButton addTarget:self action:@selector(banquetCalAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self.backScrollview addSubview:calButton];
            
        }
        
            }
    else
    {
//        imageview.frame=CGRectMake(0, 0, app.window.frame.size.width, 150);
//        [self.backScrollview addSubview:imageview];

    self.backScrollview.contentSize = CGSizeMake(app.window.frame.size.width, 1100);
        UIImageView *backimg11=[[UIImageView alloc]init];
        backimg11.frame=CGRectMake(0, 390, app.window.frame.size.width, 5);
        backimg11.image=[UIImage imageNamed:@"upperline"];
        [self.backScrollview addSubview:backimg11];
    UIImageView *backimg=[[UIImageView alloc]init];
//         backimg.frame=CGRectMake(0, 387, app.window.frame.size.width, 10);
//    backimg.image=[UIImage imageNamed:@"cell-4.png"];
       
    [self.backScrollview addSubview:backimg];
    UILabel *hilights=[[UILabel alloc]initWithFrame:CGRectMake(20, 390, 200, 22)];
    hilights.text=@"HIGHLIGHTS";
//    hilights.textColor=[UIColor darkTextColor];
     hilights.font=[UIFont fontWithName:@"Helvetica neue" size:14.0f];
    UIFont *currentFont = hilights.font;
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:currentFont.pointSize];
    hilights.font = newFont;
    [self.backScrollview addSubview:hilights];
    float width=0;
    float y=410;
    int x=0;
    for (int i=0; i<arr.count; i++) {
        if (width>250) {
            y=y+22;
            x=0;
            width=0;
        }
        
        UILabel *lbl7=[[UILabel alloc]initWithFrame:CGRectMake(x*150+45, y, 130, 20)];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(x*150+20, y+3, 15, 15)];
         lbl7.text=[arr objectAtIndex:i];
//        //NSLog(@"%@",lbl7.text);
        if ([lbl7.text isEqualToString:@"Non Veg"]) {
           // img.image=[UIImage imageNamed:@"ic_non_veg.png"];
        }
        else if ([lbl7.text isEqualToString:@"Veg"])
        {
         //   img.image=[UIImage imageNamed:@"ic_veg.png"];
            
        }
        else if ([lbl7.text isEqualToString:@"Wifi"])
        {
            //img.image=[UIImage imageNamed:@"ic_wifi.png"];
        }
        else if ([lbl7.text isEqualToString:@"Bar"]){
           // img.image=[UIImage imageNamed:@"ic_bar.png"];
        }
        else{
            img.image=[UIImage imageNamed:@"yes"];
        }
        if (i==arr.count-1) {
            float h1=y-330;
            backimg.frame=CGRectMake(0, 387, 320, h1);
            if (width<200) {
                y=y+22;
            }
        }
        width=width+130;
       
//        lbl.textColor=[UIColor darkGrayColor];
        lbl7.font=[UIFont fontWithName:@"Helvetica neue" size:13.0f];
        [self.backScrollview addSubview:lbl7];
        [self.backScrollview addSubview:img];
        x++;
        
    }
    UIImageView *backimg1=[[UIImageView alloc]init];
    backimg1.frame=CGRectMake(0, y+20, app.window.frame.size.width, 90);
    backimg1.image=[UIImage imageNamed:@"upperline"];
    [self.backScrollview addSubview:backimg1];

    UILabel *Clbl=[[UILabel alloc]initWithFrame:CGRectMake(20, y+23, 180, 22)];
    Clbl.text=@"CUISINE";
    Clbl.font=[UIFont fontWithName:@"Helvetica neue" size:14.0f];
    UIFont *currentFont1 = Clbl.font;
    UIFont *newFont1 = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont1.fontName] size:currentFont1.pointSize];
    Clbl.font = newFont1;

    [self.backScrollview addSubview:Clbl];
     UILabel *Clbltext=[[UILabel alloc]initWithFrame:CGRectMake(20, y+35, app.window.frame.size.width-20, 60)];
        Clbltext.font=[UIFont fontWithName:@"Helvetica neue" size:13.0f];
    Clbltext.numberOfLines=4;

    Clbltext.text=cuisineStr;

    [self.backScrollview addSubview:Clbltext];
    
    NSArray *arr11=[self.locationsDic allKeys];
    if ([arr11 containsObject:@"lunch"]) {
        
        UIImageView *backimg2=[[UIImageView alloc]init];
        backimg2.frame=CGRectMake(0, y+90, app.window.frame.size.width, 100);
        backimg2.image=[UIImage imageNamed:@"upperline"];
        [self.backScrollview addSubview:backimg2];
    
    UILabel *hourslbl=[[UILabel alloc]initWithFrame:CGRectMake(20, y+90, 180, 22)];
    
    hourslbl.text=@"HOURS";
        hourslbl.font=[UIFont fontWithName:@"Helvetica neue" size:14.0f];
        UIFont *currentFont2 = hourslbl.font;
        UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont2.fontName] size:currentFont2.pointSize];
        hourslbl.font = newFont;

    [self.backScrollview addSubview:hourslbl];
        
    UILabel *breakfast=[[UILabel alloc]initWithFrame:CGRectMake(20, y+110, 220, 20)];
    breakfast.font=[UIFont fontWithName:@"Helvetica neue" size:13.0f];
    NSString *bStr= @"Breakfast ";
    breakfast.text=[NSString stringWithFormat:@"%@: %@",bStr,[self.locationsDic objectForKey:@"breakfast"]];

    [self.backScrollview addSubview:breakfast];
    UILabel *lunchlbl=[[UILabel alloc]initWithFrame:CGRectMake(20, y+130, 220, 20)];
    lunchlbl.font=[UIFont fontWithName:@"Helvetica neue" size:13.0f];
    NSString *lStr= @"Lunch      ";
    lunchlbl.text=[NSString stringWithFormat:@"%@: %@",lStr,[self.locationsDic objectForKey:@"lunch"]];

    [self.backScrollview addSubview:lunchlbl];
    UILabel *dinnerlbl=[[UILabel alloc]initWithFrame:CGRectMake(20, y+150, 220, 20)];
    dinnerlbl.font=[UIFont fontWithName:@"Helvetica neue" size:13.0f];
    NSString *dStr= @"Dinner     ";
    dinnerlbl.text=[NSString stringWithFormat:@"%@: %@",dStr,[self.locationsDic objectForKey:@"dinner"]];

    [self.backScrollview addSubview:dinnerlbl];
        self.backScrollview.contentSize = CGSizeMake(app.window.frame.size.width, y+300);
    }
    else{
       
        self.backScrollview.contentSize = CGSizeMake(app.window.frame.size.width, y+200);
    }
        if ([[self.locationsDic objectForKey:@"banquet"] length]==0) {
            
        }
        else{
        UIImageView *backimg12=[[UIImageView alloc]init];
        backimg12.frame=CGRectMake(0, y+170, app.window.frame.size.width, 90);
        backimg12.image=[UIImage imageNamed:@"upperline"];
        [self.backScrollview addSubview:backimg12];
        
        UILabel *bnqet=[[UILabel alloc]initWithFrame:CGRectMake(20, y+173, 180, 22)];
        bnqet.text=@"BANQUET";
        bnqet.font=[UIFont fontWithName:@"Helvetica neue" size:14.0f];
        UIFont *Font1 = bnqet.font;
        UIFont *neFont1 = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",Font1.fontName] size:Font1.pointSize];
        bnqet.font = neFont1;
        
        [self.backScrollview addSubview:bnqet];
        UILabel *banquet=[[UILabel alloc]initWithFrame:CGRectMake(20, y+170, app.window.frame.size.width-20, 140)];
        banquet.font=[UIFont fontWithName:@"Helvetica neue" size:13.0f];
        banquet.numberOfLines=5;
        
        banquet.text=[self.locationsDic objectForKey:@"banquet"];
        [self.backScrollview addSubview:banquet];
           
            UIButton *calButton=[[UIButton alloc]initWithFrame:CGRectMake(app.window.frame.size.width-90, y+213, 30, 30)];
            [calButton setImage:[UIImage imageNamed:@"banquet"] forState:UIControlStateNormal];
            [calButton addTarget:self action:@selector(banquetCalAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self.backScrollview addSubview:calButton];
            self.backScrollview.contentSize = CGSizeMake(app.window.frame.size.width, y+400);
        }
        self.backScrollview.showsVerticalScrollIndicator=YES;
        self.backScrollview.scrollEnabled=YES;
        self.backScrollview.userInteractionEnabled=YES;
        
 
    }

}

-(void)viewWillAppear:(BOOL)animated{
    app.countryClub.delegate=self;
    NSArray *arr=[app.countryClub isLogin];
    if (arr.count==2)
    {
        UILabel *homelbl=(UILabel*)[self.view viewWithTag:450];
        homelbl.hidden=YES;
        switchbtn.hidden=YES;
    }
    else{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
      if ([[userdefaults objectForKey:@"setclub"] isEqualToString:@"clublocation"])
      {
          UILabel *homelbl=(UILabel*)[self.view viewWithTag:450];
          homelbl.hidden=NO;
          if ([[userdefaults objectForKey:@"location"] isEqualToString:[self.locationsDic objectForKey:@"name"]]) {
               switchbtn.on=YES;
          }
          else
            switchbtn.on=NO;
      }
      
    }
    Navlbl.hidden=NO;
     [UIApplication sharedApplication].statusBarHidden=NO;
    [super viewWillAppear:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    Navlbl.hidden=YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
     Navlbl.hidden=NO;
    
    
   }
-(void)chageScrollviewOffsetvalue{
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        if (index==animationImages.count-1) {
            index=0;
            scrollview.contentOffset=CGPointMake(app.window.frame.size.width*index, 0);
        }
        else{
            index++;
            scrollview.contentOffset=CGPointMake(app.window.frame.size.width*index, 0);
        }

        
    }
    else{
    if (index==animationImages.count-1) {
        index=0;
        scrollview.contentOffset=CGPointMake(app.window.frame.size.width*index, 0);
    }
    else{
        index++;
        scrollview.contentOffset=CGPointMake(app.window.frame.size.width*index, 0);
    }
    }
}
-(void)Displayimages:(NSArray*)imgarr
{
    index = 0;
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
        scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, app.window.frame.size.width, 400)];
        
        scrollview.contentSize = CGSizeMake(app.window.frame.size.width, 400);
//         scrollview.contentOffset=CGPointMake(0, 66);
        scrollview.scrollEnabled = YES;
        scrollview.scrollsToTop=NO;
        [self.backScrollview addSubview:scrollview];
        for (UIView *v in [scrollview subviews]) {
            [v removeFromSuperview];
        }
        
        CGRect workingFrame = scrollview.frame;
        workingFrame.origin.x = 0;
        
        

            imageview = [[UIImageView alloc]init];
                
        
            imageview.frame = workingFrame;
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgarr.lastObject]];
        if (data)
            imageview.image=[UIImage imageWithData:data];
        else
            imageview.image=[UIImage imageNamed:@"Locateus_Default_pad.png"];
//              imageview.image=image;
            UIButton *tapbutton=[UIButton buttonWithType:UIButtonTypeCustom];
            tapbutton.frame=CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height);
            [tapbutton addTarget:self action:@selector(presentview) forControlEvents:UIControlEventTouchUpInside];
//            tapbutton.backgroundColor=[UIColor redColor];
            [scrollview addSubview:imageview];
            [imageview addSubview:tapbutton];
            imageview.userInteractionEnabled=YES;
            scrollview.userInteractionEnabled=YES;
            
          
            //        [imageview bringSubviewToFront:scrollview];
//            [scrollview addSubview:imageview];
            
            
            workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
//        }
        
        
        
        
        [scrollview setPagingEnabled:YES];
        [scrollview setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];

        
    }
    
    else{
     if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
    if (defaultScreenRect.size.height == 480)
    {
        scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, app.window.frame.size.width, 190)];
        
        scrollview.contentSize = CGSizeMake(app.window.frame.size.width, 327);
    }
    else
    {
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, app.window.frame.size.width, 190)];
    
    scrollview.contentSize = CGSizeMake(app.window.frame.size.width, 327);
    }
         
     }
     else{
         scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, app.window.frame.size.width, 187)];
         
         scrollview.contentSize = CGSizeMake(app.window.frame.size.width, 187);
     }
        scrollview.scrollEnabled = YES;
        scrollview.scrollsToTop=NO;
        [self.backScrollview addSubview:scrollview];
        for (UIView *v in [scrollview subviews]) {
            [v removeFromSuperview];
        }
        
        CGRect workingFrame = scrollview.frame;
        workingFrame.origin.x = 0;
        
                if (defaultScreenRect.size.height == 480)
                {
                    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 67, app.window.frame.size.width, 150)];
                }
                else{
                    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 67, app.window.frame.size.width, 150)];
                }
                
                
                
                
                
       
            
            imageview.frame = workingFrame;
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgarr.firstObject]];
            if(data)
                imageview.image=[UIImage imageWithData:data];
            else
                imageview.image = [UIImage imageNamed:@"locateusiphone"];
        
            //        [imageview bringSubviewToFront:scrollview];
            UIButton *tapbutton=[UIButton buttonWithType:UIButtonTypeCustom];
            tapbutton.frame=CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height);
            [tapbutton addTarget:self action:@selector(presentview) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:imageview];
            [imageview addSubview:tapbutton];
            imageview.userInteractionEnabled=YES;
            
            workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
//        }
    
        
        
        
        [scrollview setPagingEnabled:YES];
        [scrollview setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];

        
    }
    
}
-(void)presentview{
    DisplayLocationImagesView *disply=[[DisplayLocationImagesView alloc]init];
    disply.imagesArray=animationImages;
//    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:disply];
    [self presentViewController:disply animated:YES completion:nil];
    
}
-(void)animationDone:(NSTimer*)inTimer
{
   
//    //NSLog(@"animationDone ");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma - mark Contact & email

-(void)banquetCalAction{
    NSURL *phoneURL = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:+%@",[self.locationsDic objectForKey:@"banqCall"]]];
    if ([[phoneURL absoluteString] length]==0) {
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"Phone number not available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
           }
    else{
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
 
}
-(IBAction)calToNumber:(id)sender{
//    //NSLog(@"%@",[NSString  stringWithFormat:@"telprompt:%@",[self.locationsDic objectForKey:@"phone"]]);
    NSURL *phoneURL = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:+%@",[self.locationsDic objectForKey:@"phone"]]];
    if ([[phoneURL absoluteString] length]==0) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"Phone number not available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];    }
    else{
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
}
-(IBAction)sendEmail:(id)sender{
    NSString *emailadd=[self.locationsDic objectForKey:@"email"];
//    //NSLog(@"%@",emailadd);
    if ([emailadd length]==0) {
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"Email address not available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
       
    }
    else{
        MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
        
        emailer.mailComposeDelegate = self;
        
        [emailer setSubject:NSLocalizedString(@"mail", nil)];
        NSArray *arr=[[NSArray alloc]initWithObjects:[self.locationsDic objectForKey:@"email"], nil];
        [emailer setToRecipients:arr];
        
        
        
        
        if(emailer==nil)
        {
            
        }
        else{
            [self presentViewController:emailer animated:YES completion:nil];
        }
        
//        [self presentViewController:emailer animated:YES completion:nil];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    
    if (result == MFMailComposeResultFailed) {
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:NSLocalizedString(@"Email", nil) message:NSLocalizedString(@"Email failed to send. Please try again.", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *Cancel=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:Cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


#pragma -mark map directions
-(IBAction)mapview:(id)sender{
    app.locationscheck=YES;
    
    
    NSString *urlStrr = [NSString stringWithFormat:@"comgooglemaps-x-callback://?saddr=&daddr=%f,%f&center=37.423725,-122.0877&x-success=CountryClub://?resume=true&x-source=CountryClub", [[self.locationsDic objectForKey:@"latitude"]floatValue], [[self.locationsDic objectForKey:@"longitude"]floatValue]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStrr]];

}
-(IBAction)eventsAction:(id)sender{
    app.countryClub.delegate=self;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    [app.countryClub findEventOfSelectedVenue:self.idvalue];
}
-(void)setupRightMenuButton{
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(-5, 5, 30, 30);
    [btn1 setImage:[UIImage imageNamed:@"logo-2.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *imagebtn=[[UIBarButtonItem alloc]initWithCustomView:btn1];
    
    [self.navigationItem setRightBarButtonItem:imagebtn animated:YES];
}
-(void)getEventDetailsOfSelectedVenue:(NSDictionary *)dic{
    [self performSelectorOnMainThread:@selector(sendeventdata:) withObject:dic waitUntilDone:YES];
    [hud performSelectorOnMainThread:@selector(hide:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
}
-(void)getAllEventsData:(NSDictionary *)dic
{
    
    
    [self performSelectorOnMainThread:@selector(sendeventdata:) withObject:dic waitUntilDone:YES];
    [hud performSelectorOnMainThread:@selector(hide:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
}
-(void)sendeventdata:(NSDictionary*)dic{
    app.eventsArray=[dic objectForKey:@"event"];
    SelectedEventsDedtails *detais;
        detais=[[SelectedEventsDedtails alloc]init];
        detais.filteredarray=app.eventsArray;
    [self.navigationController pushViewController:detais animated:YES];
}
-(IBAction)menuAction:(id)sender{
    if ([[self.locationsDic objectForKey:@"banquetMenu"] length]==0) {
        
        
UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"For this location Menu is not available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *Cancel=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:Cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else{
   // NSString *banquetpdf=[self.locationsDic objectForKey:@"banquetMenu"];
   // NSString *finalStr=[Food_and_Beverages_Images_Url stringByAppendingString:banquetpdf];
   // FandBmenuPdfloader *fB=[[FandBmenuPdfloader alloc]init];
   // fB.pdfUrl=[NSURL URLWithString:finalStr];
   // [self.navigationController pushViewController:fB animated:YES];
    }
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
-(void)countyClubModel_ResponseOfUserFeedback:(NSDictionary *)dic{
    GenralFeedbackView.hidden=YES;
    feedbackViewStatus=0;
    btnsView.hidden=YES;
    if (isShowAlert)
    {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:[dic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
      
        isShowAlert=NO;
    }
    
}

- (IBAction) switchIsChanged:(UISwitch *)paramSender{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    
    if ([paramSender isOn]){
        
        [userdefaults setObject:self.locationsDic forKey:@"locationDic"];
        [userdefaults setObject:[self.locationsDic objectForKey:@"name"] forKey:@"location"];
              
                [userdefaults setObject:@"clublocation" forKey:@"setclub"];
//        app.locationDictionary=self.locationsDic;
        
        
    } else {
        
        [userdefaults removeObjectForKey:@"setclub"];
        [userdefaults removeObjectForKey:@"location"];
        
    }
    
}
@end
