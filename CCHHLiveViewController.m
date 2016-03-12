//
//  CCHHLiveViewController.m
//  Employee
//
//  Created by Country Club on 08/12/15.
//  Copyright © 2015 Country Club. All rights reserved.
//

#import "CCHHLiveViewController.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"
#import "CustomTableViewCell.h"
#import "FTWCache.h"
#import "NSString+MD5.h"
#import "MBProgressHUD.h"
#import "ImagesViewController.h"

@interface CCHHLiveViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebtn;
//@property (weak, nonatomic) IBOutlet UIScrollView *catScroll;
@property (strong, nonatomic)  UIScrollView *catScroll;

@end

@implementation CCHHLiveViewController
{
    NSMutableArray *alltheData, *catogiesList,*categories;
    NSArray *cats;
    MBProgressHUD *HUD;
    int lastClickedOne;
    UIRefreshControl *refreshing;
    BOOL firstorNot;
    int staticChecker;
    CGRect bounds;
    CGFloat yPosition;
    NSDictionary *attrs;
    NSDictionary *subAttrs;
    BOOL starting;

    
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    if (starting==YES) {
        self.catScroll.contentOffset = CGPointZero;
        self.catScroll.contentInset = UIEdgeInsetsZero;
    }
    
    if (starting==NO)
    {
        [self.catScroll setContentOffset:CGPointMake(110*lastClickedOne, 0) animated:YES];
        
    }
    
   }



