//
//  SalesViewController.m
//  Employee
//
//  Created by Country Club on 05/01/16.
//  Copyright © 2016 Country Club. All rights reserved.
//
#define keycolor @"#26AE90"
#define myurl @"http://countryclubworld.com/badriapp/index.php/login"
#import "SalesViewController.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"
#import "SalesLoginViewController.h"
#import "HistoryViewController.h"
#import "AppDelegate.h"

@interface SalesViewController ()<UITextFieldDelegate>
{

    UITextField *username;
    UITextField *password;
    BOOL Ismovedup;
    AppDelegate *app;
    UIScrollView *scrollView;
}
@end

@implementation SalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customSetup];
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,30,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.textColor=[UIColor whiteColor];
    lbNavTitle.text = NSLocalizedString(@"Sales",@"");
    self.navigationItem.titleView = lbNavTitle;
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    scrollView.showsVerticalScrollIndicator=YES;
    [self.view addSubview:scrollView];
    [self CreateMenu];
    [self loginView];
}

-(void)loginView
{
    
    UIImageView *imgLogin = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4,self.view.frame.size.height/9,120,120)];
    CGPoint centerImageView = imgLogin.center;
    centerImageView.x = self.view.center.x;
    imgLogin.center = centerImageView;
    [imgLogin setImage:[UIImage imageNamed:@"logo-2"]];
    [scrollView addSubview:imgLogin];
        username = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/7, CGRectGetMaxY(imgLogin.frame)+15, self.view.frame.size.width-90, 35)];
     UIColor *color2 = [UIColor grayColor];
    username.layer.borderWidth = 1;
    username.tag=1000;
    username.layer.borderColor = [UIColor blackColor].CGColor;
    username.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"  Username" attributes:@{NSForegroundColorAttributeName : color2}];
    username.keyboardType=UIKeyboardTypeASCIICapable;
    username.textAlignment=NSTextAlignmentCenter;
    username.font=[UIFont systemFontOfSize:16.0];
    [username AddCustomToolBarAndStartTextFiledTag:1000 andEndFieldTag:1002];
    username.delegate=self;
    username.textColor=[UIColor blackColor];
    username.layer.cornerRadius=9;
    [scrollView addSubview:username];
    
    password = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/7, CGRectGetMaxY(username.frame)+20, self.view.frame.size.width-90, 35)];
    UIColor *color = [UIColor grayColor];
    password.textAlignment=NSTextAlignmentCenter;
    password.layer.borderWidth = 1;
    password.tag=1001;
    [password setSecureTextEntry:YES];
    password.keyboardType=UIKeyboardTypeASCIICapable;
    password.layer.borderColor = [UIColor blackColor].CGColor;
    password.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"  Password" attributes:@{NSForegroundColorAttributeName : color}];
    password.font=[UIFont systemFontOfSize:16.0];
    password.textColor=[UIColor blackColor];
    [password AddCustomToolBarAndStartTextFiledTag:1000 andEndFieldTag:1002];
    password.delegate=self;
    password.layer.cornerRadius=5;
    [scrollView addSubview:password];
    
   UIButton *LoginButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/5+20, CGRectGetMaxY(password.frame)+20,  self.view.frame.size.width-160, 35)];
    [LoginButton setTitle:@"Login" forState:UIControlStateNormal];
    LoginButton.backgroundColor = [UIColor colorWithHexString:keycolor];
    [LoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LoginButton.layer.cornerRadius =5;
    LoginButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
    LoginButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [LoginButton addTarget:self action:@selector(LoginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:LoginButton];
    
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height+30);

}
-(void)LoginButtonAction
{
    
    
//   SalesLoginViewController *vc_sales=[self.storyboard instantiateViewControllerWithIdentifier:@"saleslogin"];
//    [self.navigationController pushViewController:vc_sales animated:YES];
        [self verify];

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
    [super viewWillAppear:YES];
    username.text=@"";
    password.text=@"";
    
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField myTextFieldDidBeginEditing:textField];
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField myTextFieldDidEndEditing:textField];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
   
    return YES;
    
}
- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarbutton setTarget: self.revealViewController];
        [self.sidebarbutton setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
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

-(void)verify
{
    
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }

    [_gAppDelegate showLoadingView:YES activityTitle:@"Loading"];

    NSMutableDictionary *jsonDict=[NSMutableDictionary new];
    NSString *trimmedString = [username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [jsonDict setObject:trimmedString forKey:@"email"];
    [jsonDict setObject:password.text forKey:@"password"];
    
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
                    //NSLog(@"data is %@ ",jsonDictionary);
                                          if (obj==nil)
                                          {
                                              [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
                                              
                                          }

                                          NSString *status=[jsonDictionary valueForKey:@"error_msg"];
                                          webServiceHelper *share=[webServiceHelper new];
                                          [share GetVenues:[jsonDictionary valueForKey:@"uid"] completionBlock:nil];
                                          [share GetVenues:[jsonDictionary valueForKey:@"uid"] completionBlock:nil];
                                          app=(AppDelegate *)[UIApplication sharedApplication].delegate;
                                          app.memberDictionary=jsonDictionary;
                                          app.string_uid=[jsonDictionary objectForKey:@"uid"];
                                          [share GetCategories:[jsonDictionary valueForKey:@"uid"]];
                    //[share GetHistory:[jsonDictionary valueForKey:@"uid"] Utype:[jsonDictionary valueForKey:@"utype"]];
  /* [share GetHistory:[jsonDictionary valueForKey:@"uid"] Utype:[jsonDictionary valueForKey:@"utype"]  completionBlock:^(NSArray *responseDictionry,NSInteger statuscode,NSError *error)
                                          
                                {
                                    //NSLog(@"his is %@ ",responseDictionry);
                                    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
                                    app.memberArray=responseDictionry;

                                }];  */

        dispatch_async(dispatch_get_main_queue(), ^{
                                          if ([status isEqualToString:@"Success"])
                                          {
                                              
                                              
          //  [_gAppDelegate showAlertView:YES message:[jsonDictionary valueForKey:@"error_msg"]];
            SalesLoginViewController *vc_sales=[self.storyboard instantiateViewControllerWithIdentifier:@"saleslogin"];
            [self.navigationController pushViewController:vc_sales animated:YES];
  }else     {      [_gAppDelegate showAlertView:YES message:[jsonDictionary valueForKey:@"error_msg"]];
      self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
      
                                          }   });
                                      }];
    [dataTask resume];
    [_gAppDelegate showLoadingView:NO activityTitle:nil];

}


@end
