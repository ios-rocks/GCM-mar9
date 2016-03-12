//
//  SalesLoginViewController.m
//  CCHH Sales
//
//  Created by Country Club on 05/01/16.
//  Copyright © 2016 Country Club. All rights reserved.
//
#import "SalesLoginViewController.h"
#import "NewMemberViewController.h"
#import "HistoryViewController.h"

@interface SalesLoginViewController ()
- (IBAction)History:(id)sender;
- (IBAction)Logout:(id)sender;

- (IBAction)newMember:(id)sender;
@end

@implementation SalesLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,30,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.textColor=[UIColor whiteColor];
    lbNavTitle.text = NSLocalizedString(@"Sales",@"");
    self.navigationItem.titleView = lbNavTitle;
    [self CreateMenu];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)CreateMenu
{
    
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
- (IBAction)History:(id)sender
{
    
    HistoryViewController *vc_New=
    [self.storyboard instantiateViewControllerWithIdentifier:@"history"];
    [self.navigationController pushViewController:vc_New animated:YES];
    
}

- (IBAction)Logout:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)newMember:(id)sender
{
    NewMemberViewController *vc_New=
    [self.storyboard instantiateViewControllerWithIdentifier:@"newmember"];
    [self.navigationController pushViewController:vc_New animated:YES];
   }
@end
