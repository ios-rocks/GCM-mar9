//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "customCell.h"
#import "ViewController.h"
#import "UINavigationBar+Addition.h"
#import "ProfileViewController.h"
#import "AttendanceViewController.h"
#import "PaySlipViewController.h"
#import "CCHHLiveViewController.h"
#import "SalesViewController.h"
#import "HolidaysLoginViewController.h"
@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UITableView *TableView_EmpInfo;
@property(strong,nonatomic) NSMutableArray *array_EmpInfo;
@property(strong,nonatomic) NSMutableArray *array_EmpInfoimages;
@property(strong,nonatomic)UIView *captureView;
@end

@implementation MainViewController

{
    
    UIView *btnsView;
    AppDelegate *app;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Change button color
    
    
    
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,30,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.textColor=[UIColor whiteColor];
    lbNavTitle.text = NSLocalizedString(@"Home",@"");
    self.navigationItem.titleView = lbNavTitle;
    UIImage *img = [UIImage imageNamed:@"hamburger"];
    _sidebarButton.image = [img imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
//    _sidebarButton.target = self.revealViewController;
//    _sidebarButton.action = @selector(revealToggle:);
//    // Set the gesture
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [_gAppDelegate showLoadingView:NO activityTitle:@""];
    [self customSetup];

    self.array_EmpInfo=[[NSMutableArray alloc]initWithObjects:@"Profile",@"Attendance",@"Payslip",@"Live Feed",@"Events",@"Locate Us",@"Sales",@"Holidays",@"Logout", nil];
    _array_EmpInfoimages=[NSMutableArray arrayWithObjects:
                          [UIImage imageNamed:@"Profile1"],
                          [UIImage imageNamed:@"Profile"],
                          [UIImage imageNamed:@"payslip"],
                          [UIImage imageNamed:@"cchh"],
                          [UIImage imageNamed:@"events@2x"],
                          [UIImage imageNamed:@"locateter"],
                          [UIImage imageNamed:@"sales"],
                          [UIImage imageNamed:@"Holidays"],
                          [UIImage imageNamed:@"Logout"],nil];
 //   [self.TableView_EmpInfo reloadData];
    
    
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateRegistrationStatus:)
                                                 name:appDelegate.registrationKey
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showReceivedMessage:)
                                                 name:appDelegate.messageKey
                                               object:nil];

    
    
}


- (void) updateRegistrationStatus:(NSNotification *) notification {
    
    if ([notification.userInfo objectForKey:@"error"]) {
        [self showAlert:@"Error registering with GCM" withMessage:notification.userInfo[@"error"]];
    } else {
        
        NSLog(@" receved mesage is %@ ",[notification.userInfo objectForKey:@"message"]);
        
        NSString *message = @"Check the xcode debug console for the registration token that you can"
        " use with the demo server to send notifications to your device";
        [self showAlert:@"Registration Successful" withMessage:message];
    };
}

- (void) showReceivedMessage:(NSNotification *) notification {
    
    NSLog(@"Notification received: %@", [notification.userInfo description]);
    
    
    
   // NSString *message = notification.userInfo[@"aps"][@"alert"];
    
   NSString *message =[notification.userInfo objectForKey:@"message"];
    
    
    UILocalNotification* local = [[UILocalNotification alloc]init];
    if (local) {
        local.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
        local.alertBody = message;
        //local.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:local];
        
    }
    

    
    
  //  [_gAppDelegate showAlertView:YES message:message];

    
   // [self showAlert:@"Message received" withMessage:message];
}

- (void)showAlert:(NSString *)title withMessage:(NSString *) message{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        //iOS 8 or later
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:title
                                            message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:nil];
        
        [alert addAction:dismissAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}





- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}






-(void)viewWillAppear:(BOOL)animated
{


    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateRegistrationStatus:)
                                                 name:appDelegate.registrationKey
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showReceivedMessage:)
                                                 name:appDelegate.messageKey
                                               object:nil];


    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
       _captureView.hidden=YES;
        btnsView.hidden=YES;
    
    UIView *viewToRemove = [self.view viewWithTag:17];
    [viewToRemove removeFromSuperview];
    
    UIView *view=[self.view viewWithTag:18];
    [view removeFromSuperview];


}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    _captureView.hidden=YES;
    btnsView.hidden=YES;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event

