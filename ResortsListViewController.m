//
//  ResortsListViewController.m
//  CountryClub
//
//  Created by atsmacmini4 on 4/16/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import "ResortsListViewController.h"
#import "CustomCellForProfile.h"
#import "BookingHolidayViewcontroller.h"
#import "MBProgressHUD.h"
#import "FTWCache.h"
#import "NSString+MD5.h"
//#import "bookingView.h"
@interface ResortsListViewController ()<CountryClubModelDelegate,MBProgressHUDDelegate,UITextViewDelegate,UIActionSheetDelegate>{
    UILabel *Navlbl;
    MBProgressHUD *hud;
    UITextView *messageTextview,*subjectTextview;
    UILabel *lbl,*lbl1;


}

@end

@implementation ResortsListViewController
@synthesize ResortsTable,hid,hlydaylenght;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    Navlbl=[[UILabel alloc]init];
    Navlbl.textColor=[UIColor whiteColor];
     Navlbl.backgroundColor=[UIColor clearColor];
   // self.automaticallyAdjustsScrollViewInsets=NO;
    app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    app.countryClub.delegate = self;
    self.resortsArray=[[NSMutableArray alloc]init];
    reqSysVer = @"6.2";
    currSysVer = [[UIDevice currentDevice] systemVersion];
    defaultScreenRect=app.window.bounds;
        Navlbl.text=@"Resorts";
    Navlbl.textAlignment=NSTextAlignmentCenter;
     Navlbl.adjustsFontSizeToFitWidth=YES;
    self.ResultLbl.hidden=YES;
    [self.navigationController.navigationBar addSubview:Navlbl];
    
    [_gAppDelegate showLoadingView:YES activityTitle:@"loading"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showActivity{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)viewDidAppear:(BOOL)animated{
    
//        //NSLog(@"%@",self.hid);
     //  [self showActivity];
        [self.ResortsTable reloadData];
    [super viewDidAppear:YES];
    
 //   //NSLog(@" resort array is %@ ",self.resortsArray);
 
}


#pragma TableViews Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
    return self.resortsArray.count;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString localizedStringWithFormat:@"Cell_%ld_%ld",(long)indexPath.section, (long)indexPath.row];
    //    static NSString *CellIdentifier = @"CustomCell";
    CustomCellForProfile *cell = (CustomCellForProfile *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        
        
        cell=[[CustomCellForProfile alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        NSArray *topLevelObjects;
                  topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCellForProfile" owner:nil options:nil];
        
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[CustomCellForProfile class]])
            {
                cell = (CustomCellForProfile *)currentObject;
                break;
            }
        }
    }
    
    
    NSString *string;
    NSString *string2;
    
       cell.resortName.text=[[self.resortsArray objectAtIndex:indexPath.row]objectForKey:@"ResName"];
    cell.city.text=[[self.resortsArray objectAtIndex:indexPath.row]objectForKey:@"city"];
    cell.resortType.text=[[self.resortsArray objectAtIndex:indexPath.row]objectForKey:@"rmType"];
    
   
        string=@"http://countryclubworld.com/resort/photos/";
        
        string2=[[self.resortsArray objectAtIndex:indexPath.row]objectForKey:@"image"];
        
        string2=[string stringByAppendingString:string2];

    cell.img.image = [UIImage imageNamed:@"logo-2"];
    
    NSURL *imageURL = [NSURL URLWithString:string2];
    NSString *key = [string2 MD5Hash];
    NSData *data = [FTWCache objectForKey:key];
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        cell.img.image = image;
        
    }
    
    else
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            [FTWCache setObject:data forKey:key];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_sync(dispatch_get_main_queue(), ^{
                cell.img.image = image;
                if (!data) {
                    cell.img.image = [UIImage imageNamed:@"logo-2"];
                }
            });
        });
    }

    [_gAppDelegate showLoadingView:NO activityTitle:nil];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.row==39)||(indexPath.row==40)||(indexPath.row==41))
    {
        [_gAppDelegate showAlertView:YES message:@"No holidays"];
        
    }
    
    else
    {
    
    //NSLog(@" hid is %@ ",self.holidaysArray);
    BookingHolidayViewcontroller *book;
    book=[[BookingHolidayViewcontroller alloc]init];
        book.resortName=[[self.resortsArray objectAtIndex:indexPath.row]objectForKey:@"ResName"];
         app.ResortName=book.resortName;
    NSDictionary *dic = [self.holidaysArray objectAtIndex:indexPath.row];
    NSString *hid1=[dic objectForKey:@"hid"];
    book.hid2=hid1;
    book.season=[[self.holidaysArray objectAtIndex:indexPath.row]objectForKey:@"season"];
    book.city=[[self.resortsArray objectAtIndex:indexPath.row]objectForKey:@"city"];
    book.memid=self.memid;
    book.memcity=self.memcity;
    book.roomtype=[[self.resortsArray objectAtIndex:indexPath.row]objectForKey:@"rmType"];
    book.rid=[[self.resortsArray objectAtIndex:indexPath.row]objectForKey:@"rid"];
    book.type=[[self.resortsArray objectAtIndex:indexPath.row]objectForKey:@"type"];
    book.currency=[[self.resortsArray objectAtIndex:indexPath.row]objectForKey:@"currency"];
    book.hldyLength=[[self.holidaysArray objectAtIndex:indexPath.row]objectForKey:@"hldyLgth"];
    
    //NSLog(@"booking details is %@,%@,%@,%@,%@,%@",hid1,book.rid,book.season,self.memid,self.memcity,book.currency);
    
    [self.navigationController pushViewController:book animated:YES];
    }
}




@end
