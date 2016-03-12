//
//  PaySlipViewController.m
//  Employee
//
//  Created by Country Club on 09/11/15.
//  Copyright © 2015 Country Club. All rights reserved.
//

#import "PaySlipViewController.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"
@interface PaySlipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textfield_MonthYear;
- (IBAction)tap:(id)sender;
- (IBAction)button_Submit:(id)sender;
@property (nonatomic, strong) NSDateFormatter *dateFormatter,*dateFormater1;

@property(nonatomic,strong)NSMutableArray *array_profileInfo;
@property(nonatomic,strong)NSDictionary *dictionary_profile,*dictionary_profile1;
@property (nonatomic, strong) NSArray *contents,*contents1;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidentn;

@property (weak, nonatomic) IBOutlet SKSTableView *tableView;


@end

@implementation PaySlipViewController
#define urlattedance   @"http://www.ccilsupport.com/empapp/payslip2.php"

{
    UIBarButtonItem * aBarButton1;
    UIDatePicker *picker;
    NSDictionary *object;
    UIButton *myButton1;
    NSString *from;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
        self.tableView.SKSTableViewDelegate = self;
    
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,30,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.textColor=[UIColor whiteColor];
    lbNavTitle.text = NSLocalizedString(@"Payslip",@"");
    self.navigationItem.titleView = lbNavTitle;

    self.navigationItem.hidesBackButton = YES;
    [self CreateMenu];
    
        // In order to expand just one cell at a time. If you set this value YES, when you expand an cell, the already-expanded cell is collapsed automatically.
    self.tableView.shouldExpandOnlyOneCell = YES;
    [_tableView setHidden:YES];
 }

-(void)CreateCustomView
{
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidentn.target = self.revealViewController;
    _sidentn.action = @selector(revealToggle:);
    // Set the gesture
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
}
-(void)CreateMenu

