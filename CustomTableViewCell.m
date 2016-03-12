//
//  CustomTableViewCell.m
//  Project
//
//  Created by Tigris on 7/6/15.
//  Copyright (c) 2015 tigris. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.image.layer.cornerRadius = self.image.frame.size.width/2;
    self.image.clipsToBounds = YES;
    
   
        self.image.layer.borderWidth = 1.0f;

   
    self.image.layer.borderColor = [UIColor lightGrayColor].CGColor;


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
