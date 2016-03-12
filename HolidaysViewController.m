//
//  HolidaysViewController.m
//  CountryClub
//
//  Created by atsmacmini4 on 6/10/15.
//  Copyright (c) 2015 atsmacmini4. All rights reserved.
//

#import "HolidaysViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "ResortsListViewController.h"
@interface HolidaysViewController ()<CountryClubModelDelegate,MBProgressHUDDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextViewDelegate>
{
    AppDelegate *app;
    MBProgressHUD *hud;
    IBOutlet UITableView *table;
    ResortsListViewController *resort;
    UIView *captureView,*GenralFeedbackView,*btnsView;
    UITextView *messageTextview,*subjectTextview;
    int feedbackViewStatus;
    UILabel *lbl,*lbl1;
    
    }
@property(nonatomic,strong)IBOutlet UIBarButtonItem *revealButtonItem;
@property(nonatomic,strong)NSDictionary *holidaysDic;
@property(nonatomic,strong)NSArray *holidaysArray;
@property(nonatomic,strong)NSMutableArray *resortarray;


@end

@implementation HolidaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
        self.title=@"Holidays";
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    }
    else{
        UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,30,320,40)];
        lbNavTitle.textAlignment = NSTextAlignmentLeft;
        lbNavTitle.textColor=[UIColor whiteColor];
        lbNavTitle.text = NSLocalizedString(@"Holidays",@"");
        self.navigationItem.titleView = lbNavTitle;
    }
    [self customSetup];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    //NSLog(@"holidays is %@ ",self.holidays);
    [self HolidaysData:self.holidays];

    //   [self SetnavigationbarColor];
    [self createBarbuttons];
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"Loading...";
       app.countryClub.delegate=self;
    
   // [app.countryClub getHolidays];
}
-(void)createBarbuttons{
    
    
    
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [myButton setImage:[UIImage imageNamed:@"Home.png"] forState:UIControlStateNormal];
    
    myButton.frame = CGRectMake(0, 0, 40, 36);
    
    [myButton addTarget:self action:@selector(requestButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * aBarButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    
    self.navigationItem.rightBarButtonItem = aBarButton;

    
    
    
}

- (void)requestButton{
    
    MainViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:keyEmpIdViewControllerIdentifier];
    
    UINavigationController *nav = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:NO];
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;

}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    if (app.viewControllerStatus==80) {
        self.view.alpha=1.0;
        app.viewControllerStatus=0;
    }
    table.delegate=self;
    table.dataSource=self;
    [super viewWillAppear:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return self.holidaysArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *CellIdentifier =nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    NSDictionary *dic =[self.holidaysArray objectAtIndex:indexPath.row];
    
    
    
    CGFloat height=[UIScreen mainScreen].bounds.size.height;
    
    UILabel *snotext;
    UILabel *sno;UILabel *holidayUpto;UILabel *holidayUpto1;UILabel *VALIDFROM;UILabel *VALIDFROM1;UILabel *EXPIRESON;UILabel *EXPIRESON1;UILabel *STATUS;
    
    if (height<600)
    {
        
        sno=[[UILabel alloc]initWithFrame:CGRectMake(5, 3,cell.contentView.frame.size.width/8,20)];
        snotext=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(sno.frame)+3,cell.contentView.frame.size.width/8,20)];
        holidayUpto=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sno.frame), 3,cell.contentView.frame.size.width/3,20)];
        holidayUpto1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(snotext.frame), CGRectGetMaxY(holidayUpto.frame)+3,cell.contentView.frame.size.width/3,20)];
        VALIDFROM=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(holidayUpto.frame)+2, 3,cell.contentView.frame.size.width/3,20)];
        VALIDFROM1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(holidayUpto1.frame)+2, CGRectGetMaxY(VALIDFROM.frame)+3,cell.contentView.frame.size.width/3,20)];
        
        EXPIRESON=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(VALIDFROM.frame)-18, 3,cell.contentView.frame.size.width/3,20)];
        EXPIRESON1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(VALIDFROM1.frame)-18 ,CGRectGetMaxY(EXPIRESON.frame)+3,cell.contentView.frame.size.width/3,20)];
        STATUS=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(VALIDFROM1.frame)-18, CGRectGetMaxY(EXPIRESON1.frame)+3,cell.contentView.frame.size.width/3,20)];

    }
    else
    {
    
        sno=[[UILabel alloc]initWithFrame:CGRectMake(5, 3,cell.contentView.frame.size.width/8,20)];
        snotext=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(sno.frame)+3,cell.contentView.frame.size.width/8,20)];
         holidayUpto=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sno.frame)+3, 3,cell.contentView.frame.size.width/3,20)];
        holidayUpto1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(snotext.frame)+3, CGRectGetMaxY(holidayUpto.frame)+3,cell.contentView.frame.size.width/3,20)];
        VALIDFROM=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(holidayUpto.frame)+15, 3,cell.contentView.frame.size.width/3,20)];
         VALIDFROM1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(holidayUpto1.frame)+15, CGRectGetMaxY(VALIDFROM.frame)+3,cell.contentView.frame.size.width/3,20)];

        EXPIRESON=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(VALIDFROM.frame)+5, 3,cell.contentView.frame.size.width/3,20)];
         EXPIRESON1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(VALIDFROM1.frame)+5, CGRectGetMaxY(EXPIRESON.frame)+3,cell.contentView.frame.size.width/3,20)];
         STATUS=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(VALIDFROM1.frame)+5, CGRectGetMaxY(EXPIRESON1.frame)+3,cell.contentView.frame.size.width/3,20)];
    
    }
    
    
    
    sno.text=@"Sno";
    sno.textColor=[UIColor lightGrayColor];
    [cell.contentView addSubview:sno];
    
   
    snotext.textColor=[UIColor blackColor];
    snotext.tag=40;
    [cell.contentView addSubview:snotext];
    
   
    holidayUpto.text=@"HOLIDAYUPTO";
    holidayUpto.font=[UIFont fontWithName:@"Helvetica" size:13];
    holidayUpto.adjustsFontSizeToFitWidth=YES;
    holidayUpto.textColor=[UIColor lightGrayColor];
    [cell.contentView addSubview:holidayUpto];
    
    
    holidayUpto1.textColor=[UIColor blackColor];
    holidayUpto1.adjustsFontSizeToFitWidth=YES;
    holidayUpto.font=[UIFont fontWithName:@"Helvetica" size:13];
    holidayUpto1.tag=41;
    [cell.contentView addSubview:holidayUpto1];
    
    
    VALIDFROM.text=@"VALIDFROM";
    VALIDFROM.adjustsFontSizeToFitWidth=YES;
    VALIDFROM.font=[UIFont fontWithName:@"Helvetica" size:13];
    VALIDFROM.textColor=[UIColor lightGrayColor];
    [cell.contentView addSubview:VALIDFROM];
    
   
    VALIDFROM1.textColor=[UIColor blackColor];
    VALIDFROM1.font=[UIFont fontWithName:@"Helvetica" size:13];
    VALIDFROM1.adjustsFontSizeToFitWidth=YES;
    VALIDFROM1.tag=42;
    [cell.contentView addSubview:VALIDFROM1];
    
    
    EXPIRESON.text=@"EXPIRESON";
    EXPIRESON.adjustsFontSizeToFitWidth=YES;
    EXPIRESON.font=[UIFont fontWithName:@"Helvetica" size:13];
    EXPIRESON.textColor=[UIColor lightGrayColor];
    [cell.contentView addSubview:EXPIRESON];
    
    
   
    EXPIRESON1.textColor=[UIColor blackColor];
    EXPIRESON1.adjustsFontSizeToFitWidth=YES;
    EXPIRESON1.font=[UIFont fontWithName:@"Helvetica" size:13];
    EXPIRESON1.tag=43;
    [cell.contentView addSubview:EXPIRESON1];
    
    
   
    STATUS.textColor=[UIColor blackColor];
    STATUS.adjustsFontSizeToFitWidth=YES;
    STATUS.font=[UIFont fontWithName:@"Helvetica" size:13];
    STATUS.tag=44;
    [cell.contentView addSubview:STATUS];
    
    
    
    
    ((UILabel *)[cell.contentView viewWithTag:44]).text=[dic objectForKey:@"used"];
    if ([((UILabel *)[cell.contentView viewWithTag:44]).text isEqualToString:@"Expired"]) {
        ((UILabel *)[cell.contentView viewWithTag:44]).textColor=[UIColor redColor];
    }
    else if ([((UILabel *)[cell.contentView viewWithTag:44]).text isEqualToString:@"Used"])
    {
        ((UILabel *)[cell.contentView viewWithTag:44]).textColor=[UIColor colorWithRed:204.0f/255 green:22.0f/255 blue:101.0f/255 alpha:1];
    }
    else if ([((UILabel *)[cell.contentView viewWithTag:44]).text isEqualToString:@"Book"])
    {
        ((UILabel *)[cell.contentView viewWithTag:44]).textColor=[UIColor colorWithRed:26.0f/255 green:138.0f/255 blue:246.0f/255 alpha:1];
    }
    else{
        ((UILabel *)[cell.contentView viewWithTag:44]).textColor=[UIColor colorWithRed:83.0f/255 green:154.0f/255 blue:43.0f/255 alpha:1];
    }
    //        cell.bookNow.textColor=[UIColor greenColor];
    ((UILabel *)[cell.contentView viewWithTag:41]).text=[dic objectForKey:@"hldyLgth"];
    NSString *vaildstr=[self changeDateformater:[dic objectForKey:@"validTo"]];
    NSString *expirstr=[self changeDateformater:[dic objectForKey:@"validYear"]];
    ////NSLog(@"%@....%@",vaildstr,expirstr);
    ((UILabel *)[cell.contentView viewWithTag:42]).text=vaildstr;
    ((UILabel *)[cell.contentView viewWithTag:43]).text=expirstr;
    ((UILabel *)[cell.contentView viewWithTag:40]).text=[NSString stringWithFormat:@"#%ld", (long)[[dic objectForKey:@"hno"]integerValue]];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *dic = [self.holidaysArray objectAtIndex:indexPath.row];
   // NSString *hid1=[dic objectForKey:@"hid"];
    
    NSString *str=[dic objectForKey:@"used"];
    
     if ([str isEqualToString:@"Book"])
         
    {
        
        
        NSDictionary *dic = [self.holidaysArray objectAtIndex:indexPath.row];
        NSString *hid1=[dic objectForKey:@"hid"];
        
        NSString *str=[dic objectForKey:@"used"];
        
        if ([str isEqualToString:@"Book"])
            
        {
            
            [self getResorts:hid1];
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               
                               resort=[[ResortsListViewController alloc]init];
                               [self.navigationController pushViewController:resort animated:YES];
                               
                           });
        }
        
        
        
        
    }
    

}


