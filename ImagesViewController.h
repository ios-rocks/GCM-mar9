//
//  ImagesViewController.h
//  Employee
//
//  Created by Country Club on 10/12/15.
//  Copyright © 2015 Country Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesViewController : UIViewController

<NSURLConnectionDelegate,UIScrollViewDelegate>

@property(retain,nonatomic) NSString *resortName,*resortId;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;




@end
