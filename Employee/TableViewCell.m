//
//  TableViewCell.m
//  Employee
//
//  Created by Country Club on 21/11/15.
//  Copyright © 2015 Country Club. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.preservesSuperviewLayoutMargins = YES;
        self.contentView.preservesSuperviewLayoutMargins = YES;
        
        
        _profilePhoto = [[UIImageView alloc] initWithFrame:CGRectMake(5, 1, 50, 50)];
        _profilePhoto.contentMode = UIViewContentModeScaleAspectFit;
        
        _profileHeader = [[UILabel alloc] initWithFrame:CGRectMake(_profilePhoto.frame.size.width+20, 0, 230, 60)];
        _profileHeader.backgroundColor = [UIColor clearColor];
        _profileHeader.userInteractionEnabled = NO;
        _profileHeader.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        _profileHeader.numberOfLines = 2;
        [self addSubview:_profilePhoto];
        [self addSubview:_profileHeader];
        
        
        
        
        
        
        
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
