//
//  HistoryTableViewCell.m
//  Employee
//
//  Created by Country Club on 07/01/16.
//  Copyright © 2016 Country Club. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    
    
    
    
    
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
      _label_Date=[[UILabel alloc]initWithFrame:CGRectMake(10, 3 ,35, 50)];
        _label_Date.adjustsFontSizeToFitWidth=YES;
        UIFont* boldFont = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        [_label_Date setFont:boldFont];
     // _label_Date.backgroundColor = [UIColor lightGrayColor];
      _label_Date.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        _label_Date.numberOfLines = 2;
        
      [self addSubview:_label_Date];


        _label_Name=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_label_Date.frame)+15, 4 ,_label_Date.frame.size.width+200, 20)];
     //   _label_Name.backgroundColor = [UIColor lightGrayColor];
        _label_Name.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        _label_Name.numberOfLines = 1;
        _label_Name.adjustsFontSizeToFitWidth=YES;
        [self addSubview:_label_Name];


        _label_LoadingProgress=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2+10, 4 ,_label_Time.frame.size.width+100, 20)];
        
      //  _label_LoadingProgress.backgroundColor = [UIColor lightGrayColor];
        _label_LoadingProgress.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        _label_LoadingProgress.numberOfLines = 1;
        _label_LoadingProgress.adjustsFontSizeToFitWidth=YES;
        [self addSubview:_label_LoadingProgress];
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        //  CGFloat widthOfScreen  = size.width;
        CGFloat heightOfScreen = size.height;
        
        if (heightOfScreen<600)
        {
            
            _image=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-45, 4, 40, 40)];
            
        }else
        {
        
            _image=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-30, 4, 44, 44)];

        
        }

        
        _image.contentMode = UIViewContentModeScaleAspectFit;
        [_image setImage:[UIImage imageNamed:@"no_sales"]];
        [self addSubview:_image];
        
        _image1=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_label_Date.frame)+10, 26, 10, 10)];
        _image1.contentMode = UIViewContentModeScaleAspectFit;
        [_image1 setImage:[UIImage imageNamed:@"alaram"]];
        [self addSubview:_image1];
        
        
   _label_Time=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_image1.frame), 30 ,_label_Date.frame.size.width+100, 20)];
      //  _label_Time.backgroundColor = [UIColor lightGrayColor];
        _label_Time.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        _label_Name.numberOfLines = 1;
        _label_Time.adjustsFontSizeToFitWidth=YES;
        [self addSubview:_label_Time];

        
      
        _image2=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2,25,30, 20)];
        _image2.contentMode = UIViewContentModeScaleAspectFit;
        [_image2 setImage:[UIImage imageNamed:@"call"]];
        [self addSubview:_image2];
        
    
    _label_Call=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_image2.frame), 30 , 100, 20)];
        _label_Call.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        _label_Call.numberOfLines = 1;
        _label_Call.adjustsFontSizeToFitWidth=YES;
        [self addSubview:_label_Call];
        
        
        

        
        
    }
    return self;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