-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,30,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.textColor=[UIColor whiteColor];
    lbNavTitle.text = NSLocalizedString(@"Live Feed",@"");
    self.navigationItem.titleView = lbNavTitle;

    self.navigationItem.hidesBackButton=YES;
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
    _sidebtn.target=self.revealViewController;
    _sidebtn.action=@selector(revealToggle:);
 [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    [self BarButton];
    
    _catScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0,44, self.view.frame.size.width, 44)];
   _catScroll.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [_catScroll setShowsHorizontalScrollIndicator:YES];
    _catScroll.userInteractionEnabled = YES;
    _catScroll.backgroundColor=[UIColor grayColor];
    [_catScroll setShowsVerticalScrollIndicator:NO];
       [self.view addSubview:_catScroll];

    firstorNot = YES;
    starting=YES;
    staticChecker = 1;
  //[self.navigationController setNavigationBarHidden:YES];
    
    categories = [[NSMutableArray alloc] init];
    
    catogiesList = [NSMutableArray arrayWithObjects:@"ALL",@"CLUB",@"HOLIDAY", @"CHECKIN", @"CHECKOUT", @"FITNESS ",@"EVENT", nil];
    cats = [[NSArray alloc] initWithObjects:@"All", @"Club", @"Book", @"Checkin", @"Checkout", @"Fitness Centre",@"Event", nil];
    
    refreshing = [[UIRefreshControl alloc] init];
    [refreshing addTarget:self action:@selector(checkOrderValue) forControlEvents:UIControlEventValueChanged];
    
  [self creatingCategoryButtons];
    lastClickedOne = 0;
    
    bounds = [[UIScreen mainScreen] bounds];
   
        yPosition = 100;
   
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, yPosition, self.view.frame.size.width, self.view.frame.size.height - yPosition) style:UITableViewStylePlain];
    [self.mainTableView addSubview:refreshing];
    
    self.helperTableView = [[UITableView alloc] initWithFrame:CGRectMake(bounds.size.width, yPosition, bounds.size.width, bounds.size.height - yPosition) style:UITableViewStylePlain];
    
    [self.view addSubview:self.mainTableView];
   [self.view addSubview:self.helperTableView];
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
   self.helperTableView.dataSource = self;
    self.helperTableView.delegate = self;
    
    
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.mainTableView addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    
    [self.mainTableView addGestureRecognizer:rightSwipeGesture];
    
    [self checkOrderValue];
    
        attrs = @{NSFontAttributeName:[UIFont fontWithName:@"Apple Color Emoji" size:12.0f],
                  NSForegroundColorAttributeName:[UIColor blackColor]
                  };
        subAttrs = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]
                     };
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)BarButton
{
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [myButton setImage:[UIImage imageNamed:@"Home.png"] forState:UIControlStateNormal];
    
    myButton.frame = CGRectMake(0, 0, 40, 36);
    
    [myButton addTarget:self action:@selector(requestButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * aBarButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    
    self.navigationItem.rightBarButtonItem = aBarButton;


}
- (void)handleLeftSwipe:(id)sender  {
    
    if (catogiesList.count <= lastClickedOne + 1)
        return;
    starting=NO;
    
    lastClickedOne += 1;
    
    CGRect mainFramw = self.mainTableView.frame;
    self.helperTableView.frame = CGRectMake(mainFramw.origin.x + mainFramw.size.width, mainFramw.origin.y, mainFramw.size.width, mainFramw.size.height);
    
    self.helperTableView.hidden = FALSE;
    [self.view bringSubviewToFront:self.helperTableView];
   
    [self creatingCategoryButtons];
       [self.catScroll setContentOffset:CGPointMake(110*lastClickedOne, 0) animated:YES];
        
  
    [categories removeAllObjects];
    if (lastClickedOne == 0)
    {
        [categories addObjectsFromArray:alltheData];
        firstorNot = YES;
    }
    else    {
        firstorNot = NO;
        
        NSString *cat = [cats objectAtIndex:lastClickedOne];
        NSPredicate *predicateStr = [NSPredicate predicateWithFormat:@"(%K == %@)", @"city", cat];
        [categories addObjectsFromArray:[alltheData filteredArrayUsingPredicate:predicateStr]];
        
    }
    [self.helperTableView reloadData];
    
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.helperTableView.frame = mainFramw;
        self.mainTableView.center = CGPointMake(0 - self.mainTableView.center.x, self.mainTableView.center.y);
        
    } completion:^(BOOL finished) {
        
        
        [self creatingCategoryButtons];
        
        [categories removeAllObjects];
        if (lastClickedOne == 0)
        {
            [categories addObjectsFromArray:alltheData];
            firstorNot = YES;
        }
        else    {
            firstorNot = NO;
            
            NSString *cat = [cats objectAtIndex:lastClickedOne];
            NSPredicate *predicateStr = [NSPredicate predicateWithFormat:@"(%K == %@)", @"city", cat];
            [categories addObjectsFromArray:[alltheData filteredArrayUsingPredicate:predicateStr]];
            
        }
        
        [self.mainTableView reloadData];
        
        self.mainTableView.frame = mainFramw;
        self.helperTableView.hidden = TRUE;
        [self.view bringSubviewToFront:self.mainTableView];
        
    }];
}

- (void)handleRightSwipe:(id)sender  {
    
    if (lastClickedOne <= 0)
        return;
    starting=NO;
    lastClickedOne -= 1;
    
    CGRect mainFramw = self.mainTableView.frame;
    self.helperTableView.frame = CGRectMake(0 - mainFramw.size.width, mainFramw.origin.y, mainFramw.size.width, mainFramw.size.height);
    
    self.helperTableView.hidden = FALSE;
    [self.view bringSubviewToFront:self.helperTableView];
    
    
    [self creatingCategoryButtons];
    
  
        [self.catScroll setContentOffset:CGPointMake(110*lastClickedOne, 0) animated:YES];
        
    
    [categories removeAllObjects];
    if (lastClickedOne == 0)
    {
        [categories addObjectsFromArray:alltheData];
        firstorNot = YES;
    }
    else    {
        firstorNot = NO;
        
        NSString *cat = [cats objectAtIndex:lastClickedOne];
        NSPredicate *predicateStr = [NSPredicate predicateWithFormat:@"(%K == %@)", @"city", cat];
        [categories addObjectsFromArray:[alltheData filteredArrayUsingPredicate:predicateStr]];
        
    }
    
    [self.helperTableView reloadData];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.helperTableView.frame = mainFramw;
        self.mainTableView.center = CGPointMake(mainFramw.size.width + self.mainTableView.center.x, self.mainTableView.center.y);
        
    } completion:^(BOOL finished) {
        
        [self creatingCategoryButtons];
        
        [categories removeAllObjects];
        if (lastClickedOne == 0)
        {
            [categories addObjectsFromArray:alltheData];
            firstorNot = YES;
        }
        else    {
            firstorNot = NO;
            
            NSString *cat = [cats objectAtIndex:lastClickedOne];
            NSPredicate *predicateStr = [NSPredicate predicateWithFormat:@"(%K == %@)", @"city", cat];
            [categories addObjectsFromArray:[alltheData filteredArrayUsingPredicate:predicateStr]];
            
        }
        [self.mainTableView reloadData];
        
        self.mainTableView.frame = mainFramw;
        self.helperTableView.hidden = TRUE;
        [self.view bringSubviewToFront:self.mainTableView];
        
    }];
}

