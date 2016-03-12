//
//  NewMemberViewController.m
//  Employee
//
//  Created by Country Club on 06/01/16.
//  Copyright © 2016 Country Club. All rights reserved.
//

#import "NewMemberViewController.h"
#import "MainViewController.h"
#import "AddMemberView.h"
#import "HistoryViewController.h"
@interface NewMemberViewController ()<CountryClubModelDelegate>
{
    NSMutableArray *array_venues;

}
@end
@implementation NewMemberViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self BarButton];
   // self.navigationController.navigationBarHidden=YES;
    self.title=@"New Member";
  //  self.navigationItem.hidesBackButton = YES;
    //[self GetVenues];
    [self AddNewMemberView];
    array_venues=[NSMutableArray new];
    
  
    // Do any additional setup after loading the view.
}
-(void)BarButton
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self AddNewMemberView];
    [super viewWillAppear:YES];
}

-(void)AddNewMemberView
{
    
    AddMemberView *mem=[[AddMemberView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    mem.delegate=self;
    [self.view addSubview:mem];
    
    
}

-(void)NewMemberData:(NSDictionary *)dic
{
    HistoryViewController *vc_History=[self.storyboard instantiateViewControllerWithIdentifier:@"history"];
    //NSLog(@"dic is %@ ",dic);
   // vc_History.memberDictionary=dic;
    [self.navigationController pushViewController:vc_History animated:YES];
    
 }



#define venueUrl @"http://countryclubworld.com/badriapp/index.php/add_details/getVenues/"

-(void)GetVenues
{
    
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }

    
    [_gAppDelegate showLoadingView:YES activityTitle:@"Loading"];
    
    NSString *uid=@"1";
    NSURL *url=[NSURL URLWithString:venueUrl];
    NSString *parameter = [NSString stringWithFormat:@"uid=%@",uid];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPBody:[parameter dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[parameter length]] forHTTPHeaderField:@"Content-Length"];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
                                      {
                                          id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                          NSDictionary *jsonDictionary=obj;
                                          NSArray *arr=[jsonDictionary objectForKey:@"venue_names"];
                                          for (int i=0; i<arr.count; i++)
                                          {
                                              NSString *dic=[[arr objectAtIndex:i] valueForKey:@"vname"];
                                              [array_venues addObject:dic];
                                          }
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                          });
                                      }];
    [dataTask resume];
    [_gAppDelegate showLoadingView:NO activityTitle:nil];
    
    
}




@end
