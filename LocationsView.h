//
//  LocationsView.h
//  WebServicesCalling
//
//  Created by ATS-Purna on 4/22/14.
//  Copyright (c) 2014 ATS-MacMini3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol LocationsViewDelegate <NSObject>

-(void)selectedLocation:(NSDictionary *)dic;

@end

@interface LocationsView : UIView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UISearchBarDelegate>{
     CGRect defaultScreenRect;
    AppDelegate *app;
    UISearchBar *currentSearchBar;
     BOOL searchStatus;
    
}

@property (nonatomic,strong) UIScrollView *backscrollView;
@property (nonatomic,strong) NSDictionary *locationsDictionary;
@property  (nonatomic,strong) NSMutableArray *locationsTypesArray;
@property (nonatomic,strong) id <LocationsViewDelegate> delegate;
@property (nonatomic,strong)   NSArray *searchBarArray;
-(void)dataReloadTables;
@end
