//
//  customCell.m
//  BankApplication
//
//  Created by Mac on 29/07/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "customCell.h"

@implementation customCell
@synthesize articleHeader,articlePhoto;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
      //  self.preservesSuperviewLayoutMargins = YES;
       // self.contentView.preservesSuperviewLayoutMargins = YES;
        

    articlePhoto = [[UIImageView alloc] initWithFrame:CGRectMake(12, 3, 30, 30)];
    articlePhoto.contentMode = UIViewContentModeScaleAspectFit;
    
    articleHeader = [[UILabel alloc] initWithFrame:CGRectMake(articlePhoto.frame.size.width+30, 2, 230, 30)];
    articleHeader.backgroundColor = [UIColor clearColor];
    articleHeader.userInteractionEnabled = NO;
    articleHeader.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    articleHeader.numberOfLines = 2;
    [self addSubview:articlePhoto];
    [self addSubview:articleHeader];
        
      
        
        
        
        

    }
    return self;

}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
