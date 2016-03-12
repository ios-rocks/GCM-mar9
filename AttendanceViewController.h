//
//  AttendanceViewController.h
//  Employee
//
//  Created by Country Club on 05/11/15.
//  Copyright © 2015 Country Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceViewController : UIViewController

{

    UILabel *label_date;
    UILabel *label_Time;
   UILabel *label_OutDate;

    UIImageView *imageview_user;
    UIImageView *imageview_Outuser;
 UILabel *totaltime;
UILabel *label_OutTime;
}

@property (strong, nonatomic) IBOutlet UILabel *total_time;



@end
