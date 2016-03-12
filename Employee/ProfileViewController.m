//
//  ProfileViewController.m
//  Employee
//
//  Created by Country Club on 03/11/15.
//  Copyright © 2015 Country Club. All rights reserved.
//

#import "ProfileViewController.h"
#import "EmployeeProfileViewController.h"
#import "webServiceHelper.h"
#import "MBProgressHUD.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"
@interface ProfileViewController ()
@property(nonatomic,strong)NSMutableArray *array_profileInfo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarbtn;
@property(nonatomic,strong)NSDictionary *dictionary_profile;
@property (weak, nonatomic) IBOutlet UINavigationItem *item;
- (IBAction)h:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableview_Profile;
@property (weak, nonatomic) IBOutlet UILabel *label_userName;
@property (weak, nonatomic) IBOutlet UILabel *label_id;

@end

@implementation ProfileViewController

{

    webServiceHelper *sharedWebService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,30,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.textColor=[UIColor whiteColor];
    lbNavTitle.text = NSLocalizedString(@"Profile",@"");
    self.navigationItem.titleView = lbNavTitle;

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarbtn.target = self.revealViewController;
    _sidebarbtn.action = @selector(revealToggle:);
    // Set the gesture
 [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [myButton setImage:[UIImage imageNamed:@"Home.png"] forState:UIControlStateNormal];
    
    myButton.frame = CGRectMake(0, 0, 40, 36);
    
    [myButton addTarget:self action:@selector(requestButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * aBarButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    
    self.navigationItem.rightBarButtonItem = aBarButton;
    

    sharedWebService = [webServiceHelper sharedWebService];
      // [self ProfileData];
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_gAppDelegate showLoadingView:YES activityTitle:@"please Wait"];
    [self ProfileData];
    
    
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)ProfileData
{
    //[_gAppDelegate showLoadingView:YES activityTitle:@"please Wait"];

//     NSLog(@" default val is %@ ",[[NSUserDefaults standardUserDefaults]
//          objectForKey:@"empid"]);

    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"please check inernet connection"];
        [_gAppDelegate showLoadingView:NO activityTitle:nil];

        return;
    }

   
    [sharedWebService ProfileEmpNumber:[[NSUserDefaults standardUserDefaults]
                                        objectForKey:@"empid"] completionBlock:^(NSMutableDictionary *responseDictionry,NSInteger statuscode,NSError *error)
    
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
            //NSLog(@" object res is %@ ",[responseDictionry description]);
             _array_profileInfo=[responseDictionry objectForKey:@"empdetails"];
             //NSLog( @" data is %@ ",_array_profileInfo);
             ////NSLog(@" info is %@ ",[arr objectAtIndex:0]);
             _dictionary_profile=[_array_profileInfo objectAtIndex:0];
           //  NSString *str=[_dictionary_profile objectForKey:@"Name"];
             // _label_userName.text=[_dictionary_profile objectForKey:@"Name"];
             //NSLog(@"str dob is %@ ",str);
             [_tableview_Profile reloadData];
             [_gAppDelegate showLoadingView:NO activityTitle:@"please Wait"];
         
         });
         
         if (!error==0)
         {
             [_gAppDelegate showAlertView:YES message:@"error while  loading"];
         }
     
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
 }


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dictionary_profile.count;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    
     UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
       
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

        _label_id.text =[[_dictionary_profile objectForKey:@"Name"]uppercaseString];
    _label_userName.text=[[[NSUserDefaults standardUserDefaults]objectForKey:@"empid"]uppercaseString];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
         if (indexPath.row==0)
         {
                   cell.textLabel.text=@"Department";

             if ([[_dictionary_profile objectForKey:@"Department"] isEqualToString:@""])
             {
                 cell.detailTextLabel.text=@"0000000";
             }
             else
             cell.detailTextLabel.text=[_dictionary_profile objectForKey:@"Department"];
    
        }

        if (indexPath.row==1)
            {
            
            cell.textLabel.text=@"Designation";

            if ([[_dictionary_profile objectForKey:@"Designation"] isEqualToString:@""])
            {
                 cell.detailTextLabel.text=@"0000000";
            }
            else
                 cell.detailTextLabel.text=[_dictionary_profile objectForKey:@"Designation"];
        }
         if (indexPath.row==2)
         {
             cell.textLabel.text=@"Email";

             if ([[_dictionary_profile objectForKey:@"Email"] isEqualToString:@""])
             {
                  cell.detailTextLabel.text=@"0000000";
             }
             else

             cell.detailTextLabel.text=[_dictionary_profile objectForKey:@"Email"];
        }
        if (indexPath.row==3)
        {
            
              cell.textLabel.text=@"Contact No";
            if ([[_dictionary_profile objectForKey:@"Contact no"] isEqualToString:@""])
            {
                cell.detailTextLabel.text=@"0000000";
                
           }
            else

               cell.detailTextLabel.text=[_dictionary_profile objectForKey:@"Contact no"];
        
        }

        if (indexPath.row==4)

        {
             cell.textLabel.text=@"DOJ";
            if ([[_dictionary_profile objectForKey:@"DOJ"] isEqualToString:@""])
        {
            cell.detailTextLabel.text=@"0000000";
        }
        else

           cell.detailTextLabel.text=[_dictionary_profile objectForKey:@"Doj"];
        }
        if (indexPath.row==5)
            
            
        {
            cell.textLabel.text=@"Salary";

            
            if ([[_dictionary_profile objectForKey:@"Salary"] isEqualToString:@""])
        {
            cell.detailTextLabel.text=@"0000000";
        }
        else
            cell.detailTextLabel.text=[_dictionary_profile objectForKey:@"Salary"];
        }
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)h:(id)sender {
    
    
}
- (void)requestButton{
    
    MainViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:keyEmpIdViewControllerIdentifier];
    UINavigationController *nav = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:NO];
    
}
    
  @end
