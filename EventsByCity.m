//
//  EventsByCity.m
//  CountryClubLive
//
//  Created by atsmacmini4 on 9/1/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import "EventsByCity.h"
#import "SelectedEventsDedtails.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "AppDelegate.h"
@interface EventsByCity ()<UITextViewDelegate,UIActionSheetDelegate,CountryClubModelDelegate,MFMailComposeViewControllerDelegate>{
    UILabel *Navlbl,*lbl,*lbl1;
    UIView *captureView,*GenralFeedbackView,*btnsView;
    UITextView *messageTextview,*subjectTextview;
    
   
    NSArray *loginStatusArray;
   
    int feedbackViewStatus;
}

@end

@implementation EventsByCity
-(void)createBarbuttons{
    UIButton *calBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    calBtn.frame=CGRectMake(0, 0, 44, 44);
    [calBtn setBackgroundImage:[UIImage imageNamed:@"Home"] forState:UIControlStateNormal];
    [calBtn addTarget:self action:@selector(calAction)
     forControlEvents:UIControlEventTouchUpInside];
    //    [calBtn setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *rightbarbuttonCal=[[UIBarButtonItem alloc]initWithCustomView:calBtn];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UIButton *emailBtn = [[UIButton alloc] init];
    emailBtn.frame=CGRectMake(0, 0, 44, 44);
    [emailBtn setBackgroundImage:[UIImage imageNamed:@"Message"] forState:UIControlStateNormal];
    //    [emailBtn setBackgroundImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateSelected];
    [emailBtn addTarget:self action:@selector(emailbtnAction)
       forControlEvents:UIControlEventTouchUpInside];
    //    [emailBtn setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *rightbarbuttonEmail=[[UIBarButtonItem alloc]initWithCustomView:emailBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    
    NSMutableArray *barbuttons=[[NSMutableArray alloc]init];
    
    [barbuttons addObject:negativeSpacer];
    [barbuttons addObject:rightbarbuttonEmail];
    //     [barbuttons addObject:negativeSpacer];
    [barbuttons addObject:rightbarbuttonCal];
    
    
    
    
    self.navigationItem.rightBarButtonItems=(NSMutableArray*)barbuttons;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.selectedArray=[[NSMutableArray alloc]init];
loginStatusArray=[app.countryClub isLogin];
    [self setupRightMenuButton];
        
           Navlbl=[[UILabel alloc]init];
        if (app.window.frame.size.width>380) {
            Navlbl.frame=CGRectMake(130, 2, 150, 40);
        }
       else if (app.window.frame.size.width>320) {
            Navlbl.frame=CGRectMake(110, 2, 150, 40);
        }

        else{
            Navlbl.frame=CGRectMake(85, 2, 150, 40);
        }

   
    Navlbl.textAlignment=NSTextAlignmentCenter;
    //    Navlbl.adjustsFontSizeToFitWidth=YES;
    Navlbl.textColor=[UIColor whiteColor];
    Navlbl.backgroundColor=[UIColor clearColor];
    [self.navigationController.navigationBar addSubview:Navlbl];
    
     defaultScreenRect=app.window.bounds;
     reqSysVer = @"6.2";
     currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
            
            if (defaultScreenRect.size.height == 480)
            {
                table.frame=CGRectMake(0, 40, 320,470);
            }
            else{
                table.frame=CGRectMake(0, 0, 320,548);
            }
        }
        else{
            if (defaultScreenRect.size.height == 480)
            {
                table.frame=CGRectMake(0, 0, 320,400);
            }
            else{
                table.frame=CGRectMake(0, 0, 320,508);
            }
            
        }

    // Do any additional setup after loading the view from its nib.
}
-(void)setupRightMenuButton{
    UIBarButtonItem *donebtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(DoneAcation)];
    
    
    [self.navigationItem setRightBarButtonItem:donebtn animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
     Navlbl.hidden=NO;
    if (self.selectedValue==20) {
        Navlbl.text=@"Select Property";
    }
    else{
        Navlbl.text=@"Select City";
    }
    [super viewWillAppear:YES];
}


