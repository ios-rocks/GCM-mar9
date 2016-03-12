//
//  SelectLocationViewcontroller.h
//  CountryClub
//
//  Created by atsmacmini4 on 4/4/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
@interface SelectLocationViewcontroller : UIViewController<MKMapViewDelegate>{
   IBOutlet UILabel *navLbl;
    IBOutlet UINavigationBar *nav;
    AppDelegate *app;
    IBOutlet UIBarButtonItem *rightbarButton;
    
    
}
@property(nonatomic,strong)IBOutlet MKMapView *mapview;
@property(nonatomic,readwrite)float Longitude,Latitude;
@property(nonatomic,strong)NSString *annotationTitle,*annotationSubtitle;
@end