{
    _captureView.hidden=YES;
    btnsView.hidden=YES;


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.array_EmpInfo.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    customCell *cell = (customCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[customCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }    
    cell.articlePhoto.image=[Utils makeImageToCircleShape:[_array_EmpInfoimages objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.articleHeader.text=[self.array_EmpInfo objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row==0)
    {
        
        ProfileViewController *ViewController_Profile = [self.storyboard instantiateViewControllerWithIdentifier:keyProfileViewControllerIdentifier];
        [self.navigationController pushViewController:ViewController_Profile animated:YES];
        
    }
    else if (indexPath.row==1)
        
    {
        AttendanceViewController *ViewController_Attendance = [self.storyboard instantiateViewControllerWithIdentifier:keyAttendanceViewControllerIdentifier];
        [self.navigationController pushViewController:ViewController_Attendance animated:YES];
        
        
    }
    else if (indexPath.row==2)
        
    {
        
        NSString *str=[[NSUserDefaults standardUserDefaults]objectForKey:@"role"];
        if ([str isEqualToString:@"1"])
            
        {
            [_gAppDelegate showAlertView:YES message:@"You are not authorized to access this Feature"];
            
        }
        if ([str isEqualToString:@"0"])


        {
            
        PaySlipViewController *ViewController_PaySlip = [self.storyboard instantiateViewControllerWithIdentifier:@"PaySlipView"];
        [self.navigationController pushViewController:ViewController_PaySlip animated:YES];
        }
        
    }
    
    else if(indexPath.row==3)
    {
    
        
        CCHHLiveViewController *viewController_CCHH=[self.storyboard instantiateViewControllerWithIdentifier:@"CCHHLiveViewController"];
        [self.navigationController pushViewController:viewController_CCHH animated:YES];
        
    
    }
    else if (indexPath.row==6)
    {
    
       
        SalesViewController *ViewCon_Sales=[self.storyboard instantiateViewControllerWithIdentifier:@"sales"];
        [self.navigationController pushViewController:ViewCon_Sales animated:YES];
    
    }
    
    else if (indexPath.row==7)
    {
        
        
        HolidaysLoginViewController *holidays=[self.storyboard instantiateViewControllerWithIdentifier:@"holidays"];
        [self.navigationController pushViewController:holidays animated:YES];
        
    }
    else if (indexPath.row==8)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"login"];

        ViewController *vc_main=[self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
        [self.navigationController pushViewController:vc_main animated:YES ];
        
    }
    
    
    else if (indexPath.row==5)
    {
        [self performSegueWithIdentifier:@"Locations" sender:nil];
    
    }
    
   else if (indexPath.row==4)
    {
        [self EventsSelection];
    }
    
    
    
}

-(void)EventsSelection
{
    
    _captureView=[[UIView alloc]init];
    _captureView.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    //    _captureView.center=self.view.center;
    _captureView.backgroundColor=[UIColor lightGrayColor];
    _captureView.alpha=0.8;
    _captureView.tag=17;
    [self.view addSubview:_captureView];
    btnsView=[[UIView alloc]init];
    btnsView.frame=CGRectMake((self.view.frame.size.width-250)/2, (self.view.frame.size.height-130)/2, 250,130);
    //    btnsView.center=self.view.center;
    btnsView.backgroundColor=[UIColor whiteColor];
    btnsView.tag=18;
    [self.view addSubview:btnsView];
    btnsView.layer.cornerRadius=3.0f;
    UIImageView *image=[[UIImageView alloc]init];
    image.frame=CGRectMake(0, 62, 60, 60);
    image.image=[UIImage imageNamed:@"eventimage.png"];
    [btnsView addSubview:image];
    UIImageView *image1=[[UIImageView alloc]init];
    image1.frame=CGRectMake(0, 5, 60, 60);
    image1.image=[UIImage imageNamed:@"eventNon-Image.png"];
    [btnsView addSubview:image1];
    UIButton *withImage=[UIButton buttonWithType:UIButtonTypeCustom];
    withImage.frame=CGRectMake(50, 70, 130, 40);
    [withImage setTitle:@"With Images" forState:UIControlStateNormal];
    [withImage addTarget:self action:@selector(eventwithimage) forControlEvents:UIControlEventTouchUpInside];
    [withImage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnsView addSubview:withImage];
    UIImageView *imagevi=[[UIImageView alloc]init];
    imagevi.frame=CGRectMake(0, 60, 250,2);
    imagevi.image=[UIImage imageNamed:@"feedbackLine"];
    [btnsView addSubview:imagevi];
    UIButton *withOutImage=[UIButton buttonWithType:UIButtonTypeCustom];
    withOutImage.frame=CGRectMake(50, 12, 200, 40);
    [withOutImage setTitle:@"Without Image (Faster)" forState:UIControlStateNormal];
    [withOutImage addTarget:self action:@selector(eventwithoutimage) forControlEvents:UIControlEventTouchUpInside];
    [withOutImage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnsView addSubview:withOutImage];
    
}
-(void)eventwithoutimage{
    [self performSegueWithIdentifier:@"Events" sender:nil];
}
-(void)eventwithimage{
    [self performSegueWithIdentifier:@"EventsWithimages" sender:nil];
}
@end
