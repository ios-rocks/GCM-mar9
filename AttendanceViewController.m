//
//  AttendanceViewController.m
//  Employee
//
//  Created by Country Club on 05/11/15.
//  Copyright © 2015 Country Club. All rights reserved.
//

#import "AttendanceViewController.h"
#import "webServiceHelper.h"
#import "MainViewController.h"
#import "FTWCache.h"
#import "NSString+MD5.h"
#import "SWRevealViewController.h"
@interface AttendanceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebtn;
@property (weak, nonatomic) IBOutlet UITableView *tableview_Attendance;
@property (weak, nonatomic) IBOutlet UITextField *textfiled_FromDate;
@property (weak, nonatomic) IBOutlet UITextField *textfield_ToDate;
- (IBAction)Button_FromDate:(id)sender;
- (IBAction)Button_ToDate:(id)sender;
@property (nonatomic, strong) NSDateFormatter *dateFormatter,*dateFormater1;
@property (weak, nonatomic) IBOutlet UIButton *B_fromDate;
@property (weak, nonatomic) IBOutlet UIButton *b_ToDate;
@property (weak, nonatomic) IBOutlet UILabel *label_Indeatils;
@property (weak, nonatomic) IBOutlet UILabel *label_Outdeatils;

@property(nonatomic,strong)NSMutableArray *array_profileInfo;
@property(nonatomic,strong)NSDictionary *dictionary_profile;
- (IBAction)Button_Submit:(id)sender;
@end

@implementation AttendanceViewController

#define urlattedance   @"http://www.ccilsupport.com/empapp/attendence1.php?"
//http://www.ccilsupport.com/empapp/attendence1.php?username=cci1235&from=2016-01-01&to=2016-02-02&db=ccindia

{
    NSString *url_Img1;
    NSString *url_Img2;
    NSMutableArray *array_At;
    NSMutableArray *array_At1;
    UIDatePicker *picker;
    webServiceHelper *sharedWebService;
    id object;
    NSString *from,*to;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    object=nil;
    _dictionary_profile=nil;
    array_At=nil;
       [self.tableview_Attendance setHidden:YES];
    [self.label_Indeatils setHidden:YES];
    [self.label_Outdeatils setHidden:YES];
    [_total_time setHidden:YES];

    
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,30,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.textColor=[UIColor whiteColor];
    lbNavTitle.text = NSLocalizedString(@"Attendance",@"");
    self.navigationItem.titleView = lbNavTitle;

    self.navigationItem.hidesBackButton = YES;
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebtn.target = self.revealViewController;
    _sidebtn.action = @selector(revealToggle:);
    // Set the gesture
 [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [myButton setImage:[UIImage imageNamed:@"Home.png"] forState:UIControlStateNormal];
    
    myButton.frame = CGRectMake(0, 0, 40, 36);
    
    [myButton addTarget:self action:@selector(requestButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * aBarButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    
    self.navigationItem.rightBarButtonItem = aBarButton;
    
    
    sharedWebService = [webServiceHelper sharedWebService];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Date:(id)sender
{    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    picker = [[UIDatePicker alloc] init];
    [picker setDatePickerMode:UIDatePickerModeDate];
    [alertController.view addSubview:picker];
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [picker addTarget:self action:@selector(updateDatePickerLabel:) forControlEvents:UIControlEventValueChanged];
            //NSLog(@"Picker date is %@",picker.date);
            [self updateDatePickerLabel:sender];
        }];
        action;
    })];
   UIPopoverPresentationController *popoverController = alertController.popoverPresentationController;
    popoverController.sourceView = sender;
    popoverController.sourceRect = [sender bounds];
    [self presentViewController:alertController  animated:YES completion:nil];


}
- (void)updateDatePickerLabel:(id)sender
{
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"MMM dd "];
    NSString *str=[NSString stringWithFormat:@"%@",[_dateFormatter  stringFromDate:picker.date]];
    
    _dateFormater1=[[NSDateFormatter alloc] init];
    [_dateFormater1 setDateFormat:@"yyyy-MM-dd"];
    

    if(_B_fromDate.tag==1)

    {
        self.textfiled_FromDate.text = str;
        //NSLog(@" date is  %@   ",_textfiled_FromDate.text);
        
        from=[NSString stringWithFormat:@"%@",[_dateFormater1  stringFromDate:picker.date]];
        
        //NSLog(@" from is  %@   ",from);
        
          }
    if(_B_fromDate.tag==2)
    {
        
        to=[NSString stringWithFormat:@"%@",[_dateFormater1  stringFromDate:picker.date]];
        //NSLog(@" to  is  %@   ",to);


    self.textfield_ToDate.text = str;
    }
    
}