{
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [myButton setImage:[UIImage imageNamed:@"Home.png"] forState:UIControlStateNormal];
    
    myButton.frame = CGRectMake(0, 0, 40, 36);
    
    [myButton addTarget:self action:@selector(requestButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * aBarButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    
    // self.navigationItem.rightBarButtonItem = aBarButton;
    [self CreateCustomView];
    
    myButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [myButton1 setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    
    myButton1.frame = CGRectMake(200, 0, 40, 36);
    
    [myButton1 addTarget:self action:@selector(button_aharePayslip) forControlEvents:UIControlEventTouchUpInside];
    
    aBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:myButton1];
    myButton1.hidden=YES;
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:aBarButton, aBarButton1, nil];


}
- (NSArray *)contents
{
    if (!_contents)
    {
        _contents = @[
                      @[
                          @[@"RATE", @"GROSS",@"BASIC",@"HRA",@"TRANS.ALL",@"EDI.ALLOW",@"MED.ALLO",@"OTHER.ALL",@"CONVE",@"TOTAL"],
                          @[@"EARNINGS",@"BASIC",@"HRA",@"TRANS.ALL",@"EDI.ALLOW",@"MED.ALLO",@"EAR_OTHER",@"CONVE"],
                          
                          @[@"DEDUCTIONS",@"PF",@"E.S.I",@"PRO.TAX",@"LOAN",@"OTHER",@"LOP",@"Total"],
                          
                          @[@"ATTENDENCE",@"MONTH DAYS",@"PRESENTDAYS",@"P.H",@"W.O",@"LOP",@"PAID DAYS",@"Net SalarY"]
                          
                          ],
                      
                      ];
    }
    
    return _contents;
}


- (NSArray *)contents1
{
    if (!_contents1)
    {
        _contents1 = @[
                      @[
                          @[@"", [_dictionary_profile objectForKey:@"GROSS"],[_dictionary_profile objectForKey:@"BASIC"],[_dictionary_profile objectForKey:@"HRA"],[_dictionary_profile objectForKey:@"TRANS.ALL"],[_dictionary_profile objectForKey:@"EDI.ALLOW"],[_dictionary_profile objectForKey:@"MED.ALLO"],[_dictionary_profile objectForKey:@"OTHER.ALL"],[_dictionary_profile objectForKey:@"CONVE"],[_dictionary_profile objectForKey:@"TOTALG"]],
                          @[@"",[_dictionary_profile objectForKey:@"BASIC"],[_dictionary_profile objectForKey:@"HRA"],[_dictionary_profile objectForKey:@"TRANS.ALL"],[_dictionary_profile objectForKey:@"EDI.ALLOW"],[_dictionary_profile objectForKey:@"MED.ALLO"],[_dictionary_profile objectForKey:@"OTHER.ALL"],[_dictionary_profile objectForKey:@"totale"]],
                          @[@"",[_dictionary_profile objectForKey:@"PF"],[_dictionary_profile objectForKey:@"E.S.I"],[_dictionary_profile objectForKey:@"PRO.TAX"],[_dictionary_profile objectForKey:@"LOAN"],[_dictionary_profile objectForKey:@"OTHER"],[_dictionary_profile objectForKey:@"LOP"],[_dictionary_profile objectForKey:@"TOTALD"]],
                          @[@"",[_dictionary_profile1 objectForKey:@"MONTH DAYS"],[_dictionary_profile1 objectForKey:@"PRESENTDAYS"],[_dictionary_profile1 objectForKey:@"P.H"],[_dictionary_profile1 objectForKey:@"W.O"],[_dictionary_profile objectForKey:@"LOP"],[_dictionary_profile objectForKey:@"PAID DAYS"],[_dictionary_profile objectForKey:@"NET SALARY"]]
                          
                          ],
                      
                      ];
    }
    
    return _contents1;
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.contents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contents[section] count];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.contents[indexPath.section][indexPath.row] count] - 1;
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        return YES;
    }
    
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:13.0];

    cell.textLabel.text = self.contents[indexPath.section][indexPath.row][0];
    
    if ((indexPath.section == 0 && (indexPath.row == 0 ||indexPath.row==1 || indexPath.row==2 || indexPath.row == 3)))
        cell.expandable = YES;
    
    else
        cell.expandable = NO;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *CellIdentifier = nil;
    
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
   if (!cell)
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
   
    
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
     cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0];
   cell.textLabel.text = [NSString stringWithFormat:@"%@", self.contents[indexPath.section][indexPath.row][indexPath.subRow]];
 UILabel *lbl = [[UILabel alloc] initWithFrame: CGRectMake(cell.contentView.frame.size.width/2,2,150,30)];
  lbl.font=[UIFont fontWithName:@"Helvetica" size:15.0];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
  lbl.adjustsFontSizeToFitWidth = YES;

    lbl.text=[NSString stringWithFormat:@"%@", self.contents1[indexPath.section][indexPath.row][indexPath.subRow]];
    [cell.contentView addSubview:lbl];
    
   

    return cell;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark - Actions
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)getPaySlip
{
    
    
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }

    [_gAppDelegate showLoadingView:YES activityTitle:@"loading"];
    NSString *str1_YEAR=[from substringFromIndex:3] ;
    NSString *str2=[from substringToIndex:2];
    //NSLog(@"  str1 %@   and  %@ ",str2,str1_YEAR);
    NSString *empid= [[NSUserDefaults standardUserDefaults]objectForKey:@"empid"];
   NSString *city=[[NSUserDefaults standardUserDefaults]objectForKey:@"city"];
    NSString *urlString = [NSString stringWithFormat:@"%@?username=%@&month=%@&db=%@&year=%@",urlattedance,empid,str2,city,str1_YEAR];
    
    NSURL *url =[NSURL URLWithString:urlString];
    
    NSURLSession *session =[NSURLSession sharedSession];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
                                      {
                                          object=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                       // NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                                         //NSLog(@" object description is %@ ",[object description]);
                                         // //NSLog(@"response is %@ ",httpResponse);
                                          
                                          if (object==nil)
                                          {
                                              [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
                                              
                                          }

                                       dispatch_async(dispatch_get_main_queue(), ^{
                                          NSString *str=[object objectForKey:@"error"];
                                           if ([str isEqualToString:@"false"])
                                          {
                                              _array_profileInfo=[object objectForKey:@"empdetails"];
                                              [self.tableView setHidden:NO];

                                              _dictionary_profile=[_array_profileInfo objectAtIndex:0];
                                              _dictionary_profile1=[_array_profileInfo objectAtIndex:1];
                                              myButton1.hidden=NO;

                                              return;
                                              
                                          }
                                           
                                       if ([[object objectForKey:@"error"] isEqualToString:@"true"])
                                       {
                                           self.tableView.hidden=YES;

                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid Month" message:@"Please Enter Valid Month" preferredStyle:UIAlertControllerStyleAlert];
                                           
                                           UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                           [alertController addAction:ok];
                                           
                                           [self presentViewController:alertController animated:YES completion:nil];

                                              return;
                                          }
                                         
                                       } );

                                      }];
    [dataTask resume];
    [_gAppDelegate showLoadingView:NO activityTitle:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)Date:(id)sender
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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
    [_dateFormatter setDateFormat:@"MMM YYYY "];
    NSString *str=[NSString stringWithFormat:@"%@",[_dateFormatter  stringFromDate:picker.date]];
    
    _dateFormater1=[[NSDateFormatter alloc] init];
    [_dateFormater1 setDateFormat:@"MM-YYYY"];
    
    self.textfield_MonthYear.text = str;
    
    from=[NSString stringWithFormat:@"%@",[_dateFormater1  stringFromDate:picker.date]];
    
    //NSLog(@" from is  %@   ",from);


    self.textfield_MonthYear.text = str;
    
}

