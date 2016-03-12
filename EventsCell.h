//
//  EventsCell.h
//  CountryClubLive
//
//  Created by atsmacmini4 on 8/25/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *MonthName;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventCity;
@property (weak, nonatomic) IBOutlet UIButton *detailsBtn;
@property (weak, nonatomic) IBOutlet UILabel *EventsName;
@property (weak, nonatomic) IBOutlet UILabel *EventDayName;
@property (weak, nonatomic) IBOutlet UIImageView *eventimgdisplyObj;
@property (weak, nonatomic) IBOutlet UIImageView *eventimgphone;

@end
