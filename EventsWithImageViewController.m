//
//  EventsWithImageViewController.m
//  CountryClub
//
//  Created by atsmacmini4 on 6/11/15.
//  Copyright (c) 2015 atsmacmini4. All rights reserved.
//


#import "EventsWithImageViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "EventsCell.h"
#import "EventDetails.h"
#import "EventsByCity.h"
#import "UIImageView+WebCache.h"
#import <MessageUI/MFMailComposeViewController.h>
@interface EventsWithImageViewController ()<UITableViewDataSource,UITableViewDelegate,CountryClubModelDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>{
    IBOutlet UITableView *table;
    AppDelegate *app;
    MBProgressHUD *hud;
    UIBarButtonItem *rightbarbuttonEmail;UIAlertController *alert1;
    UIView *captureView,*GenralFeedbackView,*btnsView;
    UITextView *messageTextview,*subjectTextview;
    int feedbackViewStatus;
    UILabel *lbl,*lbl1;
    
}
@property(nonatomic,strong)IBOutlet UIBarButtonItem *revealButtonItem;
@property(nonatomic,strong)NSArray *eventsperselectedCity,*eventsperSelecetResort;
@end

@implementation EventsWithImageViewController
-(BOOL)prefersStatusBarHidden
{

    return YES;}
- (void)viewDidLoad {
    [super viewDidLoad];
   
        UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,30,320,40)];
        lbNavTitle.textAlignment = NSTextAlignmentLeft;
        lbNavTitle.textColor=[UIColor whiteColor];
        lbNavTitle.text = NSLocalizedString(@"Events",@"");
        self.navigationItem.titleView = lbNavTitle;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
     app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [self customSetup];
    //    [self SetnavigationbarColor];
    [self createBarbuttons];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    app.countryClub.delegate=self;
    [app.countryClub sendAllEventsData];
}