#define myurl @"http://www.countryclubworld.com/akhilapp/ccapp/index_v1.php/EmployeecheckResorts"


-(void)getResorts:(NSString*)hid
{
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }

    
    NSMutableDictionary *jsonDict=[NSMutableDictionary new];
    [jsonDict setObject:self.memid forKey:@"memberid"];
    [jsonDict setObject:self.memcity forKey:@"city"];
    [jsonDict setObject:hid forKey:@"hid"];

    NSURL *url=[NSURL URLWithString:myurl];
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
                                          
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^(void)
                                                         {
                                                             
                                                             
                                                             if (_resortarray==nil)
                                                             {
                                                                 //  [_gAppDelegate showAlertView:YES message:@"No Bookings"];
                                                                 
                                                             }
                                                             self.resortarray=[jsonDictionary objectForKey:@"resort"];
                                                           //  NSLog(@"resotr is %@ ",_resortarray);
                                                             resort.resortsArray=self.resortarray;
                                                             resort.memid=self.memid;
                                                             resort.memcity=self.memcity;
                                                             resort.holidaysArray=self.holidaysArray;
                                                             NSString *err=[jsonDictionary objectForKey:@"error"];
                                                             
                                                             
                                                             
                                                             if ([err boolValue]==0)
                                                             {                                            }
                                                             
                                                             else
                                                             {
                                                                 
                                                                 
                                                                 [_gAppDelegate showAlertView:YES message:@"invalid Booking"];
                                                             }
                                                             
                                                         });
                                          
                                          
                                      }];
    
    
    [dataTask resume];
    
    
    
    
    
    
}







