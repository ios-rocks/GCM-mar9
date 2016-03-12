//
//  DisplayLocationImagesView.m
//  CountryClubLive
//
//  Created by atsmacmini4 on 1/9/15.
//  Copyright (c) 2015 atsmacmini4. All rights reserved.
//

#import "DisplayLocationImagesView.h"
#import "AppDelegate.h"
#import "EventsCell.h"
@interface DisplayLocationImagesView ()
@property(nonatomic,strong)NSMutableArray *totalimagesArray;
@end

@implementation DisplayLocationImagesView

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(app.window.frame.size.width-90, 20, 80, 40);
    [btn setImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
//    [btn setTitle:@"Done" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismissview:) forControlEvents:UIControlEventTouchUpInside];
//    btn.backgroundColor=[UIColor blueColor];
    [self.view addSubview:btn];
    self.totalimagesArray=[[NSMutableArray alloc]init];
    for (int i=0; i<self.imagesArray.count; i++)
    {
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.imagesArray objectAtIndex:i]]];
        if (data)
        [self.totalimagesArray addObject:[UIImage imageWithData:data]];
    }
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)dismissview:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.totalimagesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
    cell.MonthName.hidden=YES;
    cell.eventCity.hidden=YES;
    cell.date.hidden=YES;
    cell.EventDayName.hidden=YES;
    cell.eventName.hidden=YES;
    cell.EventsName.hidden=YES;
    cell.detailsBtn.hidden=YES;
    cell.img.hidden=YES;
   
    cell.img.frame=CGRectMake(0, 0, self.view.frame.size.width,  cell.frame.size.height-20);
  
     UIImage *image;
    if ([[self.totalimagesArray objectAtIndex:indexPath.row] isKindOfClass:[NSString class]])
    {
        image = [UIImage imageNamed:@"Locateus_Default_pad.png"];
        
    }
    else
    
        image = [self.totalimagesArray objectAtIndex:indexPath.row];
        cell.eventimgphone.image = image;

    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        return 250.0f;
}
-(void)countyClubModel_ResponseOfUserFeedback:(NSDictionary *)dic{

    
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:[dic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];

      
}
@end
