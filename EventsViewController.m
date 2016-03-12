//
//  EventsViewController.m
//  CountryClub
//
//  Created by atsmacmini4 on 6/10/15.
//  Copyright (c) 2015 atsmacmini4. All rights reserved.
//

#import "EventsViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "MainViewController.h"
#import "EventDetails.h"
#import "EventsByCity.h"
#import <MessageUI/MFMailComposeViewController.h>
@interface EventsViewController ()<UITableViewDataSource,UITableViewDelegate,CountryClubModelDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>{
    IBOutlet UITableView *table; UIAlertController *alert1;
    MBProgressHUD *hud;
    AppDelegate *app;
    UIBarButtonItem *rightbarbuttonEmail;
    NSMutableArray *filteredArray;
    NSArray *titlesArray;
    UIView *captureView,*GenralFeedbackView,*btnsView;
    UITextView *messageTextview,*subjectTextview;
     int feedbackViewStatus;
    UILabel *lbl,*lbl1;
    NSMutableArray *expiredeventsArray,*sections;
    NSMutableSet *indexrow,*section;

}
@property(nonatomic,strong)IBOutlet UIBarButtonItem *revealButtonItem;
@property(nonatomic,strong)NSArray *eventsperselectedCity,*eventsperSelecetResort;
@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,30,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.textColor=[UIColor whiteColor];
    lbNavTitle.text = NSLocalizedString(@"Events",@"");
    self.navigationItem.titleView = lbNavTitle;
   
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [self customSetup];
    expiredeventsArray=[[NSMutableArray alloc]init];
    sections=[[NSMutableArray alloc]init];
    section=[[NSMutableSet alloc]init];
    indexrow=[[NSMutableSet alloc]init];
    [self createBarbuttons];
   
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Loading...";
        app.countryClub.delegate=self;
        [app.countryClub sendAllEventsData];
    
    filteredArray=[[NSMutableArray alloc]init];
    titlesArray=[[NSArray alloc]init];
}