-(void)DoneAcation{
    SelectedEventsDedtails *select;
    if (self.selectedArray.count==0) {
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"Please select one/more options from the list" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
      }
    else{

    select=[[SelectedEventsDedtails alloc]init];
    select.filteredarray=[[NSMutableArray alloc]init];
    select.filteredarray=  (NSMutableArray*)[self filterDataContent:self.selectedArray and:app.eventsArray];
    if (select.filteredarray.count==0) {
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"No events found for this city/place" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

     
    }
    else{
        
    
    [self.navigationController pushViewController:select animated:YES];
         }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    //NSLog(@"%lu",(unsigned long)self.eventsByCityArray.count);
    return self.eventsByCityArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString localizedStringWithFormat:@"Cell_%ld_%ld",(long)indexPath.section, (long)indexPath.row];
    //    static NSString *CellIdentifier = @"CustomCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if (self.selectedValue==20) {
        NSDictionary *dic=[self.eventsByCityArray objectAtIndex:indexPath.row];
        cell.textLabel.text=[dic objectForKey:@"resort"];

    }
    else{
    NSDictionary *dic=[self.eventsByCityArray objectAtIndex:indexPath.row];
        cell.textLabel.text=[dic objectForKey:@"city"];
        
    }
    
    if ([self.selectedArray containsObject:cell.textLabel.text]) {
        
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }


    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NSString *str=cell.textLabel.text;
    if (cell.accessoryType ==UITableViewCellAccessoryCheckmark) {
        cell.accessoryType= UITableViewCellAccessoryNone;
        [self.selectedArray removeObject:[NSString stringWithFormat:@"%@",str]];
    }
    else if (cell.accessoryType ==UITableViewCellAccessoryNone){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        [self.selectedArray addObject:str];
    }

    
}
-(NSArray *)filterDataContent:(NSArray *)valuesArray and:(NSArray *)totalArray
{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    
    for (NSString *currentValue in valuesArray)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@",currentValue];
        NSArray *array=[totalArray   filteredArrayUsingPredicate:predicate];
        [dataArray addObjectsFromArray:array];
    }
    
//    //NSLog(@"filter data is %@",dataArray);
    
    return dataArray;
}

-(void)viewWillDisappear:(BOOL)animated{
    Navlbl.hidden=YES;
    [super viewWillDisappear:YES];
}
#pragma mark cal buttons
-(void)calAction
{
    
    
    MainViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:keyEmpIdViewControllerIdentifier];
    UINavigationController *nav = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:NO];

    
    
    
    
}

-(void)emailbtnAction{
    }
#pragma mark contact details
-(void)calToNumber{
   }
-(void)calToNumberCRM
{
  
}



#pragma mark textView delegate methods
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.tag==4000) {
        lbl1.hidden=YES;
    }
    else{
        lbl.hidden=YES;
    }
    textView.textColor = [UIColor blackColor];
    //    if (textView.textColor == [UIColor lightGrayColor]) {
    //        textView.text = @"";
    //        textView.textColor = [UIColor blackColor];
    //    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        if(textView.tag==4000)
        {
            lbl1.hidden=NO;
            lbl1.textColor=[UIColor lightGrayColor];
            lbl1.text = @"Subject:";
        }
        else
        {
            lbl.hidden=NO;
            lbl.textColor=[UIColor lightGrayColor];
            lbl.text = @"Message";
        }
        [textView resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(textView.text.length == 0){
            
            textView.textColor = [UIColor lightGrayColor];
            if(textView.tag==4000)
            {
                lbl1.hidden=NO;
                lbl1.textColor=[UIColor lightGrayColor];
                
                lbl1.text = @"Subject:";
            }
            else
            {
                lbl.hidden=NO;
                lbl.textColor=[UIColor lightGrayColor];
                lbl.text = @"Message";
            }
            
            [textView resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}
-(void)countyClubModel_ResponseOfUserFeedback:(NSDictionary *)dic{
    GenralFeedbackView.hidden=YES;
    feedbackViewStatus=0;
    btnsView.hidden=YES;
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:[dic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
