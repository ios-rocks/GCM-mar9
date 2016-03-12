//
//  SettingsViewController.m
//  Employee
//
//  Created by Country Club on 06/02/16.
//  Copyright © 2016 Country Club. All rights reserved.
//

#import "SettingsViewController.h"
#define keycolor @"#26AE90"

@interface SettingsViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarbutton;
@property(strong, nonatomic) UILabel *labelForCharCount;

@end

@implementation SettingsViewController
{
    UITextField *password;
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customsetup];
    [self buttonStup] ;
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,30,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.textColor=[UIColor whiteColor];
    lbNavTitle.text = NSLocalizedString(@"Settings",@"");
    self.navigationItem.titleView = lbNavTitle;
    [self CreateMenu];
    // Do any additional setup after loading the view.
}

-(void)CreateMenu

{

    password=[[UITextField alloc]initWithFrame:CGRectMake(3, self.view.frame.size.height/5, self.view.frame.size.width-10, 44)];
    password.rightView = self.labelForCharCount;
    password.rightViewMode=UITextFieldViewModeAlways;
    password.placeholder=@" Reset Your Password";
    password.delegate=self;
    password.font=[UIFont fontWithName:@"Helvitica" size:13];
    password.background=[UIImage imageNamed:@"textline"];
    [self.view addSubview:password];
    
    
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(3,CGRectGetMaxY(password.frame)+30, self.view.frame.size.width-10, 44)];
    [submit setTitle:@"Submit" forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor colorWithHexString:keycolor];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.layer.cornerRadius =5;
    submit.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
    submit.titleLabel.adjustsFontSizeToFitWidth = YES;
    [submit addTarget:self action:@selector(submitButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
    

}
-(UILabel*)labelForCharCount
{
    if (!_labelForCharCount) {
        _labelForCharCount= [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 40, 20)];
        _labelForCharCount.text = @"Above 5 Characters";
                _labelForCharCount.textColor=[UIColor lightGrayColor];
        _labelForCharCount.font = [ UIFont fontWithName: @"Arial" size: 14.0 ];
        [_labelForCharCount sizeToFit];
    }
    return _labelForCharCount;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result ;
  
    // if Group Subject textfeild is empty then disbled Next Button
       NSInteger length = (NSInteger)[[textField text] length] - range.length + string.length;
    // limit the group subject to 25 character only
        self.labelForCharCount.text = [NSString stringWithFormat:@"                %ld", labs(length)];
        result = YES;
    return result;
}


#define myurl @"http://www.ccilsupport.com/empapp/pwdup.php"
-(void)submitButton
{
    
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }

    
    
    if (password.text.length<5)
    {
        [_gAppDelegate showAlertView:YES message:@"Please Enter Above 5 Characters"];

    }
    else

    
    
    [_gAppDelegate showLoadingView:YES activityTitle:@"Loading"];
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *empid=[defaults objectForKey:@"empid"];
    NSString *city=[defaults objectForKey:@"city"];
    
    NSMutableDictionary *jsonDict=[NSMutableDictionary new];
    [jsonDict setObject:empid forKey:@"username"];
    [jsonDict setObject:city forKey:@"db"];
    [jsonDict setObject:password.text forKey:@"Phone"];
    
    
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
                                          NSDictionary *jsonDictionary=obj;
                                          //NSLog(@"pw  is %@ ",jsonDictionary);
                                        
                                          NSString *err=[jsonDictionary objectForKey:@"error"];
          
                                          if ([err boolValue]==0)
                                          {
                                              
                [_gAppDelegate showAlertView:YES message:@"Password Changed Successfully"];
                                          }
                                          else
                                              
                                          {
                                          
                    [_gAppDelegate showAlertView:YES message:@"Password Changed Failed"];
                                          
                                          }
                                          
                                          
                                          
                        }];
    
    
    [dataTask resume];


    [_gAppDelegate showLoadingView:NO activityTitle:nil];

}

- (void)requestButton{
    
    MainViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:keyEmpIdViewControllerIdentifier];
    
    UINavigationController *nav = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:NO];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden
{
    return YES;

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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;

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