-(void)creatingCategoryButtons
{
    int x=2, y=5;
    
    for (UIView *view in self.catScroll.subviews) {
        [view removeFromSuperview];
    }
    
        for (int i=0; i<catogiesList.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(callingResorts:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:[catogiesList objectAtIndex:i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont fontWithName:@"Tahoma-Bold" size:12.0];
                     button.frame = CGRectMake(x, y, 110.0, 40.0);
            button.layer.cornerRadius =10.0;
            button.tag = i;
            if (button.tag==lastClickedOne) {
                
                UIView *crossLine = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x,39,button.frame.size.width, 3)];
                crossLine.backgroundColor = [UIColor colorWithRed:221.0/255.0f green:122.0/255.0f blue:98.0/255.0f alpha:1.0f];
                [self.catScroll addSubview:crossLine];

            }
            
//            if (button.tag==catogiesList.count-1)
//            {
//                lastClickedOne -= 1;
//                [self.catScroll setContentOffset:CGPointMake(110*lastClickedOne, 0) animated:YES];
//                
//
//            }
//     
            [self.catScroll addSubview:button];
            
                       x=x+113;
           
        }
        [self.catScroll setContentSize:CGSizeMake(x,self.catScroll.frame.size.height)];
        
    self.catScroll.contentOffset = CGPointZero;


    
}
-(void)callingResorts:(UIButton*)sender
{
    lastClickedOne = (int)sender.tag;
    [self creatingCategoryButtons];
     [self.catScroll setContentOffset:CGPointMake(110*lastClickedOne, 0) animated:YES];
    [categories removeAllObjects];
    if (sender.tag == 0)
    { [categories addObjectsFromArray:alltheData];
        firstorNot = YES;
    }
    else    {
        firstorNot = NO;
        
        NSString *cat = [cats objectAtIndex:sender.tag];
        NSPredicate *predicateStr = [NSPredicate predicateWithFormat:@"(%K == %@)", @"city", cat];
        
        //NSLog(@"  pre %@ ", [NSPredicate predicateWithFormat:@"(%K == %@)", @"city", cat]);

        [categories addObjectsFromArray:[alltheData filteredArrayUsingPredicate:predicateStr]];
         [self.catScroll setContentOffset:CGPointMake(110*lastClickedOne, 0) animated:YES];
    }
    [self.mainTableView reloadData];
    
}
-(void)checkOrderValue
{
    
    if (staticChecker==1) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        if (![Utils isConnectedToNetwork]) {
            [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
            return;
        }

        [HUD show:YES];
        staticChecker++;
    }
    else
    {
        [refreshing beginRefreshing];
    }
    
    NSString* str = [NSString stringWithFormat:@"http://www.countryclubworld.com/akhilapp/ccapp/index_v1.php/booktrack2"];
    NSURL *url =  [NSURL URLWithString:str];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: url];
        [self performSelectorOnMainThread:@selector(checkValue:) withObject:data waitUntilDone:YES];
        
    });
}
-(void)checkValue:(NSData *)userData {
    NSError* error;
    NSDictionary *json = nil;
    
    [HUD hide:YES];
    
    
    [refreshing endRefreshing];
    
    if (userData.length!=0) {
        json = [NSJSONSerialization
                JSONObjectWithData:userData
                options:kNilOptions
                error:&error];
        alltheData = [json objectForKey:@"track"];
        
        
        if (lastClickedOne == 0)
        {
            
            
            [categories addObjectsFromArray:alltheData];
            firstorNot=YES;
        }
        else    {
            firstorNot = NO;
            NSString *cat = [cats objectAtIndex:lastClickedOne];
            NSPredicate *predicateStr = [NSPredicate predicateWithFormat:@"(%K == %@)", @"city", cat];
            //NSLog(@"  pre %@ ", [NSPredicate predicateWithFormat:@"(%K == %@)", @"city", cat]);

            [categories addObjectsFromArray:[alltheData filteredArrayUsingPredicate:predicateStr]];
            
        }
        
        [self.mainTableView reloadData];
        
        //NSLog(@"%@",[[json objectForKey:@"track"] objectAtIndex:0]);
        
        
    }
    
    else
    {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet Connection" message:@"Sorry, no internet connectivity detected Please reconnect and try again" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
          return 61;
 
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return categories.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = nil;
        
            nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableview_iPhone" owner:self options:nil];
       
        
        cell = [nib objectAtIndex:0];
        
    }
    
    NSString *str = [[categories objectAtIndex:indexPath.row] objectForKey:@"Name"];
  
    cell.time.text = [[categories objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"</b" withString:@"<b"];
    
    NSArray *itesms = [str1 componentsSeparatedByString:@"<b"];
    
    NSUInteger start = [[itesms firstObject] length];
    
    
    NSUInteger end = [[itesms objectAtIndex:1] length]-1;
    
   // //NSLog(@" end val is %lu ",(unsigned long)end);
    
    str = [str stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
    
   // //NSLog( @"  first str is %@ ",str);
    str = [str stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
  //  //NSLog( @"  sec str is %@ ",str);
    const NSRange range = NSMakeRange(start, end);
    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:str   attributes:attrs];
    [attributedText setAttributes:subAttrs range:range];
    
    // Set it in our UILabel and we are done!
    [cell.title setAttributedText:attributedText];
    
    
    NSString *urlString = [[categories objectAtIndex:indexPath.row] objectForKey:@"img"];
    
    cell.image.image = [UIImage imageNamed:@"logo-2"];
    
    NSURL *imageURL = [NSURL URLWithString:urlString];
    NSString *key = [urlString MD5Hash];
    NSData *data = [FTWCache objectForKey:key];
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        cell.image.image = image;
        
    } else {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            [FTWCache setObject:data forKey:key];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_sync(dispatch_get_main_queue(), ^{
                cell.image.image = image;
                if (!data) {
                    cell.image.image = [UIImage imageNamed:@"logo-2"];
                }
            });
        });
    }
    
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   ImagesViewController *img = [self.storyboard instantiateViewControllerWithIdentifier:@"IMAGE"];
    img.resortName = [[categories objectAtIndex:indexPath.row] objectForKey:@"resort"];
    img.resortId = [[categories objectAtIndex:indexPath.row] objectForKey:@"resortid"];
    [self.navigationController pushViewController:img animated:YES];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    
    
    self.helperTableView.frame =  CGRectMake(width, yPosition, width, height - yPosition);
    
    self.mainTableView.frame =  CGRectMake(0, yPosition, width, height - yPosition);
    
    [self.view bringSubviewToFront:self.helperTableView];
    
   
    self.catScroll.frame = CGRectMake(self.catScroll.frame.origin.x, self.catScroll.frame.origin.y, width, self.catScroll.frame.size.height);
    
    
    
    [self.helperTableView reloadData];
    [self.mainTableView reloadData];
    
    
}



- (void)requestButton{
    
    
    MainViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:keyEmpIdViewControllerIdentifier];
    
    UINavigationController *nav = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:NO];
    
}

@end
