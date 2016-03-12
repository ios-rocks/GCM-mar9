//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "PaySlipViewController.h"
#import "AttendanceViewController.h"
#import "ProfileViewController.h"
#import "ViewController.h"
#import "MainViewController.h"
#import "CCHHLiveViewController.h"
#import "SalesViewController.h"
#import "HolidaysLoginViewController.h"
@interface SidebarViewController ()

@end

@implementation SidebarViewController {

    AppDelegate *app;
    NSArray *menuItems; UITableViewCell *cell;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    menuItems=[[NSArray alloc]initWithObjects:@"title",@"home",@"profile",@"attandance",@"cchh",@"events",@"Locateus",@"sales",@"Holidays",@"Settings",@"logout", nil];
      [self.table setDelegate:self];
    [self.table setDataSource:self];
    [self.table reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];
   // [self.table reloadData];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return menuItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;

    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    app.AmcRmem=indexPath.row;
    
    if (indexPath.row==1)
    
    {

//       // self.navigationController.navigationBar.hidden = NO;
//        SWRevealViewController *ViewController_Attendance = [self.storyboard instantiateViewControllerWithIdentifier:@"hi"];
//    [self.navigationController pushViewController:ViewController_Attendance animated:YES];
    }
//   else  if (indexPath.row==3)
//      
//    {
//        app.AmcRmem=6;
//        
//        
//        [self performSegueWithIdentifier:@"sidebarevent" sender:self];
//        
//       
//    }
    
    if (indexPath.row==10)
    
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"login"];

        ViewController *vc_main=[self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
        [self.navigationController pushViewController:vc_main animated:YES ];
        
        }
}


-(void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    
      if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
      {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            
          UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
           }
}

@end
