//
//  DisplayLocationImagesView.h
//  CountryClubLive
//
//  Created by atsmacmini4 on 1/9/15.
//  Copyright (c) 2015 atsmacmini4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsCell.h"
@interface DisplayLocationImagesView : UIViewController<UITableViewDataSource,UITableViewDelegate>{
     IBOutlet UITableView *table;
}
@property(nonatomic,strong)NSArray *imagesArray;
@end
