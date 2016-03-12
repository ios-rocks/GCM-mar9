//
//  MenuView.h
//  sampleGulte
//
//  Created by 9P Studio on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol MenuViewDelegate <NSObject>

-(void)menuViewButton_Clicked:(int)tag;

@end

@interface MenuView : UIView
{
    NSMutableArray *menuButtons;
    UIImage *_logo;
}

@property (nonatomic, assign) id<MenuViewDelegate>delegate;

-(void) animateMenuButtons;
-(id) initWithFrame:(CGRect)frame ;
@end
