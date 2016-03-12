//
//  CustomCellForProfile.m
//  CountryClub
//
//  Created by atsmacmini4 on 3/27/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import "CustomCellForProfile.h"

@implementation CustomCellForProfile
@synthesize fieldLbl,detailsLbl,locationName,locationSubtitle;
@synthesize fieldLblPad,detailsLblPad,locationNamepad,locationSubtitlePad,img,iconImg,resortType;
@synthesize city,resortName;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
