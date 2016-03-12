//
//  HistoryViewController.m
//  Employee
//
//  Created by Country Club on 06/01/16.
//  Copyright © 2016 Country Club. All rights reserved.
//

#import "HistoryViewController.h"
#import "MainViewController.h"
#import "HistoryTableViewCell.h"
#import "AppDelegate.h"
#import "MemberDetailsViewController.h"
@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HistoryViewController
{

    AppDelegate *app;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self BarButton];
   // self.navigationItem.hidesBackButton=YES;
   _table.delegate=self;
   _table.dataSource=self;
    
    self.title=@"History";
    self.navigationItem.title=@"History";
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    _memberDictionary=app.memberDictionary;
    self.view.backgroundColor=[UIColor darkGrayColor];
    
    
    
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    webServiceHelper *share1=[webServiceHelper new];
    //NSLog(@"histro uisd dic is %@ ",_memberDictionary);
    
    [_gAppDelegate showLoadingView:YES activityTitle:@"Loading"];
    [share1 GetHistory:[_memberDictionary valueForKey:@"uid"] Utype:[_memberDictionary  valueForKey:@"utype"]  completionBlock:^(NSArray *responseDictionry,NSInteger statuscode,NSError *error)
     
     {
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             //NSLog(@" object res is %@ ",[responseDictionry description]);
             self.memberArray=responseDictionry;
             [self.table reloadData];
             [_gAppDelegate showLoadingView:NO activityTitle:nil];
             
         });
         

         
     }];
    
    [super viewWillAppear:YES];
    


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
    
    MainViewController *vc=
    [self.storyboard instantiateViewControllerWithIdentifier:keyEmpIdViewControllerIdentifier];
    
    UINavigationController *nav = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:NO];
    
}

#pragma TableVieW

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.memberArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    HistoryTableViewCell *cell = (HistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
     cell.label_Time.adjustsFontSizeToFitWidth=YES;
    
   cell.label_Name.text=[[self.memberArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.label_Time.text=[[self.memberArray objectAtIndex:indexPath.row] objectForKey:@"add_time"];
   cell.label_Call.text=[[self.memberArray objectAtIndex:indexPath.row] objectForKey:@"update_time"];
    cell.label_LoadingProgress.text=[[self.memberArray objectAtIndex:indexPath.row] objectForKey:@"memship"];
    cell.label_LoadingProgress.adjustsFontSizeToFitWidth = YES;

    NSString *string=[NSString stringWithFormat:@"%@/n%@",[[self.memberArray objectAtIndex:indexPath.row] objectForKey:@"date"],[[self.memberArray objectAtIndex:indexPath.row] objectForKey:@"month"]];
    cell.label_Date.text=string;

    [_gAppDelegate showLoadingView:NO activityTitle:@""];

   return cell;


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    MemberDetailsViewController *memVC = [[MemberDetailsViewController alloc]init];
    
    NSIndexPath *selectedCatIndex = [self.table indexPathForSelectedRow];
    
    memVC.idmember=[[self.memberArray objectAtIndex:selectedCatIndex.row]objectForKey:@"id"];

    [self.navigationController pushViewController:memVC animated:NO];



}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
