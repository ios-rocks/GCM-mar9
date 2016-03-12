//
//  CustomCellForProfile.h
//  CountryClub
//
//  Created by atsmacmini4 on 3/27/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellForProfile : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *fieldLbl;
@property(nonatomic,strong)IBOutlet UILabel *detailsLbl;
@property(nonatomic,strong)IBOutlet UILabel *locationName;
@property(nonatomic,strong)IBOutlet UILabel *locationSubtitle;
@property(nonatomic,strong)IBOutlet UILabel *fieldLblPad;
@property(nonatomic,strong)IBOutlet UILabel *detailsLblPad;
@property(nonatomic,strong)IBOutlet UILabel *locationNamepad;
@property(nonatomic,strong)IBOutlet UILabel *locationSubtitlePad;
@property(nonatomic,strong)IBOutlet  UIImageView *img;
@property(nonatomic,strong)IBOutlet UIImageView *iconImg;
@property(nonatomic,strong)IBOutlet UILabel *resortType;
@property(nonatomic,strong)IBOutlet UILabel *city;
@property(nonatomic,strong)IBOutlet UILabel *resortName;
@property (weak, nonatomic) IBOutlet UIImageView *locationImg;
@property (weak, nonatomic) IBOutlet UILabel *profileDetailsValue;
@property (weak, nonatomic) IBOutlet UILabel *dobLbl;
@property (weak, nonatomic) IBOutlet UILabel *dobValue;
@property (weak, nonatomic) IBOutlet UILabel *domLbl;
@property (weak, nonatomic) IBOutlet UILabel *domValue;
@property (weak, nonatomic) IBOutlet UILabel *usedkeys;
@property (weak, nonatomic) IBOutlet UILabel *usedvalues;
@property (weak, nonatomic) IBOutlet UILabel *clubType;
@property (weak, nonatomic) IBOutlet UILabel *clubLocation;
@property (weak, nonatomic) IBOutlet UILabel *clubtime;
@property (weak, nonatomic) IBOutlet UILabel *cellObjectName;
@property (weak, nonatomic) IBOutlet UILabel *cellObjectNamePad;

@end