- (IBAction)Button_FromDate:(id)sender
{

    _B_fromDate.tag=1;
   
    [self Date:sender];
    
   
    
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (IBAction)Button_ToDate:(id)sender
{
    _B_fromDate.tag=2;
    [self Date:sender];

}

-(void)getAttandance
{
    
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }

    
    [_gAppDelegate showLoadingView:YES activityTitle:@"Loading"];
 
    NSString *empid= [[NSUserDefaults standardUserDefaults]objectForKey:@"empid"];
    NSString *db=[[NSUserDefaults standardUserDefaults]objectForKey:@"city"];
    
    NSString *fromDate=from;
    NSString *toDate=to;
    
    
    // NSString *fromDate=_textfiled_FromDate.text;
   // NSString *toDate=_textfield_ToDate.text;
NSString *urlString = [NSString stringWithFormat:@"%@username=%@&from=%@&to=%@&db=%@",urlattedance,empid,fromDate,toDate,db];
    
    NSURL *url =[NSURL URLWithString:urlString];
    
    NSURLSession *session =[NSURLSession sharedSession];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
                                      {
                                          
                                    object=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                   //       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                                          
                                          if (object==nil)
                                          {
                                              [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];

                                          }
                                     dispatch_async(dispatch_get_main_queue(), ^{

                             //   NSLog(@" object description is %@ ",[object description]);
                                        //  //NSLog(@"str   is %@ ",_array_profileInfo);
                                      
                                         //NSLog(@"res    is %ld ",(long)httpResponse.statusCode);

                                         //NSLog(@"err    is %@ ",[object objectForKey:@"error"]);
                                         NSString *str=[object objectForKey:@"error"];
                                         [_gAppDelegate showLoadingView:NO activityTitle:nil];
                                        
                                          if ([str isEqualToString:@"false"])
                                          {
                                              [self.tableview_Attendance setHidden:NO];

                                              _array_profileInfo=[object objectForKey:@"empdetails"];
                                              //NSLog(@"ARRAY IS  %lu ",(unsigned long)_array_profileInfo.count);
                                                                    [self.label_Indeatils setHidden:NO];
                                              [_total_time setHidden:NO];
                                              [self.label_Outdeatils setHidden:NO];
                                              [self.tableview_Attendance setHidden:NO];
                                            [_tableview_Attendance reloadData];

                                              return;
                                              
                                          }
                                       else if ([str isEqualToString:@"true"])
                                          {
                                              
                                        _tableview_Attendance=nil;

UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"please enter correct data" preferredStyle:UIAlertControllerStyleAlert];
                                              
UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                              [alertController addAction:ok];
                                              
    [self presentViewController:alertController animated:YES completion:nil];

                                              return;
                                          }
                                          });
                                      }];
    [dataTask resume];
     [_gAppDelegate showLoadingView:NO activityTitle:nil];

}




- (IBAction)Button_Submit:(id)sender {
    
    
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showLoadingView:NO activityTitle:nil];
        [_gAppDelegate showAlertView:YES message:@"please check inernet connection"];
        
        return;
    }

    
    if ([_textfield_ToDate.text isEqual:@""]|| [_textfiled_FromDate.text isEqual:@""])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Please Enter Deatils" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    else
    {
        [self getAttandance];
        
     [_gAppDelegate showLoadingView:YES activityTitle:@"loading"];
        
        
        // [_tableview_Attendance reloadData];
    }
    
}

