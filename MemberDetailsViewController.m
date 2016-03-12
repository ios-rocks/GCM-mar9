

//
//  MemberDetailsViewController.m
//
//  Copyright © 2016 Apple. All rights reserved.
//

#import "MemberDetailsViewController.h"
#import "HistoryViewController.h"
@interface MemberDetailsViewController ()

{
    
    NSDictionary *detailNamesDictionary;
    UILabel *headingLabel,*dataLabel;
}
@end

@implementation MemberDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self post];
    
    //self.navigationController.navigationItem.hidesBackButton=YES;
  //  self.navigationController.navigationBar.tintColor=[UIColor clearColor];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
//        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
//    view.backgroundColor=[UIColor brownColor];
//    [self.view addSubview:view];
//    
//    
 //  UILabel *header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    header.text = @"Member Details";
//    header.textAlignment=NSTextAlignmentCenter;
//    header.textColor = [UIColor whiteColor];
//    header.backgroundColor = [UIColor blueColor];
//    [view addSubview:header];
//    
//    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 5, 44, 44)];
//    [button setImage:[UIImage imageNamed:@"Home"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchDown];
//    [view addSubview:button];
    
   // [self GetHistory:@"1" Utype:@"1"];
    self.detailHeading = [[NSArray alloc]initWithObjects:@"Name",@"Mobile",@"Email",@"Venue Name",@"Category",@"Cat Price",@"Towards Mship Fee",@"DOB",@"Intro",@"Aggrement No",@"Spouse",@"Father",@"Mother",@"Children1",@"Children2",@"Children3",@"Entry Time",@"Call time",@"Time Taken",@"Current Status", nil];
    
self.detailNames = [[NSArray alloc]initWithObjects:@"name",@"mobile",@"email",@"vname",@"catname",@"price",@"tmf",@"dob",@"intro",@"aggrement_no",@"spouse",@"parent",@"mother",@"child",@"child2",@"child3",@"view_time",@"update_time",@"timestamp",@"status", nil];
    
    self.detailsScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,10, self.view.frame.size.width, self.view.frame.size.height)];
    
    UIView *bck = [[UIView alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width/2-10, 7*50)];
    bck.backgroundColor = [UIColor whiteColor];
    [self.detailsScroll addSubview:bck];
    
    UIView *bck1 = [[UIView alloc]initWithFrame:CGRectMake(5,7*50, self.view.frame.size.width/2-10, 10*50)];
    bck1.backgroundColor = [UIColor whiteColor];
    [self.detailsScroll addSubview:bck1];
    
    UIView *bck2 = [[UIView alloc]initWithFrame:CGRectMake(5,17*50, self.view.frame.size.width/2-10, 4*50)];
    bck2.backgroundColor = [UIColor whiteColor];
    [self.detailsScroll addSubview:bck2];

    
    for (int i = 0; i<[self.detailNames count]; i++)
    {
        headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, i*50, self.view.frame.size.width/2-10, 30)];
        headingLabel.textAlignment = NSTextAlignmentCenter;
        headingLabel.adjustsFontSizeToFitWidth=YES;
        [headingLabel setFont:[UIFont systemFontOfSize:12]];

        headingLabel.text = [NSString stringWithFormat:@"%@",[self.detailHeading objectAtIndex:i]];
        [self.detailsScroll addSubview:headingLabel];
        
     /*   dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+5, i*50, self.view.frame.size.width/2-10, 30)];
        dataLabel.textAlignment = NSTextAlignmentCenter;
        //NSLog(@"data is %@ ",detailNamesDictionary);
    dataLabel.text = [NSString stringWithFormat:@"%@",[detailNamesDictionary objectForKey:[self.detailNames objectAtIndex:i]]];
        [self.detailsScroll addSubview:dataLabel]; */
    }
    [self.view addSubview:self.detailsScroll];
    self.detailsScroll.contentSize = CGSizeMake(0, [self.detailNames count]*50);
    
    
}

-(void)home
{
    
    HistoryViewController *hs=[HistoryViewController new];
 //   [self presentViewController:hs animated:NO completion:nil];
    [self.navigationController pushViewController:hs animated:YES];
    
    
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#define myurl @"http://countryclubworld.com/badriapp/index.php/add_details/getMemberDetailsHistory/"

-(void)post

{
    
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }

    [_gAppDelegate showLoadingView:YES activityTitle:@"Pease Wait"];

    NSMutableDictionary *jsonDict=[NSMutableDictionary new];
    
    [jsonDict setObject:_idmember forKey:@"wid"];
    [jsonDict setObject:@"1" forKey:@"uid"];
    
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
                                      //  //NSLog(@"data is %@ ",jsonDictionary);
                                    
                                          NSArray *arr=[jsonDictionary objectForKey:@"mem_details"];
                                          
                                         //NSLog(@"details  is %@ ",arr);
                                    
                            dispatch_async(dispatch_get_main_queue(),^(void)
                                          {
                                          
                                          
                                detailNamesDictionary=[arr objectAtIndex:0];
                              //  //NSLog(@"dic  is %@ ",detailNamesDictionary);
                                
                                              
                                              for (int i = 0; i<[self.detailNames count]; i++)
                                              {
            dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+5, i*50, self.view.frame.size.width/2-10, 30)];
                    dataLabel.textAlignment = NSTextAlignmentCenter;
            [dataLabel setFont:[UIFont systemFontOfSize:12]];

            dataLabel.adjustsFontSizeToFitWidth=YES;
       // //NSLog(@"data is %@ ",detailNamesDictionary);
dataLabel.text = [NSString stringWithFormat:@"%@",[detailNamesDictionary objectForKey:[self.detailNames objectAtIndex:i]]];
                    [self.detailsScroll addSubview:dataLabel];
                                                  
                                              }
                           //     NSString *str=[detailNamesDictionary objectForKey:@"aggrement_no"];
                                //NSLog(@"dic  string  is %@ ",str);
                                
                                          });
                                         

 
                                      }];

    [dataTask resume];
    [_gAppDelegate showLoadingView:NO activityTitle:nil];


}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
