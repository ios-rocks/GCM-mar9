//
//  HolidaysLoginViewController.m
//  Employee
//
//  Created by Country Club on 06/02/16.
//  Copyright © 2016 Country Club. All rights reserved.
//
#define myurl @"http://www.countryclubworld.com/akhilapp/ccapp/index_v1.php/Employeecheckholiday"

#import "HolidaysLoginViewController.h"
#define keycolor @"#26AE90"
#import "HolidaysViewController.h"
@interface HolidaysLoginViewController ()<CountryClubModelDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarbutton;
@end

@implementation HolidaysLoginViewController
{
    UITextField *textfield_memID,*textfield_city;
    AppDelegate *appdelegate;
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customsetup];
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,30,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.textColor=[UIColor whiteColor];
    lbNavTitle.text = NSLocalizedString(@"Holidays",@"");
    self.navigationItem.titleView = lbNavTitle;
    [self buttonStup];
    [self Loginview];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)Loginview
{

    textfield_memID=[[UITextField alloc]initWithFrame:CGRectMake(3, self.view.frame.size.height/5, self.view.frame.size.width-10, 44)];
        textfield_memID.placeholder=@" Enter Membershipid";
    textfield_memID.font=[UIFont fontWithName:@"Helvitica" size:13];
    textfield_memID.background=[UIImage imageNamed:@"textline"];
    textfield_memID.tag=1;
    [textfield_memID AddCustomToolBarAndStartTextFiledTag:1 andEndFieldTag:2];
    [self.view addSubview:textfield_memID];
    
    
    textfield_city=[[UITextField alloc]initWithFrame:CGRectMake(3, CGRectGetMaxY(textfield_memID.frame), self.view.frame.size.width-10, 44)];
    textfield_city.placeholder=@" Select City";
    textfield_city.font=[UIFont fontWithName:@"Helvitica" size:13];
    textfield_city.background=[UIImage imageNamed:@"textline"];
    [self.view addSubview:textfield_city];
    textfield_city.tag=2;
    [textfield_city AddCustomToolBarAndStartTextFiledTag:2 andEndFieldTag:3];
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appdelegate.countryClub.delegate = self;
    [appdelegate.countryClub getMemberCitys];

    
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(3,CGRectGetMaxY(textfield_city.frame)+30, self.view.frame.size.width-10, 44)];
    [submit setTitle:@"Submit" forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor colorWithHexString:keycolor];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.layer.cornerRadius =5;
    submit.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
    submit.titleLabel.adjustsFontSizeToFitWidth = YES;
    [submit addTarget:self action:@selector(submitButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
    

}

-(void)sendMemberLoginCities:(NSMutableArray *)citiesArray
{
    if (citiesArray)
    {
        [textfield_city performSelectorOnMainThread:@selector(changeInputViewAsPickerView:) withObject:citiesArray waitUntilDone:YES];
    }

  
}
-(void)submitButton
{
    
    [self verify];
    
    
   }
-(void)buttonStup

{

    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [myButton setImage:[UIImage imageNamed:@"Home.png"] forState:UIControlStateNormal];
    
    myButton.frame = CGRectMake(0, 0, 40, 36);
    
    [myButton addTarget:self action:@selector(requestButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * aBarButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    
    self.navigationItem.rightBarButtonItem = aBarButton;


}



-(void)verify
{
    
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }

    
    [_gAppDelegate showLoadingView:YES activityTitle:@"Loading"];
    
    NSMutableDictionary *jsonDict=[NSMutableDictionary new];
    
    NSString *trimmedString = [textfield_memID.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [jsonDict setObject:trimmedString forKey:@"memberid"];
    [jsonDict setObject:textfield_city.text forKey:@"city"];
    
    NSURL *url=[NSURL URLWithString:myurl];
    NSMutableString *bodyString = [[NSMutableString alloc]init];
    for (id currentKey in jsonDict.allKeys)
    {
        if([[jsonDict valueForKey:currentKey] isKindOfClass:[NSString class]])
        {
            NSString *keyObject = (NSString *)currentKey;
            [bodyString appendFormat:@"%@=%@&",keyObject,[jsonDict valueForKey:keyObject]];
        }
    }
    NSData *inputData = [[NSData alloc]initWithBytes:[bodyString UTF8String] length:[bodyString length]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPBody:inputData];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[inputData length]] forHTTPHeaderField:@"Content-Length"];
    //  //NSLog(@"the data posting is %@", bodyString);
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
                                      {
                                          id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                          if (obj==nil)
                                          {
                                              [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];

                                          }
                                          NSDictionary *jsonDictionary=obj;
                                          //NSLog(@"data is %@ ",jsonDictionary);
                                    
                                          NSString *err=[jsonDictionary objectForKey:@"error"];
                                          
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              if ([err boolValue]==0)
                                              {
                                                  
                                                  
                                                  
                        HolidaysViewController *holidayVC=[self.storyboard instantiateViewControllerWithIdentifier:@"Feedback"] ;
                                                  
                                                  holidayVC.memid=textfield_memID.text;
                                                  holidayVC.memcity=textfield_city.text;
                                   holidayVC.holidays=jsonDictionary;
                                                  
                                                  [self.navigationController pushViewController:holidayVC animated:YES];
                                                  
                                                  
                                              }

                                                                                          else
                                              {
                                                  
                                                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login Failed" message:@" Please Check Empid and Mobile No and City" preferredStyle:UIAlertControllerStyleAlert];
                                                  
                                                  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                                  [alertController addAction:ok];
                                                  
                                                  [self presentViewController:alertController animated:YES completion:nil ];
                                                  
                                              }
                                              
                                          });
                                      }];
    
                                          
    [dataTask resume];
    [_gAppDelegate showLoadingView:NO activityTitle:nil];

    
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
    
}

- (void)requestButton{
    
    MainViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:keyEmpIdViewControllerIdentifier];
    
    UINavigationController *nav = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:NO];
    
}

-(void)customsetup

{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        _sidebarbutton.target=self.revealViewController;
        _sidebarbutton.action=@selector(revealToggle:);
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }



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
