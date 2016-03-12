//
//  ViewController.m
//  Employee
//
//  Created by Country Club on 31/10/15.
//  Copyright © 2015 Country Club. All rights reserved.
//

#import "ViewController.h"
#import "webServiceHelper.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "UITextField+CustomInputViews.h"
#define URL    @"http://www.ccilsupport.com/empapp/login.php/"  // change this URL
#define keycolor @"#26AE90"

@interface ViewController ()<UITextFieldDelegate>


@property(nonatomic) BOOL isViewMovdedUp;
@property(nonatomic) BOOL isValid;
@property(nonatomic,strong)NSMutableArray *array_cities;


@end

@implementation ViewController

{
    webServiceHelper *sharedWebService;
    NSTimer *time,*timer;
    UITextField *textfiled_City;
    UITextField *TextField_EmpId,*TextField_Mob;
    UIScrollView *scrollView;
    UIButton *LoginButton;

    int available;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    scrollView.showsVerticalScrollIndicator=YES;
    [self.view addSubview:scrollView];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
_array_cities=[NSMutableArray arrayWithObjects:@"opsindia",@"ccindia",@"cvindia",@"dubai",@"abudhabi",@"oman",@"bharain",@"doha",@"kenya",@"kuwait",@"malaysia",@"saudi",@"dubaihotel",@"london",@"conemp", nil];
    
    [_array_cities sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
   
    sharedWebService = [webServiceHelper sharedWebService];
   
    [self loginView];
    
    
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateRegistrationStatus:)
                                                 name:appDelegate.registrationKey
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showReceivedMessage:)
                                                 name:appDelegate.messageKey
                                               object:nil];


}

- (void) updateRegistrationStatus:(NSNotification *) notification {

    if ([notification.userInfo objectForKey:@"error"]) {
        [self showAlert:@"Error registering with GCM" withMessage:notification.userInfo[@"error"]];
    } else {
        
        NSLog(@" receved mesage is %@ ",[notification.userInfo objectForKey:@"message"]);
        
        NSString *message = @"Check the xcode debug console for the registration token that you can"
        " use with the demo server to send notifications to your device";
        [self showAlert:@"Registration Successful" withMessage:message];
    };
}

- (void) showReceivedMessage:(NSNotification *) notification {
    
    NSLog(@"Notification received: %@", notification.userInfo);

    
  //  NSString *message = notification.userInfo[@"aps"][@"alert"];
    
    NSString *message =[notification.userInfo objectForKey:@"message"];

    
    
    [self showAlert:@"Message received" withMessage:message];
}

- (void)showAlert:(NSString *)title withMessage:(NSString *) message{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        //iOS 8 or later
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:title
                                            message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:nil];
        
        [alert addAction:dismissAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


-(void)loginView
{
    
    UIImageView *imgLogin = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4,self.view.frame.size.height/6,120,120)];
    CGPoint centerImageView = imgLogin.center;
    centerImageView.x = self.view.center.x;
    imgLogin.center = centerImageView;
    [imgLogin setImage:[UIImage imageNamed:@"logo-2"]];
    [scrollView addSubview:imgLogin];
    
    TextField_EmpId = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/7, CGRectGetMaxY(imgLogin.frame)+15, self.view.frame.size.width-90, 35)];
    UIColor *color2 = [UIColor grayColor];
    TextField_EmpId.layer.borderWidth = 1;
    TextField_EmpId.layer.borderColor = [UIColor blackColor].CGColor;
    TextField_EmpId.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"  Enter Emp Id:" attributes:@{NSForegroundColorAttributeName : color2}];
    TextField_EmpId.tag=1;
    TextField_EmpId.keyboardType=UIKeyboardTypeASCIICapable;
    [TextField_EmpId AddCustomToolBarAndStartTextFiledTag:1 andEndFieldTag:2];
    TextField_EmpId.textAlignment=NSTextAlignmentCenter;
    TextField_EmpId.font=[UIFont systemFontOfSize:16.0];
    TextField_EmpId.delegate=self;
    TextField_EmpId.textColor=[UIColor blackColor];
    TextField_EmpId.layer.cornerRadius=5;
    
    [scrollView addSubview:TextField_EmpId];
    
    
    TextField_Mob = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/7, CGRectGetMaxY(TextField_EmpId.frame)+15, self.view.frame.size.width-90, 35)];
    UIColor *color3 = [UIColor grayColor];
    TextField_Mob.layer.borderWidth = 1;
    TextField_Mob.layer.borderColor = [UIColor blackColor].CGColor;
    TextField_Mob.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"  Enter Mob No:" attributes:@{NSForegroundColorAttributeName : color3}];
    TextField_Mob.tag=2;
   [TextField_Mob AddCustomToolBarAndStartTextFiledTag:2 andEndFieldTag:3];
    TextField_Mob.textAlignment=NSTextAlignmentCenter;
    TextField_Mob.font=[UIFont systemFontOfSize:16.0];
    TextField_Mob.delegate=self;
    TextField_Mob.textColor=[UIColor blackColor];
    TextField_Mob.layer.cornerRadius=5;
    [scrollView addSubview:TextField_Mob];
    

    
   textfiled_City = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/7, CGRectGetMaxY(TextField_Mob.frame)+15, self.view.frame.size.width-90, 35)];
    UIColor *color = [UIColor grayColor];
    textfiled_City.textAlignment=NSTextAlignmentCenter;
    textfiled_City.layer.borderWidth = 1;
    textfiled_City.delegate=self;
    textfiled_City.text=@"ccindia";
    textfiled_City.layer.borderColor = [UIColor blackColor].CGColor;
    textfiled_City.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@" Select City" attributes:@{NSForegroundColorAttributeName : color}];
    textfiled_City.font=[UIFont systemFontOfSize:16.0];
    textfiled_City.textColor=[UIColor blackColor];
    textfiled_City.layer.cornerRadius=5;
    textfiled_City.tag=3;
  [textfiled_City AddCustomToolBarAndStartTextFiledTag:3 andEndFieldTag:4];
    [scrollView addSubview:textfiled_City];
    
    LoginButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/5+20, CGRectGetMaxY(textfiled_City.frame)+20,  self.view.frame.size.width-160, 35)];
    [LoginButton setTitle:@"Login" forState:UIControlStateNormal];
    LoginButton.backgroundColor = [UIColor colorWithHexString:keycolor];
    [LoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LoginButton.layer.cornerRadius =5;
    LoginButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
    LoginButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [LoginButton addTarget:self action:@selector(LoginButtonActon) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:LoginButton];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height+30);

    
}

