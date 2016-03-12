//
//  SelectLocationViewcontroller.m
//  CountryClub
//
//  Created by atsmacmini4 on 4/4/14.
//  Copyright (c) 2014 atsmacmini4. All rights reserved.
//

#import "SelectLocationViewcontroller.h"
#define METERS_PER_MILE 400

@interface SelectLocationViewcontroller ()

@end

@implementation SelectLocationViewcontroller
@synthesize mapview,Latitude,Longitude,annotationTitle,annotationSubtitle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
   //    navLbl=[[UILabel alloc]initWithFrame:CGRectMake(90, 4, 270, 40)];
//    [self.view addSubview:navLbl];
    self.automaticallyAdjustsScrollViewInsets=NO;

    navLbl.font=[UIFont fontWithName:@"System Bold" size:15.0f];
    [nav addSubview:navLbl];
    navLbl.textColor=[UIColor whiteColor];
     navLbl.backgroundColor=[UIColor clearColor];
    NSString *reqSysVer ;
    NSString *currSysVer;
    reqSysVer = @"6.2";
    currSysVer = [[UIDevice currentDevice] systemVersion];
        navLbl=[[UILabel alloc]init];
        if (app.window.frame.size.width>380) {
            navLbl.frame=CGRectMake(130, 2, 150, 40);
        }
        else if (app.window.frame.size.width>320){
            navLbl.frame=CGRectMake(110, 2, 150, 40);
            
        }
        else{
            navLbl.frame=CGRectMake(85, 2, 150, 40);
        }
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
    }
    else{
       
        nav.frame=CGRectMake(0, -20, 320, 44);
        mapview.frame=CGRectMake(0, 20, 320, 480);
        rightbarButton.tintColor=[UIColor blueColor];
        
    }
    navLbl.textAlignment=NSTextAlignmentCenter;

//    [self.navigationController.navigationBar addSubview:navLbl];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
     app.locationscheck=YES;
    navLbl.hidden=NO;
//    mapview = [[MKMapView alloc] initWithFrame:self.view.bounds];
//    mapview.mapType = MKMapTypeHybrid;
    mapview.delegate=self;
    CLLocationCoordinate2D coord = {Latitude, Longitude};
    MKCoordinateSpan span = {.latitudeDelta =  0.2, .longitudeDelta =  0.2};
    MKCoordinateRegion region = {coord, span};
    
    [mapview setRegion:region];
    [self.view addSubview:mapview];
    [self.mapview addAnnotations:[self createAnnotations]];
    
    navLbl.text=annotationTitle;
    [super viewWillAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    [UIApplication sharedApplication].statusBarHidden=YES;
}
- (NSArray *)createAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    //Read locations details from plist
   
        CLLocationCoordinate2D coord;
        coord.latitude = Latitude;
        coord.longitude = Longitude;
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coord;
    annotation.title=annotationTitle;
    annotation.subtitle=annotationSubtitle;
        [annotations addObject:annotation];
    
    return @[annotation];
}
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pinView = nil;
    if(annotation != mapview.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKPinAnnotationView *)[mapview dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                          initWithAnnotation:annotation reuseIdentifier:defaultPinID] ;
        
        pinView.pinTintColor =[UIColor purpleColor];
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
        [mapview.userLocation setTitle:annotationTitle];
    }
    else {
        [mapview.userLocation setTitle:@"I am here"];
    }
    return pinView;
}
-(void)countyClubModel_ResponseOfUserFeedback:(NSDictionary *)dic{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:[dic objectForKey:@"message"]preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
  
}
@end
