//
//  MemberDetailsViewController.h
//
//  Copyright © 2016 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberDetailsViewController : UIViewController

@property (strong, nonatomic) NSArray *detailHeading;
@property (strong, nonatomic) NSArray *detailNames;
@property (strong,nonatomic) NSString *idmember;
@property (strong, nonatomic) UIScrollView *detailsScroll;
@end
