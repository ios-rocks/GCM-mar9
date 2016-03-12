//
//  LocatesViewController.m
//  CountryClub
//
//  Created by atsmacmini4 on 6/10/15.ffi
//  Copyright (c) 2015 atsmacmini4. All rights reserved.
//

#import "LocatesViewController.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "LocationsView.h"
#import "LocationsDetails.h"
#import <MessageUI/MFMailComposeViewController.h>
@interface LocatesViewController ()<CountryClubModelDelegate,MBProgressHUDDelegate,LocationsViewDelegate,UIActionSheetDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate>
{
    AppDelegate *app;
    MBProgressHUD *hud;
    LocationsView *loac;
    UIView *captureView,*GenralFeedbackView,*btnsView;
    UITextView *messageTextview,*subjectTextview;
     int feedbackViewStatus;
    UILabel *lbl,*lbl1;
}
@property(nonatomic,strong)IBOutlet UIBarButtonItem *revealButtonItem;
@end

@implementation LocatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
       UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,30,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.textColor=[UIColor whiteColor];
    lbNavTitle.text = NSLocalizedString(@"Locations",@"");
    self.navigationItem.titleView = lbNavTitle;
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [self customSetup];
  //  [self CreateLocationView];

//    [self SetnavigationbarColor];
    [self createBarbuttons];
    // Do any additional setup after loading the view.
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
    
    NSMutableArray *barbuttons=[[NSMutableArray alloc]init];
    
    [barbuttons addObject:rightbarbuttonCal];
    self.navigationItem.rightBarButtonItems=(NSMutableArray*)barbuttons;
    
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
-(void)viewWillAppear:(BOOL)animated{
    
   
    
    if ( app.locationscheck) {
        app.countryClub.delegate=self;
        [app.countryClub getLocationsData];
        [self CreateLocationView];
        
        [self showActivity];
    }
    else{
    app.countryClub.delegate=self;
    [app.countryClub getLocationsData];
    [self CreateLocationView];
    
    [self showActivity];
    }
    [super viewWillAppear:YES];
}
-(void)CreateLocationView{
    
    
    if ([[[UIDevice currentDevice]systemVersion] floatValue] < 6.2)
    {
        
        loac = [[LocationsView alloc]initWithFrame:CGRectMake(0,0,app.window.frame.size.width,app.window.frame.size.height-64)];
        loac.delegate = self;
        
    }
    else
    {
        loac = [[LocationsView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
        CGRect workingFrame=loac.frame;
        workingFrame.size.height -= self.navigationController.navigationBar.frame.size.height;
    
        loac.frame=workingFrame;
        loac.delegate = self;
        
        }
       [loac bringSubviewToFront:self.view];
    [self.view addSubview:loac];
}
-(void)showActivity{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma delegate methods
#pragma - mark Locations method
-(void)selectedLocation:(NSDictionary *)dic{
    
    
    
    [self showActivity];
    app.countryClub.delegate=self;
    [app.countryClub getDetailsOfVenue:[dic objectForKey:@"id"]];
    locationid=[dic objectForKey:@"id"];
//    //NSLog(@"%@",dic);
    
}
#pragma -mark delegate forlocations
-(void)sendDetailsOfVenue:(NSDictionary *)dic{
    [self performSelectorOnMainThread:@selector(sendData:) withObject:dic waitUntilDone:YES];
    [hud performSelectorOnMainThread:@selector(hide:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
}
-(void)sendData:(NSDictionary*)dic{
    app.locationscheck=YES;
    LocationsDetails *locations;
    locations=[[LocationsDetails alloc]init];
    locations.locationsDic=[[NSDictionary alloc]init];
    locations.locationsDic=dic;
    locations.idvalue=locationid;
//    //NSLog(@"%@",dic);
    [self.navigationController pushViewController:locations animated:YES];
    
    
}
-(void)sendLocationsData:(NSDictionary *)locationsDictionary
{
    
    [self performSelectorOnMainThread:@selector(sendlocation:) withObject:locationsDictionary waitUntilDone:YES];
    [hud performSelectorOnMainThread:@selector(hide:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    
    
}
-(void)sendlocation:(NSDictionary*)dic
{
    loac.locationsDictionary = dic;
    [loac dataReloadTables];
}
#pragma mark cal buttons
-(void)calAction
{
    
    
    
    MainViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:keyEmpIdViewControllerIdentifier];
    UINavigationController *nav = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:NO];
    

    
    
}


#pragma mark contact details

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
    
    return YES;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    //    [spinner stopAnimating];
    //    [image removeFromSuperview];
    if (result == MFMailComposeResultFailed) {
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:NSLocalizedString(@"Email", nil) message:NSLocalizedString(@"Email failed to send. Please try again.", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

    }
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [self dismissModalViewControllerAnimated:YES];
    
}

@end
