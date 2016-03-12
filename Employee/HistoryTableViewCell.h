//
//  HistoryTableViewCell.h
//  Employee
//
//  Created by Country Club on 07/01/16.
//  Copyright © 2016 Country Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
@property (strong, nonatomic)  UILabel *label_Date;
@property (strong, nonatomic)  UILabel *label_Name;
@property (strong, nonatomic)  UILabel *label_Time;
@property (strong, nonatomic)  UILabel *label_Call;
@property (strong, nonatomic)  UIImageView *image;
@property (strong, nonatomic)  UIImageView *image1;
@property (strong, nonatomic)  UIImageView *image2;

@property (strong, nonatomic)  UILabel *label_LoadingProgress;
@end