-(void)createBarbuttons{
    UIButton *calBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    calBtn.frame=CGRectMake(0, 0, 30, 30);
    [calBtn setBackgroundImage:[UIImage imageNamed:@"Home"] forState:UIControlStateNormal];
    [calBtn addTarget:self action:@selector(calAction)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightbarbuttonCal=[[UIBarButtonItem alloc]initWithCustomView:calBtn];
    
    
    UIButton *emailBtn = [[UIButton alloc] init];
    emailBtn.frame=CGRectMake(0, 0, 44, 44);
    [emailBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    //    [emailBtn setBackgroundImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateSelected];
    [emailBtn addTarget:self action:@selector(emailbtnAction)
       forControlEvents:UIControlEventTouchUpInside];
    
    rightbarbuttonEmail=[[UIBarButtonItem alloc]initWithCustomView:emailBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    
    NSMutableArray *barbuttons=[[NSMutableArray alloc]init];
    
    [barbuttons addObject:negativeSpacer];
    [barbuttons addObject:rightbarbuttonEmail];
    //     [barbuttons addObject:negativeSpacer];
    [barbuttons addObject:rightbarbuttonCal];
    
    
    
    
    self.navigationItem.rightBarButtonItems=(NSMutableArray*)barbuttons;
    
}
-(void)DisplyActionsheet

{
    NSArray *arr=[app.countryClub isLogin];
    
    EventsByCity *city;
    city=[[EventsByCity alloc]init];
    
    city.eventsByCityArray=[[NSMutableArray alloc]init];
    if (arr.count==2)
    {
       
        
        alert1=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
           alert1.view.tag=2;
              UIAlertAction *Search_Preoperty=[UIAlertAction actionWithTitle:@"Search Events by Property" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                         {
                                             
                                             app.viewControllerStatus=11;
                                             city.selectedValue=20;
                                             [city.eventsByCityArray addObjectsFromArray:self.eventsperSelecetResort];
                                             [self.navigationController pushViewController:city animated:YES];
                                             
                                             
                                         }  ];
        
        UIAlertAction *search_City=[UIAlertAction actionWithTitle:@"Search Events by City" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                    {
                                        app.viewControllerStatus=11;
                                        city.selectedValue=21;
                                        [city.eventsByCityArray addObjectsFromArray:self.eventsperselectedCity];
                                        [self.navigationController pushViewController:city animated:YES];
                                        
                                        
                                    }  ];
        
        [alert1 addAction:Search_Preoperty];
        [alert1 addAction:search_City];
        [alert1 addAction:cancel];
        
        [self presentViewController:alert1 animated:YES completion:nil];
        
    }
    
    else
    {
        
        alert1=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        alert1.view.tag=1;
               UIAlertAction *Search_Preoperty=[UIAlertAction actionWithTitle:@"Search Events by Property" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                         {
                                             app.viewControllerStatus=11;
                                             city.selectedValue=20;
                                             [city.eventsByCityArray addObjectsFromArray:self.eventsperSelecetResort];
                                             [self.navigationController pushViewController:city animated:YES];
                                             
                                         }  ];
        
        UIAlertAction *search_City=[UIAlertAction actionWithTitle:@"Search Events by City" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                    {
                                        app.viewControllerStatus=11;
                                        city.selectedValue=21;
                                        [city.eventsByCityArray addObjectsFromArray:self.eventsperselectedCity];
                                        [self.navigationController pushViewController:city animated:YES];
                                        
                                    }  ];
       
        
        [alert1 addAction:Search_Preoperty];
        [alert1 addAction:search_City];
        [alert1 addAction:cancel];
        
        [self presentViewController:alert1 animated:YES completion:nil];
        
    }
    
}


-(void)SetnavigationbarColor{
    UIColor * barColor = [UIColor colorWithRed:32.0/255.0
                                         green:32.0/255.0
                                          blue:32.0/255.0
                                         alpha:1.0];
    
    
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
        [self.navigationController.navigationBar setBarTintColor:barColor];
    }
    else {
        [self.navigationController.navigationBar setTintColor:barColor];
    }
    
    
    NSDictionary *navBarTitleDict;
    UIColor * titleColor = [UIColor colorWithRed:55.0/255.0
                                           green:70.0/255.0
                                            blue:77.0/255.0
                                           alpha:1.0];
    navBarTitleDict = @{NSForegroundColorAttributeName:titleColor};
    [self.navigationController.navigationBar setTitleTextAttributes:navBarTitleDict];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    
}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return app.eventsArray.count;
}

-(BOOL)checkExpiredEvents:(NSInteger)indexpath{
    
    NSDictionary *dic=[app.eventsArray objectAtIndex:indexpath];
    BOOL ispreviousdate = NO;
    
    
    NSString *currentdate=[dic
                           objectForKey:@"cdate"];
    NSString *eventdate=[dic
                         objectForKey:@"eventDate"];
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    NSDate *date = [dateFormatter dateFromString:[dic objectForKey:@"eventTime"]];
    dateFormatter.dateFormat = @"HH:mm";
    NSString *time24 = [dateFormatter stringFromDate:date];
    
    NSString *finalCurrentdateString=[NSString stringWithFormat:@"%@ %@",currentdate,[dic objectForKey:@"ctime"]];
    NSString *finalEventdateString=[NSString stringWithFormat:@"%@ %@",eventdate,time24];
    
    
    NSComparisonResult result = [finalCurrentdateString compare:finalEventdateString];
    
    switch (result)
    {
        case NSOrderedAscending:
        {
            ispreviousdate=NO;
        }
            break;
        case NSOrderedDescending:
        {
            ispreviousdate=YES;
            
            
        }break;
        case NSOrderedSame:
        {
            ispreviousdate=YES;
            
        }break;
        default:  break;
    }
    if (ispreviousdate) {
        return YES;
    }
    else{
        return NO;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString localizedStringWithFormat:@"Cell_%ld_%ld",(long)indexPath.section, (long)indexPath.row];
    //    static NSString *CellIdentifier = @"CustomCell";
    EventsCell *cell = (EventsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil)
    {
        cell=[[EventsCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        NSArray *topLevelObjects;
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Event" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[EventsCell class]])
            {
                cell = (EventsCell *)currentObject;
                break;
            }
        }
    }
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dic=[app.eventsArray objectAtIndex:indexPath.row];
    //TODO: events images
    if ([self checkExpiredEvents:indexPath.row]) {
        cell.backgroundColor=[UIColor colorWithRed:255.0f/255 green:253.0f/255 blue:223.0f/255 alpha:1.0];
    }
    else
        cell.backgroundColor=[UIColor whiteColor];
    NSString *imageURlString=[dic objectForKey:@"eventImg"];
    imageURlString = [imageURlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url =[NSURL URLWithString:imageURlString];
    NSData *data = [NSData dataWithContentsOfURL:url];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImage *image = [UIImage imageWithData:data];
        
        cell.img.image=image;
        
    });
   
    //[cell.img sd_setImageWithURL:url placeholderImage: [UIImage imageNamed:@"placeholder"]   options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
    if ([self checkExpiredEvents:indexPath.row]) {
        
        cell.backgroundColor=[UIColor colorWithRed:255.0f/255 green:253.0f/255 blue:223.0f/255 alpha:1.0];
    }
    cell.MonthName.textColor=[UIColor colorWithRed:26.0f/256 green:138.0f/256 blue:246.0f/256 alpha:1.0];
    cell.date.textColor=[UIColor colorWithRed:26.0f/256 green:138.0f/256 blue:246.0f/256 alpha:1.0];
    cell.date.text=[dic objectForKey:@"eventTime"];
    cell.time.text=[dic objectForKey:@"eventName"];
    cell.eventName.text=[dic objectForKey:@"eventVenue"];
    cell.eventCity.text=[dic objectForKey:@"eventCity"];
    //        cell.EventsName.text=[dic objectForKey:@"eventName"];
    NSString *str=[dic objectForKey:@"eventDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //        NSDate *date = [dateFormatter dateFromString:str];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    
    [dateFormatter1 setDateFormat:@"EEEE"];
    
    //        NSString *dayName = [dateFormatter1 stringFromDate:date];
    //        cell.EventDayName.text=dayName;
    
    NSString *str1=[self changeDateformater:str];
    NSArray *arr=[str1 componentsSeparatedByString:@"-"];
    cell.MonthName.text=[NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:0],[arr objectAtIndex:1]];
    //    cell.MonthName.text=[arr objectAtIndex:1];
    [cell.detailsBtn addTarget:self action:@selector(eventBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //        cell.img.image=im;
    //    return cell;
    
    
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
        return 250.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr=[app.countryClub isLogin];
    if (!(arr.count==2))
    {
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"Please Login" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
      
    }
    else{
        BOOL ispreviousdate = NO;
        NSDictionary *dic=[app.eventsArray objectAtIndex:indexPath.row];
        
        NSString *currentdate=[dic
                               objectForKey:@"cdate"];
        NSString *eventdate=[dic
                             objectForKey:@"eventDate"];
        
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm a";
        NSDate *date = [dateFormatter dateFromString:[dic objectForKey:@"eventTime"]];
        dateFormatter.dateFormat = @"HH:mm";
        NSString *time24 = [dateFormatter stringFromDate:date];
        
        NSString *finalCurrentdateString=[NSString stringWithFormat:@"%@ %@",currentdate,[dic objectForKey:@"ctime"]];
        NSString *finalEventdateString=[NSString stringWithFormat:@"%@ %@",eventdate,time24];
        
        
        NSComparisonResult result = [finalCurrentdateString compare:finalEventdateString];
        
        switch (result)
        {
            case NSOrderedAscending:
            {
                ispreviousdate=NO;
            }
                break;
            case NSOrderedDescending:
            {
                ispreviousdate=YES;
                
                
            }break;
            case NSOrderedSame:
            {
                ispreviousdate=YES;
                
            }break;
            default:  break;
        }
        if (ispreviousdate) {
            //            UIAlertView *expiredEventAlert=[[UIAlertView alloc]initWithTitle:nil message:@"This event Expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            //            [expiredEventAlert show];
        }
        else{
            app.viewControllerStatus=11;
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"Loading...";
            
            NSString *str=[dic objectForKey:@"id"];
            app.countryClub.delegate=self;
            [app.countryClub sendEventDataByEventId:str];
        }
    }
    
}

-(NSString *)changeDateformater:(NSString*)str{
    //    //NSLog(@"%@",str);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    NSDate *currentDate = [NSDate date];
    NSDate *dateFromString;
    dateFromString = [dateFormatter dateFromString:str];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *str1=[dateFormatter stringFromDate:dateFromString];
    //    //NSLog(@"%@....%@",str1,dateFromString);
    return str1;
}
-(void)eventBtnAction:(UIButton*)btn1{
    app.viewControllerStatus=10;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    
    NSDictionary *dic=[app.eventsArray objectAtIndex:btn1.tag];
    NSString *str=[dic objectForKey:@"id"];
    app.countryClub.delegate=self;
    [app.countryClub sendEventDataByEventId:str];
}

#pragma mark delegate method
-(void)getAllEventsData:(NSDictionary *)dic
{
    
    table.hidden=NO;
    table.scrollEnabled=YES;
    //    //NSLog(@"%@",dic);
    
    app.eventsArray=[dic objectForKey:@"event"];
    self.eventsperselectedCity=[dic objectForKey:@"citys"];
    self.eventsperSelecetResort=[dic objectForKey:@"resorts"];
    //    //NSLog(@"%@",app.eventsArray);
    [table performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [hud performSelectorOnMainThread:@selector(hide:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
}
-(void)getSelectedEvent:(NSDictionary *)dic{
    [self performSelectorOnMainThread:@selector(sendeventdata:) withObject:dic waitUntilDone:YES];
    [hud performSelectorOnMainThread:@selector(hide:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    
    
}
-(void)sendeventdata:(NSDictionary*)dic{
    
    if (![[self.navigationController.viewControllers lastObject] isEqual:self]) {
        
        return;
    }
    EventDetails *details;
    details=[[EventDetails alloc]init];
    details.dic1=[[NSDictionary alloc]init];
    details.dic1=dic;
    [hud performSelectorOnMainThread:@selector(hide:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    [self.navigationController pushViewController:details animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark cal buttons
-(void)calAction
{
    
    
    MainViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:keyEmpIdViewControllerIdentifier];
    UINavigationController *nav = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:NO];

   
    
}

-(void)emailbtnAction{
    [self DisplyActionsheet];
}


@end
