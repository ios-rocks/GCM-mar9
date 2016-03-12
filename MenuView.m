//
//  MenuView.m
//  sampleGulte
//
//  Created by 9P Studio on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuView.h"

#define RADIANS(degrees) ((degrees * M_PI)/180.0)

@implementation MenuView
{UIButton *b;
}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        UIView *background = [[UIView alloc] initWithFrame:frame];
        [self addSubview:background];
        
        [background setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
        menuButtons = [[NSMutableArray alloc] init];
        
        UIScrollView *menuViewScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        menuViewScroll.scrollEnabled = YES;
        menuViewScroll.showsHorizontalScrollIndicator = NO;
        menuViewScroll.showsVerticalScrollIndicator = NO;
        
       
        int PADDING = 20;
        int SIZE = 60;
        int LEFT_PADDING = 30;
        int TOP_PADDING = 35;
        
        UIButton *home = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_PADDING, TOP_PADDING, SIZE, SIZE)];
        //home.backgroundColor = [UIColor lightGrayColor];
        [home setBackgroundImage:[UIImage imageNamed:@"Home_60x60.png"] forState:UIControlStateNormal];
        [menuViewScroll addSubview:home];
        home.tag = 1;
        home.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1.0);
        [menuButtons addObject:home];
        [home addTarget:self action:@selector(button_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *profile = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_PADDING+SIZE+PADDING, TOP_PADDING, SIZE , SIZE)];
        [profile setBackgroundImage:[UIImage imageNamed:@"Profile_60.png"] forState:UIControlStateNormal];
        [menuViewScroll addSubview:profile];
        profile.tag = 2;
        profile.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1.0);
        [menuButtons addObject:profile];
        [profile addTarget:self action:@selector(button_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *payslip = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_PADDING, TOP_PADDING+SIZE+PADDING, SIZE, SIZE)];
        [payslip setBackgroundImage:[UIImage imageNamed:@"payslip_60x60.png"] forState:UIControlStateNormal];
        [menuViewScroll addSubview:payslip];
        payslip.tag = 3;
        payslip.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1.0);
        [menuButtons addObject:payslip];
        [payslip addTarget:self action:@selector(button_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *logout = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_PADDING+SIZE+PADDING, TOP_PADDING+SIZE+PADDING, SIZE, SIZE)];
        [logout setBackgroundImage:[UIImage imageNamed:@"Logout_180x180.png"] forState:UIControlStateNormal];
        [menuViewScroll addSubview:logout];
        
        logout.tag = 4;
        logout.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1.0);
        [menuButtons addObject:logout];
        [logout addTarget:self action:@selector(button_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        
    [background addSubview:menuViewScroll];
        
        menuViewScroll.contentSize = frame.size;
        
    }
    return self;
}

- (void) animateMenuButtons
{
    float delay = 0.0;
    
    for(b in menuButtons)
    {
        [UIView animateWithDuration:0.2
         
                              delay:delay
         
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:
         ^{
             b.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
         }
                         completion:^(BOOL finished)
         {
         }
         ];
        
        delay+=0.1;
    }
}

-(void) button_Clicked:(id)sender
{    b = (UIButton *)sender;
    [self.delegate menuViewButton_Clicked:(int)b.tag];
    
}



@end
