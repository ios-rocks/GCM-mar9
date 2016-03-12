//
//  SelectedEventsDedtails.m
//  CountryClubLive
//
//  Created by atsmacmini4 on 9/1/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import "SelectedEventsDedtails.h"
#import "EventsCell.h"
#import "MBProgressHUD.h"
#import "EventDetails.h"
#import "CountryClubModel.h"
#import "UIImageView+WebCache.h"
#import "CustomCellForProfile.h"
@interface SelectedEventsDedtails ()<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>{
        MBProgressHUD *hud;
    UILabel  *Navlbl;
    UIView *captureView,*GenralFeedbackView,*btnsView;
    UITextView *messageTextview,*subjectTextview;
    int feedbackViewStatus;
    NSMutableArray *finalSectionwiseDataArray;
    NSArray *titlesArray;
}

@end

@implementation SelectedEventsDedtails

- (void)viewDidLoad {
    [super viewDidLoad];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    app.countryClub.delegate=self;
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
    }
    else{
        Navlbl=[[UILabel alloc]init];
        if (app.window.frame.size.width>380) {
            Navlbl.frame=CGRectMake(130, 2, 150, 40);
        }
        else if (app.window.frame.size.width>320){
            Navlbl.frame=CGRectMake(110, 2, 150, 40);
            
        }
        else{
            Navlbl.frame=CGRectMake(85, 2, 150, 40);
        }
    }
    Navlbl.textAlignment=NSTextAlignmentCenter;
    //    Navlbl.adjustsFontSizeToFitWidth=YES;
    Navlbl.textColor=[UIColor whiteColor];
    Navlbl.backgroundColor=[UIColor clearColor];
    Navlbl.text=@"Events";
    [self.navigationController.navigationBar addSubview:Navlbl];

    defaultScreenRect=app.window.bounds;
    reqSysVer = @"6.2";
    currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
            }
    else{
        
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
    }
    if (app.viewControllerStatus==11) {
        titlesArray=[[NSArray alloc]init];
        finalSectionwiseDataArray=[[NSMutableArray alloc]init];
        NSArray *arr=[self.filteredarray valueForKey:@"eventDate"];
        NSSet *set=[NSSet setWithArray:arr];
        arr=[set allObjects];
        NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending:YES];
        
        NSArray *allValuess = [arr sortedArrayUsingDescriptors:@[sortOrder]];