#pragma TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array_profileInfo.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    static NSString *CellIdentifier =nil;
   
    
    
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ];
    }

  
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
   
    
   // imageview_user.image=[Utils imageWithImage:[UIImage imageNamed:@"placeholder"] scaledToSize:CGSizeMake(30, 30)];
    
  //  imageview_Outuser.image=[Utils imageWithImage:[UIImage imageNamed:@"placeholder"] scaledToSize:CGSizeMake(30, 30)];
    
        CGSize size = [UIScreen mainScreen].bounds.size;
  //  CGFloat widthOfScreen  = size.width;
    CGFloat heightOfScreen = size.height;
    
    if (heightOfScreen>600)
    {
         label_date = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width/15, 0, cell.contentView.frame.size.width/7, 40)];
        
        label_OutDate= [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width/2+20, 0, cell.contentView.frame.size.width/7, 40)];
    totaltime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview_Outuser.frame)+8, 0,cell.contentView.frame.size.width/7, 40)];
    }
    else
    {
    
       label_date = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width/20, 0, cell.contentView.frame.size.width/7, 40)];
label_OutDate= [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width/2-5, 0, cell.contentView.frame.size.width/7, 40)];
           totaltime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview_Outuser.frame)-2, 0,cell.contentView.frame.size.width/7, 40)];
    
    }
    
    
     label_date.backgroundColor = [UIColor clearColor];
    label_date.font = [UIFont fontWithName:@"Helvetica" size:15];
    
    
    [cell.contentView addSubview:label_date];
    
    label_Time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label_date.frame)+10, 0, cell.contentView.frame.size.width/7, 40)];
    label_Time.backgroundColor = [UIColor clearColor];
    label_Time.font = [UIFont fontWithName:@"Helvetica" size:15];
    [cell.contentView addSubview:label_Time];
    
    
    imageview_user= [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label_Time.frame)-5, 2, cell.contentView.frame.size.width/8, 30)];
    imageview_user.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imageview_user];
    
    
    label_OutDate.backgroundColor = [UIColor clearColor];
    label_OutDate.font= [UIFont fontWithName:@"Helvetica" size:15];
    [cell.contentView addSubview:label_OutDate];
    
    
    label_OutTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label_OutDate.frame)+5, 0, cell.contentView.frame.size.width/7, 40)];
    label_OutTime.backgroundColor = [UIColor clearColor];
    label_OutTime.font = [UIFont fontWithName:@"Helvetica" size:15];
    [cell.contentView addSubview:label_OutTime];
    
    
    imageview_Outuser= [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label_OutTime.frame)-10, 2,cell.contentView.frame.size.width/8, 30)];
    imageview_Outuser.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imageview_Outuser];
    
 
    totaltime.backgroundColor = [UIColor clearColor];
    totaltime.font = [UIFont fontWithName:@"Helvetica" size:15];
    [cell.contentView addSubview:totaltime];
    
    
    
   // dispatch_async(dispatch_get_main_queue(), ^{

    _dictionary_profile=[_array_profileInfo objectAtIndex:indexPath.row];

    label_Time.text=[[_array_profileInfo objectAtIndex:indexPath.row] objectForKey:@"intime"];
        
    
        NSString *str=[[_array_profileInfo objectAtIndex:indexPath.row] objectForKey:@"indate"];
        NSString *str2=[[_array_profileInfo objectAtIndex:indexPath.row] objectForKey:@"outdate"];
        
        NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc]init];
        NSDateFormatter *dateFormatter_to = [[NSDateFormatter alloc]init];

        // here we create NSDateFormatter object for change the Format of date..
        [dateFormatter3 setDateFormat:@"yyyy-MM-dd"];
         [dateFormatter_to setDateFormat:@"yyyy-MM-dd"];
        //// here set format of date which is in your output date (means above str with format)
        
        NSDate *date = [dateFormatter3 dateFromString: str];
        NSDate *date_to = [dateFormatter_to dateFromString: str2];
     
        // here you can fetch date from string with define format
        
        dateFormatter3 = [[NSDateFormatter alloc]init];
        dateFormatter_to = [[NSDateFormatter alloc]init];

        [dateFormatter3 setDateFormat:@"MMM dd"];// here set format which you want...
        [dateFormatter_to setDateFormat:@"MMM dd"];// here set format which you want...

        NSString *convertedString = [dateFormatter3 stringFromDate:date]; //here convert date in NSString
        NSString *convertedString_to = [dateFormatter3 stringFromDate:date_to]; //here convert date in NSString

     //   //NSLog(@"Converted String : %@",convertedString);
     //   //NSLog(@"Converted String : %@",convertedString_to);

        label_date.text=convertedString;
        label_OutDate.text=convertedString_to;
        totaltime.adjustsFontSizeToFitWidth=YES;
    NSString *strtotal=[[_array_profileInfo objectAtIndex:indexPath.row] objectForKey:@"totaltime"];
    totaltime.text=strtotal;
    label_OutTime.text=[[_array_profileInfo objectAtIndex:indexPath.row] objectForKey:@"outtime"];
    label_date.adjustsFontSizeToFitWidth = YES;
    label_Time.adjustsFontSizeToFitWidth = YES;
    label_OutDate.adjustsFontSizeToFitWidth = YES;
    label_OutTime.adjustsFontSizeToFitWidth = YES;
        
       
   // });
    
    
    NSString *urlString = [[_array_profileInfo objectAtIndex:indexPath.row] objectForKey:@"inimage"];
    NSString *urlString1 = [[_array_profileInfo objectAtIndex:indexPath.row] objectForKey:@"outimage"];

    imageview_user.image = [UIImage imageNamed:@"logo-2"];
    imageview_Outuser.image = [UIImage imageNamed:@"logo-2"];

    
    NSURL *imageURL = [NSURL URLWithString:urlString];
    NSURL *imageURL1 = [NSURL URLWithString:urlString1];

    NSString *key = [urlString MD5Hash];
    NSString *key1 = [urlString MD5Hash];

    NSData *data = [FTWCache objectForKey:key];
    NSData *data1 = [FTWCache objectForKey:key];

    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        imageview_user.image = image;
        UIImage *image1 = [UIImage imageWithData:data1];
        imageview_Outuser.image=image1;
        
    } else {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            NSData *data1 = [NSData dataWithContentsOfURL:imageURL1];

            [FTWCache setObject:data forKey:key];
            [FTWCache setObject:data1 forKey:key1];

            UIImage *image = [UIImage imageWithData:data];
            UIImage *image1 = [UIImage imageWithData:data1];

            dispatch_sync(dispatch_get_main_queue(), ^{
                imageview_user.image = image;
                imageview_Outuser.image=image1;

                if (!data) {
                    imageview_user.image = [UIImage imageNamed:@"logo-2"];
                    imageview_Outuser.image = [UIImage imageNamed:@"logo-2"];
                }
            });
        });
    }
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        url_Img1 = [[_array_profileInfo objectAtIndex:indexPath.row] objectForKey:@"inimage"];
//        url_Img2 = [[_array_profileInfo objectAtIndex:indexPath.row] objectForKey:@"outimage"];
//        
//
//    NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_Img1]];
//    NSData *data2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_Img2]];
//        
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//         UIImage *image2 = [Utils imageWithImage:[UIImage imageWithData:data2] scaledToSize:CGSizeMake(30, 30)];
//        UIImage *image1 = [Utils imageWithImage:[UIImage imageWithData:data1] scaledToSize:CGSizeMake(30, 30)];
//        
//            imageview_user.image=image1;
//            imageview_Outuser.image=image2;
//       
//            });
//        });
//   
    
    return cell;

}

- (void)requestButton{
    
    
    MainViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:keyEmpIdViewControllerIdentifier];
    
    UINavigationController *nav = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:NO];
    
}


@end