#pragma -mark  AlertView methods


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

#pragma mark holidays delegate method
-(void)HolidaysData:(NSDictionary *)dic
{
    
    self.holidaysDic=dic;
    //    //NSLog(@"%@",self.holidaysDic);
    self.holidaysArray=[dic objectForKey:@"holiday"];
    if (self.holidaysArray.count==0) {
        
        [self performSelectorOnMainThread:@selector(displayHolidayimages) withObject:nil waitUntilDone:YES];
      //  [hud performSelectorOnMainThread:@selector(hide:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    }
    else {
        table.hidden=NO;
        [table performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
      //[hud performSelectorOnMainThread:@selector(hide:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    }
    [table reloadData];
}
-(void)displayHolidayimages{
    table.hidden=YES;
    UIImageView *imagVi;
    NSString *currSysVer=[UIDevice currentDevice].systemVersion;
    NSString *reqSysVer=@"6.2";
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
            imagVi=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 768, 960)];
        }
        else{
            imagVi=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 768, 960)];
        }
        imagVi.image=[UIImage imageNamed:@"Mobile-pages-_ipad1.jpg"];
        [self.view addSubview:imagVi];
        
    }
    else{
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
            
            imagVi=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 504)];
        }
        else{
            imagVi=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 504)];
        }
        if (self.view.frame.size.height==480) {
            imagVi.image=[UIImage imageNamed:@"Mobile-pages.jpg"];
        }
        else{
            imagVi.image=[UIImage imageNamed:@"Mobile-pages.jpg"];
        }
        [self.view addSubview:imagVi];
        
    }
    
}
@end