//        //NSLog(@"%@",allValuess);
        titlesArray=allValuess;
        for (int i=0; i<arr.count; i++) {
           
                NSMutableArray *SubfilterArray=[NSMutableArray new];
            
                for (int j=0; j<self.filteredarray.count; j++) {
                    
                    NSDictionary *dic=[self.filteredarray objectAtIndex:j];
                    if ([[dic valueForKey:@"eventDate"] isEqualToString:[allValuess objectAtIndex:i]]) {
                        [SubfilterArray addObject:dic];
                    }
                }
                [finalSectionwiseDataArray addObject:SubfilterArray];
            }

    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)checkExpiredEvents:(NSInteger)indexpath{
    
    NSDictionary *dic=[app.eventsArray objectAtIndex:indexpath];
    BOOL ispreviousdate = NO;
    
    
    NSString *currentdate=[dic
                           objectForKey:@"cdate"];
    NSString *eventdate=[dic
                         objectForKey:@"eventDate"];
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    NSDate *date = [dateFormatter dateFromString:[dic objectForKey:@"eventTime"]];
    dateFormatter.dateFormat = @"HH:mm";
    NSString *time24 = [dateFormatter stringFromDate:date];
    
    NSString *finalCurrentdateString=[NSString stringWithFormat:@"%@ %@",currentdate,[dic objectForKey:@"ctime"]];
    NSString *finalEventdateString=[NSString stringWithFormat:@"%@ %@",eventdate,time24];
    
    
    NSComparisonResult result = [finalCurrentdateString compare:finalEventdateString];
    
    switch (result)
    {
        case NSOrderedAscending:
        {
            ispreviousdate=NO;
        }
            break;
        case NSOrderedDescending:
        {
            ispreviousdate=YES;
            
            
        }break;
        case NSOrderedSame:
        {
            ispreviousdate=YES;
            
        }break;
        default:  break;
    }
    if (ispreviousdate) {
        return YES;
    }
    else{
        return NO;
    }
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (app.viewControllerStatus==11) {
        return finalSectionwiseDataArray.count;
    }
    else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (app.viewControllerStatus==11) {
        return [[finalSectionwiseDataArray objectAtIndex:section] count];
    }
else
    return self.filteredarray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (app.viewControllerStatus==11) {
        
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
        
        
//        NSDictionary *dic;
        NSMutableArray *subArray=[finalSectionwiseDataArray objectAtIndex:indexPath.section];
        
        NSDictionary *dic=[subArray objectAtIndex:indexPath.row];
        BOOL ispreviousdate = NO;
        
        
        NSString *currentdate=[dic
                               objectForKey:@"cdate"];
        NSString *eventdate=[dic
                             objectForKey:@"eventDate"];
        
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm a";
        NSDate *date = [dateFormatter dateFromString:[dic objectForKey:@"eventTime"]];
        dateFormatter.dateFormat = @"HH:mm";
        NSString *time24 = [dateFormatter stringFromDate:date];
        
        NSString *finalCurrentdateString=[NSString stringWithFormat:@"%@ %@",currentdate,[dic objectForKey:@"ctime"]];
        NSString *finalEventdateString=[NSString stringWithFormat:@"%@ %@",eventdate,time24];
        
        
        NSComparisonResult result = [finalCurrentdateString compare:finalEventdateString];
        
        switch (result)
        {
            case NSOrderedAscending:
            {
                ispreviousdate=NO;
            }
                break;
            case NSOrderedDescending:
            {
                ispreviousdate=YES;
                
                
            }break;
            case NSOrderedSame:
            {
                ispreviousdate=YES;
                
            }break;
            default:  break;
        }
        if (ispreviousdate) {
            
            cell.backgroundColor=[UIColor colorWithRed:255.0f/255 green:253.0f/255 blue:223.0f/255 alpha:1.0];
            
        }
        else
            cell.backgroundColor=[UIColor whiteColor];
        cell.locationName.font= [UIFont fontWithName:@"Helvetica" size:13.0];
        cell.locationSubtitle.font= [UIFont fontWithName:@"Helvetica" size:11.0];

//          NSDictionary *dic=[self.filteredarray objectAtIndex:indexPath.row];
        cell.img.hidden=YES;
        
        NSString *str1=[dic objectForKey:@"eventTime"];
        NSString *newString = [[str1 componentsSeparatedByString:@" "] objectAtIndex:0];
        ((UILabel *)[cell.contentView viewWithTag:730]).text = newString;
        ((UILabel *)[cell.contentView viewWithTag:731
                     ]).text =[[str1 componentsSeparatedByString:@" "] objectAtIndex:1];
        
        
        
                cell.locationName.text =[dic valueForKey:@"eventName"];
                cell.locationSubtitle.text = [ NSString stringWithFormat:@"%@,%@",[dic objectForKey:@"eventVenue"],[dic objectForKey:@"eventCity"]];
        
        return cell;
        
    }
    else{
    NSString *CellIdentifier = [NSString localizedStringWithFormat:@"Cell_%ld_%ld",(long)indexPath.section, (long)indexPath.row];
  
    //    static NSString *CellIdentifier = @"CustomCell";
    EventsCell *cell = (EventsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil)
    {
        cell=[[EventsCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        NSArray *topLevelObjects;
       
            topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Event" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[EventsCell class]])
            {
                cell = (EventsCell *)currentObject;
                break;
            }
        }
    }
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dic=[self.filteredarray objectAtIndex:indexPath.row];
        BOOL ispreviousdate = NO;
        
        
        NSString *currentdate=[dic
                               objectForKey:@"cdate"];
        NSString *eventdate=[dic
                             objectForKey:@"eventDate"];
        
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm a";
        NSDate *date = [dateFormatter dateFromString:[dic objectForKey:@"eventTime"]];
        dateFormatter.dateFormat = @"HH:mm";
        NSString *time24 = [dateFormatter stringFromDate:date];
        
        NSString *finalCurrentdateString=[NSString stringWithFormat:@"%@ %@",currentdate,[dic objectForKey:@"ctime"]];
        NSString *finalEventdateString=[NSString stringWithFormat:@"%@ %@",eventdate,time24];
        
        
        NSComparisonResult result = [finalCurrentdateString compare:finalEventdateString];
        
        switch (result)
        {
            case NSOrderedAscending:
            {
                ispreviousdate=NO;
            }
                break;
            case NSOrderedDescending:
            {
                ispreviousdate=YES;
                
                
            }break;
            case NSOrderedSame:
            {
                ispreviousdate=YES;
                
            }break;
            default:  break;
        }
        if (ispreviousdate) {
            
            cell.backgroundColor=[UIColor colorWithRed:255.0f/255 green:253.0f/255 blue:223.0f/255 alpha:1.0];
            
        }
        else
            cell.backgroundColor=[UIColor whiteColor];
        NSString *imageURlString=[dic objectForKey:@"eventImg"];
    imageURlString = [imageURlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url =[NSURL URLWithString:imageURlString];
   
    [cell.img sd_setImageWithURL:url placeholderImage: [UIImage imageNamed:@"Event-Background.jpg"]   options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
    //cell.img.image = image;
    cell.MonthName.textColor=[UIColor colorWithRed:26.0f/256 green:138.0f/256 blue:246.0f/256 alpha:1.0];
    cell.time.text=[dic objectForKey:@"eventTime"];
    cell.eventName.text=[dic objectForKey:@"eventVenue"];
    cell.eventCity.text=[dic objectForKey:@"eventCity"];
//    cell.EventsName.text=[dic objectForKey:@"eventName"];
    NSString *str=[dic objectForKey:@"eventDate"];
   //
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *date = [dateFormatter dateFromString:str];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];

    [dateFormatter1 setDateFormat:@"EEEE"];
    
//    NSString *dayName = [dateFormatter1 stringFromDate:date];
//    cell.EventDayName.text=dayName;
    NSString *str1=[self changeDateformater:str];
    NSArray *arr=[str1 componentsSeparatedByString:@"-"];
    cell.date.text=[arr objectAtIndex:0];
    cell.MonthName.text=[arr objectAtIndex:1];
    
  
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ;
    [dateFormatter setDateFormat:@"EEEE"];
//    NSString *dayName1 = [dateFormatter stringFromDate:[NSDate date]];
//    //NSLog(@" dayname is %@",dayName1);
        return cell;
    }
//            cell.img.image=im;
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (app.viewControllerStatus==11) {
        return 60;
    }
    else{
       return 250.0f;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr=[app.countryClub isLogin];
    if (!(arr.count==2)) {
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"Please Login details"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
      
    }
    else{
        BOOL ispreviousdate = NO;
        NSDictionary *dic;
        if(app.viewControllerStatus==11){
            NSMutableArray *subArray=[finalSectionwiseDataArray objectAtIndex:indexPath.section];
            
            dic=[subArray objectAtIndex:indexPath.row];
        }
        else
        dic=[self.filteredarray objectAtIndex:indexPath.row];
        
        NSString *currentdate=[dic
                               objectForKey:@"cdate"];
        NSString *eventdate=[dic
                             objectForKey:@"eventDate"];
        
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm a";
        NSDate *date = [dateFormatter dateFromString:[dic objectForKey:@"eventTime"]];
        dateFormatter.dateFormat = @"HH:mm";
        NSString *time24 = [dateFormatter stringFromDate:date];
        
        NSString *finalCurrentdateString=[NSString stringWithFormat:@"%@ %@",currentdate,[dic objectForKey:@"ctime"]];
        NSString *finalEventdateString=[NSString stringWithFormat:@"%@ %@",eventdate,time24];
        
        
        NSComparisonResult result = [finalCurrentdateString compare:finalEventdateString];
        
        switch (result)
        {
            case NSOrderedAscending:
            {
                ispreviousdate=NO;
            }
                break;
            case NSOrderedDescending:
            {
                ispreviousdate=YES;
                
                
            }break;
            case NSOrderedSame:
            {
                ispreviousdate=YES;
                
            }break;
            default:  break;
        }
        if (ispreviousdate) {
                   }
        else{

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    
    NSDictionary *dic=[self.filteredarray objectAtIndex:indexPath.row];
    NSString *str=[dic objectForKey:@"id"];
    app.countryClub.delegate=self;
    [app.countryClub sendEventDataByEventId:str];
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     if (app.viewControllerStatus==11)
    return 30;
    else
        return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (app.viewControllerStatus==11) {
         UIView *vi=[[UIView alloc]init];
    vi.frame=CGRectMake(0, 0, table.frame.size.width, 30);
    vi.backgroundColor=[UIColor grayColor];
    UILabel *lbl6;
    lbl6 =[[UILabel alloc]initWithFrame:CGRectMake((table.frame.size.width-150)/2, 5, 150, 22)];
    lbl6.textAlignment=NSTextAlignmentCenter;
    lbl6.font= [UIFont fontWithName:@"System Bold" size:18.0];
    lbl6.textColor=[UIColor blackColor];
        
        NSMutableArray *subArray=[finalSectionwiseDataArray objectAtIndex:section];
        
        NSDictionary *dic=[subArray objectAtIndex:0];
    lbl6.text=[self changeDateformater1:[dic objectForKey:@"eventDate"]];
    [vi addSubview:lbl6];
    return vi;
    }
    else
        return 0;
}
-(NSString *)changeDateformater1:(NSString*)str{
//    //NSLog(@"%@",str);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    NSDate *currentDate = [NSDate date];
    //    NSDate *dateFromString = [[NSDate alloc] init];
    //    dateFromString = [dateFormatter dateFromString:str];
    //    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    //    NSString *str1=[dateFormatter stringFromDate:dateFromString];
    //    //NSLog(@"%@....%@",str1,dateFromString);
    NSArray *arr=[str componentsSeparatedByString:@"-"];
    NSDate *date = [dateFormatter dateFromString:str];
    
    dateFormatter.dateFormat=@"MMM";
    NSString * monthString = [[dateFormatter stringFromDate:date] capitalizedString];
//    //NSLog(@"month: %@", monthString);
    
    dateFormatter.dateFormat=@"EEEE";
    NSString * dayString = [[dateFormatter stringFromDate:date] capitalizedString];
//    //NSLog(@"day: %@", dayString);
    NSString *result=[NSString stringWithFormat:@"%@ %@ %@",dayString,monthString,[arr objectAtIndex:2]];
    
    return result;
}

-(NSString *)changeDateformater:(NSString*)str{
//    //NSLog(@"%@",str);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    NSDate *currentDate = [NSDate date];
    NSDate *dateFromString;
    dateFromString = [dateFormatter dateFromString:str];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *str1=[dateFormatter stringFromDate:dateFromString];
//    //NSLog(@"%@....%@",str1,dateFromString);
    return str1;
}
#pragma -delegate methods
-(void)getSelectedEvent:(NSDictionary *)dic{

    [self performSelectorOnMainThread:@selector(sendeventdata:) withObject:dic waitUntilDone:YES];
    [hud performSelectorOnMainThread:@selector(hide:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    
    

}
-(void)sendeventdata:(NSDictionary*)dic{
    
    if (![[self.navigationController.viewControllers lastObject] isEqual:self]) {
        
        return;
    }

    EventDetails *details;
    details=[[EventDetails alloc]init];
    details.dic1=[[NSDictionary alloc]init];
    details.dic1=dic;
    hud.hidden=YES;
    [hud performSelectorOnMainThread:@selector(hide:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    [self.navigationController pushViewController:details animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    Navlbl.hidden=YES;
    [super viewWillDisappear:YES];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    Navlbl.hidden=NO;
}
-(void)countyClubModel_ResponseOfUserFeedback:(NSDictionary *)dic{
    GenralFeedbackView.hidden=YES;
    feedbackViewStatus=0;
    btnsView.hidden=YES;
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:[dic objectForKey:@"message"]preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end