-(BOOL)prefersStatusBarHidden
{
    return YES;
    
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
    [emailBtn addTarget:self action:@selector(emailbtnAction)
       forControlEvents:UIControlEventTouchUpInside];
    
    rightbarbuttonEmail=[[UIBarButtonItem alloc]initWithCustomView:emailBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    
    NSMutableArray *barbuttons=[[NSMutableArray alloc]init];
    
    [barbuttons addObject:negativeSpacer];
    [barbuttons addObject:rightbarbuttonEmail];
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
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return filteredArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section1 {
    
    return [[filteredArray objectAtIndex:section1] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
      cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
   
    NSMutableArray *subArray=[filteredArray objectAtIndex:indexPath.section];
    
    NSDictionary *dic=[subArray objectAtIndex:indexPath.row];
    
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
        
        cell.backgroundColor=[UIColor colorWithRed:255.0f/255 green:253.0f/255 blue:223.0f/255 alpha:1.0];
        
    }
    else
         cell.backgroundColor=[UIColor whiteColor];
        NSString *str1=[dic objectForKey:@"eventTime"];
    NSString *newString = [[str1 componentsSeparatedByString:@" "] objectAtIndex:0];
      ((UILabel *)[cell.contentView viewWithTag:80]).text = newString;
    ((UILabel *)[cell.contentView viewWithTag:85]).text =[[str1 componentsSeparatedByString:@" "] objectAtIndex:1];
//    cell.time.text=[dic objectForKey:@"eventTime"];
    ((UILabel *)[cell.contentView viewWithTag:81]).text=[dic objectForKey:@"eventName"];
   ((UILabel *)[cell.contentView viewWithTag:83]).text=[ NSString stringWithFormat:@"%@,%@",[dic objectForKey:@"eventVenue"],[dic objectForKey:@"eventCity"]];
    
    return cell;
    
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr=[app.countryClub isLogin];
    if (!(arr.count==2)) {
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"Please Login details" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
           }
    else{
        NSMutableArray *subArray=[filteredArray objectAtIndex:indexPath.section];
        
        NSDictionary *dic=[subArray objectAtIndex:indexPath.row];

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
//            UIAlertView *expiredEventAlert=[[UIAlertView alloc]initWithTitle:nil message:@"This event Expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [expiredEventAlert show];
        }
        else{

        app.viewControllerStatus=10;
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Loading...";
        
       
        NSString *str=[dic objectForKey:@"id"];
        app.countryClub.delegate=self;
        [app.countryClub sendEventDataByEventId:str];
        }
    }

    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section1{
    UIView *vi=[[UIView alloc]init];
    vi.frame=CGRectMake(0, 0, table.frame.size.width, 40);
    vi.backgroundColor=[UIColor grayColor];
    UILabel *lbl6;
        lbl6 =[[UILabel alloc]initWithFrame:CGRectMake((table.frame.size.width-150)/2, 5, 150, 44)];
    lbl6.textAlignment=NSTextAlignmentCenter;
    lbl6.font= [UIFont fontWithName:@"System Bold" size:18.0];
    lbl6.textColor=[UIColor blackColor];
    lbl6.text=[self changeDateformater:[titlesArray objectAtIndex:section1]];
    [vi addSubview:lbl6];
    return vi;
}
-(NSString *)changeDateformater:(NSString*)str{
//    //NSLog(@"%@",str);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    NSDate *currentDate = [NSDate date];
//    NSDate *dateFromString = [[NSDate alloc] init];
//    dateFromString = [dateFormatter dateFromString:str];
//    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
//    NSString *str1=[dateFormatter stringFromDate:dateFromString];
//    //NSLog(@"%@....%@",str1,dateFromString);
    NSArray *arr=[str componentsSeparatedByString:@"-"];
    NSDate *date = [dateFormatter dateFromString:str];

    dateFormatter.dateFormat=@"MMM";
    NSString * monthString = [[dateFormatter stringFromDate:date] capitalizedString];
//    //NSLog(@"month: %@", monthString);
    
    dateFormatter.dateFormat=@"EEEE";
    NSString * dayString = [[dateFormatter stringFromDate:date] capitalizedString];
//    //NSLog(@"day: %@", dayString);
    NSString *result=[NSString stringWithFormat:@"%@ %@ %@",dayString,monthString,[arr objectAtIndex:2]];
    
    return result;
}

#pragma mark delegate method
-(void)getAllEventsData:(NSDictionary *)dic
{
    
    table.hidden=NO;
    table.scrollEnabled=YES;
   
    
    app.eventsArray=[dic objectForKey:@"event"];
    self.eventsperselectedCity=[dic objectForKey:@"citys"];
    self.eventsperSelecetResort=[dic objectForKey:@"resorts"];
    NSArray *arr=[app.eventsArray valueForKey:@"eventDate"];
    NSSet *set=[NSSet setWithArray:arr];
    arr=[set allObjects];
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending:YES];
    
    NSArray *allValuess = [arr sortedArrayUsingDescriptors:@[sortOrder]];
//    //NSLog(@"%@",allValuess);
    titlesArray=allValuess;
    for (int i=0; i<arr.count; i++) {
        NSMutableArray *SubfilterArray=[NSMutableArray new];
//        for (NSDictionary *dic in app.eventsArray) {
            for (int j=0; j<app.eventsArray.count; j++) {
                
                NSDictionary *dic=[app.eventsArray objectAtIndex:j];
            if ([[dic valueForKey:@"eventDate"] isEqualToString:[allValuess objectAtIndex:i]]) {
                [SubfilterArray addObject:dic];
            }
            }
            [filteredArray addObject:SubfilterArray];
            }
//     //NSLog(@" filteredArray%@",filteredArray);
    [table performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [hud performSelectorOnMainThread:@selector(hide:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
}
-(void)getSelectedEvent:(NSDictionary *)dic{
    [self performSelectorOnMainThread:@selector(sendeventdata:) withObject:dic waitUntilDone:YES];
    [hud performSelectorOnMainThread:@selector(hide:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    
    
}
-(void)sendeventdata:(NSDictionary*)dic{
    EventDetails *details;
    details=[[EventDetails alloc]init];
    
    details.dic1=[[NSDictionary alloc]init];
    details.dic1=dic;
//    //NSLog(@"%@",dic);
    [hud performSelectorOnMainThread:@selector(hide:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    [self.navigationController pushViewController:details animated:YES];
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
    
    
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:[dic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark uialertview delegate method
@end
