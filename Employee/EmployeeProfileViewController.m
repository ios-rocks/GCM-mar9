//
//  EmployeeProfileViewController.m
//  Employee
//
//  Created by Country Club on 31/10/15.
//  Copyright © 2015 Country Club. All rights reserved.
//

#import "EmployeeProfileViewController.h"
#import "customCell.h"
#import "UINavigationBar+Addition.h"
#import "ProfileViewController.h"
#import "AttendanceViewController.h"
#import "MenuView.h"
#import "PaySlipViewController.h"
bool MENUVISIBLE = NO;

@interface EmployeeProfileViewController ()<MenuViewDelegate>
{
    UIImageView   *shadow;
    MenuView *menuView;
    UIImage *gulteLogo;
    EmployeeProfileViewController *vc_emp;

}
@property(strong,nonatomic) NSMutableArray *array_EmpInfo;
@property(strong,nonatomic) NSMutableArray *array_EmpInfoimages;


@end

@implementation EmployeeProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_gAppDelegate showLoadingView:NO activityTitle:@""];

    [self setNeedsStatusBarAppearanceUpdate];
   
      //hiding the navigation bar shadow border line color
  UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar hideBottomHairline];

    self.array_EmpInfo=[[NSMutableArray alloc]initWithObjects:@"Profile",@"Attendance",@"PaySlips",@"Logout", nil];
    _array_EmpInfoimages=[NSMutableArray arrayWithObjects:
                [UIImage imageNamed:@"Home_60x60.png"],
                [UIImage imageNamed:@"Profile_60.png"],
                [UIImage imageNamed:@"payslip_60x60.png"],[UIImage imageNamed:@"Logout_180x180.png"],nil];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.TableView_EmpInfo reloadData];
    [_buttin_right setHidden:YES];
    // Do any additional setup after loading the view.
}
- (BOOL)prefersStatusBarHidden {
    return YES;
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
    return 50.0f;
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
    
        PaySlipViewController *ViewController_PaySlip = [self.storyboard instantiateViewControllerWithIdentifier:keyPaySlipViewControllerIdentifier];
        [self.navigationController pushViewController:ViewController_PaySlip animated:YES];
    
    }
    else if (indexPath.row==3)
    {

    [self.navigationController popToRootViewControllerAnimated:YES];

    }
    
}
// menuview delegate method
-(void)menuViewButton_Clicked:(int)tag
{
    [self performSelectorInBackground:@selector(startActivityIndicator) withObject:nil];
    
    switch (tag)
    {
        case 1:
            
        {
            vc_emp =[self.storyboard instantiateViewControllerWithIdentifier:keyEmpIdViewControllerIdentifier];
            [self.navigationController pushViewController:vc_emp animated:YES];
        }
            
            break;
        case 2:
        {
            if([Utils isConnectedToNetwork])
            {
    
              
                AttendanceViewController *ViewController_Attendance = [self.storyboard instantiateViewControllerWithIdentifier:keyAttendanceViewControllerIdentifier];
                [self.navigationController pushViewController:ViewController_Attendance animated:YES];

                
            }
        }
            break;
        case 3:
        {
            if([Utils isConnectedToNetwork])
            {
               
                
                PaySlipViewController *ViewController_PaySlip = [self.storyboard instantiateViewControllerWithIdentifier:keyPaySlipViewControllerIdentifier];
                [self.navigationController pushViewController:ViewController_PaySlip animated:YES];
                

                
            }
        }
            break;
        case 4:
        {
            if([Utils isConnectedToNetwork])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];

                [self.navigationController popToRootViewControllerAnimated:YES];
                

                
            }
            
            
        }
            break;
       
        default:
            break;
    }
    [self performSelector:@selector(stopActivityIndicator) withObject:nil afterDelay:1];
}
-(void) startActivityIndicator
    
    [_gAppDelegate showLoadingView:YES activityTitle:@"Loading"];
}
-(void) stopActivityIndicator
{
    [_gAppDelegate showLoadingView:NO activityTitle:nil];
}


@end