- (IBAction)tap:(id)sender {
    [self Date:sender];
}
- (IBAction)button_Submit:(id)sender {
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showLoadingView:NO activityTitle:nil];
        [_gAppDelegate showAlertView:YES message:@"please check inernet connection"];
        
        return;
    }
    

    
    if ([_textfield_MonthYear.text isEqual:@""])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please Enter month and year" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    
       [self getPaySlip];
  }

- (void)button_aharePayslip {
    
    
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }

     [_gAppDelegate showLoadingView:YES activityTitle:@"loading"];
    NSString *str1_YEAR=[from substringFromIndex:3] ;
    NSString *str2=[from substringToIndex:2];
    //NSLog(@"  str1 %@   and  %@ ",str2,str1_YEAR);
    NSString *empid= [[NSUserDefaults standardUserDefaults]objectForKey:@"empid"];
    NSString *city=[[NSUserDefaults standardUserDefaults]objectForKey:@"city"];

    NSString *parameter = [NSString stringWithFormat:@"username=%@&month=%@&db=%@&year=%@",empid, str2,city, str1_YEAR];

    NSString *myurl=@"http://www.ccilsupport.com/empapp/mail1.php?";
    NSURL *url=[NSURL URLWithString:myurl];
    
     NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPBody:[parameter dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
                                          {
                                          
                          //  NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *)response;
                                              
                    //NSLog(@" reponse is %@ ",httpResponse);
                        //NSLog(@"  response is %ld ",(long)httpResponse.statusCode);
        [_gAppDelegate showLoadingView:NO activityTitle:@""];
        id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        object=obj;
        
        if (object==nil)
        {
            [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
            
        }

        NSDictionary *dic_payslip=object;
        NSString *status=[dic_payslip objectForKey:@"error"];
        
      //  NSLog( @"   mail res is %@ ",[obj description]);
        
             if ([status isEqualToString:@"false"])

                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Email" message:@"Mail Sent Successfully" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }
                    else
                    {
                    
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Mail sending Failed" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    
                    
                    }
        
    });
     
    }];
    
    [dataTask resume];
}

- (void)requestButton{
    
    
    MainViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:keyEmpIdViewControllerIdentifier];
    
    UINavigationController *nav = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:NO];
    
}

@end