-(void)LoginButtonActon
{

    self.navigationController.navigationBar.hidden = YES;
    
     if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"please check inernet connection"];
        return;
    }
    
     [self VerifyEmp1];
//    NSString *valueToSave =TextField_EmpId.text;
//    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"empid"];
//    [[NSUserDefaults standardUserDefaults]setObject:textfiled_City.text forKey:@"city"];
//    [[NSUserDefaults standardUserDefaults] synchronize];

    
     /*  SWRevealViewController *ViewController_Attendance = [self.storyboard instantiateViewControllerWithIdentifier:@"hi"];
       [self.navigationController pushViewController:ViewController_Attendance animated:YES];
      [_gAppDelegate showLoadingView:NO activityTitle:nil];    */



}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

}


-(void)viewWillAppear:(BOOL)animated
{   [self.navigationController setNavigationBarHidden:YES];
    
    [super viewWillAppear:NO];
    TextField_EmpId.text=@"";
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }
    
    
   [textField myTextFieldDidEndEditing:textField];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField myTextFieldDidBeginEditing:textField];
    
       if (textField==textfiled_City)
    {
        
        [textfiled_City AddCustomToolBarAndStartTextFiledTag:3 andEndFieldTag:4];
        
        [textfiled_City performSelectorOnMainThread:@selector(changeInputViewAsPickerView:) withObject:self.array_cities waitUntilDone:YES];
        
        //NSLog(@" city is  %@ ",textfiled_City.text);


    }
}

-(void)VerifyEmp1
{
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }

  [_gAppDelegate showLoadingView:YES activityTitle:@"loading"];
    
    NSString *trimmedString = [TextField_EmpId.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
   NSString *getURL = [NSString stringWithFormat:@"%@?username=%@&db=%@&phone=%@", URL,trimmedString,textfiled_City.text,TextField_Mob.text];
  NSURL *url = [NSURL URLWithString: getURL];
 NSMutableURLRequest  *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
[request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error1)
                                      {
                                          
NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data                                                             options:kNilOptions error:nil];
                    
                                          if (jsonDict==nil)
                                          {
                                              [_gAppDelegate showAlertView:YES message:@"Please Enter Valid Details"];
                                          }
                        //NSLog(@"Response from Server : %@", jsonDict);
            NSString *status = [jsonDict objectForKey:@"error"];
            NSString *role=[jsonDict objectForKey:@"role"];
            NSString *dept=[jsonDict objectForKey:@"dept"];
            
                                          if ([role isKindOfClass:[NSString class]])
                                          {
                                              //NSLog(@"role value is %@ ",role);
                                              //NSLog(@"dept value is %@ ",dept);

                                          }
                                          else
                                          {
                                              //NSLog(@"role value is %@ ",role);
                                              //NSLog(@"dept value is %@ ",dept);

                                          }
                                          
                                          
                                          
           
    dispatch_async(dispatch_get_main_queue(), ^{

        if ([status isEqualToString:@"false"])
            
        {
                NSString *valueToSave =TextField_EmpId.text;
            [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"empid"];
        [[NSUserDefaults standardUserDefaults]setObject:textfiled_City.text forKey:@"city"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"login"];
            [[NSUserDefaults standardUserDefaults] setObject:role forKey:@"role"];
            [[NSUserDefaults standardUserDefaults] setObject:dept forKey:@"dept"];
    
        [[NSUserDefaults standardUserDefaults] synchronize];
            _isValid=YES;
            
            self.navigationController.navigationBar.hidden=YES;
            
            SWRevealViewController *ViewController_Attendance = [self.storyboard instantiateViewControllerWithIdentifier:@"hi"];
        [self.navigationController pushViewController:ViewController_Attendance animated:YES];

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


@end
