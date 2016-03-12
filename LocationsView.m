//
//  LocationsView.m
//  WebServicesCalling
//
//  Created by ATS-Purna on 4/22/14.
//  Copyright (c) 2014 ATS-MacMini3. All rights reserved.
//

#import "LocationsView.h"
#import "CustomCellForProfile.h"
#define MyTag 1000
#define TableViewTag 1100
#define SearchBarTag 1200

//button frames
#define LeftButtonFrame CGRectMake(-10, 7, 80, 30)
#define CenterButtonFrame CGRectMake((self.frame.size.width-80)/2, 7, 80, 30)
#define RightButtonFrame CGRectMake(self.frame.size.width-70, 7, 80, 30)


@implementation LocationsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                app=(AppDelegate*)[UIApplication sharedApplication].delegate;
          defaultScreenRect=app.window.bounds;
       // NSDictionary *dic = @{@"All":@"All",@"H":@"Hotels",@"F":@"Fitness",@"R":@"Resorts",@"C":@"Clubs"};
        self.backscrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
       self.backscrollView.contentSize = CGSizeMake(self.bounds.size.width*self.locationsTypesArray.count, self.frame.size.height);
        self.backscrollView.alwaysBounceHorizontal = YES;
        self.backscrollView.showsHorizontalScrollIndicator = NO;
        self.backscrollView.pagingEnabled = YES;
        self.backscrollView.alwaysBounceVertical = NO;
        self.backscrollView.bounces = NO;
        self.backscrollView.delegate = self;
//        self.backscrollView.backgroundColor = [UIColor redColor];
        self.backscrollView.showsHorizontalScrollIndicator = YES;
        [self addSubview:self.backscrollView];
        
        self.locationsTypesArray = [[NSMutableArray alloc]initWithArray: @[@"All"]];
        
        for (int i =0 ; i < self.locationsTypesArray.count; i ++)
        {
            [self createView:i];
        }
        
        
    }
    return self;
}


#pragma -mark tableview delegate methods
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchStatus==YES && currentSearchBar.tag  == tableView.tag + 100)
    {
        if (self.searchBarArray.count==0)
        {
             [self viewWithTag:tableView.tag+500].hidden = NO;
        }
        return self.searchBarArray.count;
    }
    else
    {
         [self viewWithTag:tableView.tag+500].hidden = YES;
    return [[self.locationsDictionary valueForKey:[self.locationsTypesArray objectAtIndex:tableView.tag-TableViewTag]]count] ;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
//currentSearchBar = (UISearchBar *)[self viewWithTag:(tableView.tag-TableViewTag)+SearchBarTag] ;
    //[currentSearchBar resignFirstResponder];
    
    
    NSString *CellIdentifier = [NSString localizedStringWithFormat:@"Cell_%ld_%ld",(long)indexPath.section, (long)indexPath.row];
    //    static NSString *CellIdentifier = @"CustomCell";
    CustomCellForProfile *cell = (CustomCellForProfile *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        
        cell=[[CustomCellForProfile alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        NSArray *topLevelObjects;
       
            topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCellForProfile" owner:nil options:nil];
                for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[CustomCellForProfile class]])
            {
                cell = (CustomCellForProfile *)currentObject;
                break;
            }
        }
    }
    
    
    NSDictionary *dic;
     cell.img.hidden=YES;
    
    if (searchStatus==YES && currentSearchBar.tag == tableView.tag+100)
    {
        if (self.searchBarArray.count)
        {
            
                dic = [self.searchBarArray objectAtIndex:indexPath.row];
            UIImage *locationImage = [UIImage imageNamed:[dic objectForKey:@"img"]];
            if (!locationImage) {
                locationImage = [UIImage imageNamed:@"logo-2.png"];
            }
            cell.locationImg.image = locationImage;
            cell.locationName.text =[dic valueForKey:@"Name"];
            cell.locationSubtitle.text = [dic valueForKey:@"City"];
            
        NSString *str = [self.searchBarArray objectAtIndex:indexPath.row];
        for (int j=0; j<[[self.locationsDictionary valueForKey:[self.locationsTypesArray objectAtIndex:tableView.tag-TableViewTag]]count]; j++)
        {
             dic=[[self.locationsDictionary valueForKey:[self.locationsTypesArray objectAtIndex:tableView.tag-TableViewTag]]objectAtIndex:j];
            NSString *str1=[dic valueForKey:@"Name"];
            
            if ([str1 isEqualToString:str])
            {
                UIImage *locationImage = [UIImage imageNamed:[dic objectForKey:@"img"]];
                   cell.locationImg.image = locationImage;
                cell.locationName.text =[dic valueForKey:@"Name"];
                cell.locationSubtitle.text = [dic valueForKey:@"City"];
            }
        }
        }
        else{
             cell.locationImg.hidden=YES;
        }
       
    }
    else
    {
    dic=[[self.locationsDictionary valueForKey:[self.locationsTypesArray objectAtIndex:tableView.tag-TableViewTag]]objectAtIndex:indexPath.row];
   
        UIImage *locationImage = [UIImage imageNamed:[dic objectForKey:@"img"]];
        if (!locationImage) {
            locationImage = [UIImage imageNamed:@"logo-2.png"];
        }
            cell.locationImg.image = locationImage;
 

    cell.locationName.text =[dic valueForKey:@"Name"];
    cell.locationSubtitle.text = [dic valueForKey:@"City"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [[self viewWithTag:tableView.tag-TableViewTag+SearchBarTag] resignFirstResponder];
    NSDictionary *dic;
    if (searchStatus==YES && currentSearchBar.tag == tableView.tag+100)
    {
        dic = [self.searchBarArray objectAtIndex:indexPath.row];
    }
    else
    dic=[[self.locationsDictionary valueForKey:[self.locationsTypesArray objectAtIndex:tableView.tag-TableViewTag]]objectAtIndex:indexPath.row];
    
//    //NSLog(@"data is %@",dic);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedLocation:)])
    {
        [[self delegate]selectedLocation:dic];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
#pragma -mark create Button

-(UIButton *)CreateButton:(SEL)sel andFrame:(CGRect)Frame andTag:(int)tag andTitle:(NSString *)title

{
    UIButton *button =[[UIButton alloc]initWithFrame:Frame];
    button.tag  = tag;
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
    
}
-(void)changeTableViewType:(UIButton *)sender
{
    [self searchBarSearchButtonClicked:currentSearchBar];
    //self.backscrollView.contentOffset = CGPointMake(self.frame.size.width*(sender.tag-MyTag-200), 0);

//    [UIView animateWithDuration:0.5 animations:^{
//            self.backscrollView.contentOffset = CGPointMake(self.frame.size.width*(sender.tag-MyTag-200), 0);
//    }];
   [self searchBarKeyboardDismissed:currentSearchBar];

}

-(void)dataReloadTables
{
    [self performSelectorOnMainThread:@selector(updateViewData) withObject:nil waitUntilDone:YES];
}

-(void)updateViewData
{
    
    if (self.locationsTypesArray.count != self.locationsDictionary.allKeys.count)
    {
        for (NSString *key in self.locationsDictionary.allKeys)
            if (![self.locationsTypesArray containsObject:key])
            {
                [self.locationsTypesArray addObject:key];
                self.backscrollView.contentSize = CGSizeMake(self.bounds.size.width*self.locationsTypesArray.count, self.bounds.size.height);
//                //NSLog(@"data is %@",self.locationsTypesArray.lastObject);
                int value = (int)self.locationsTypesArray.count-1;
                [self createView:value];
                self.backscrollView.contentSize = CGSizeMake(self.bounds.size.width*self.locationsTypesArray.count, self.bounds.size.height);
                
            }
    }
    
    
    for (int i = 0; i < self.locationsTypesArray.count; i++)
    {
        UITableView *tableview = (UITableView *)[self viewWithTag:TableViewTag+i];
        [tableview reloadData];
    }
    

    
}

-(void)createView:(int)tagValue
{
    
    UIView *dataView  = [self viewWithTag:(tagValue-1)+MyTag];
    NSString *titlePreviousButton;
    if (dataView)
    {
        UIButton *buton = [self CreateButton:@selector(changeTableViewType:) andFrame:RightButtonFrame andTag:(int)dataView.tag+1+200 andTitle:[self.locationsTypesArray objectAtIndex:tagValue]];
        UIView *topView = [dataView viewWithTag:222];
        UIButton *btn = (UIButton *)[topView viewWithTag:dataView.tag+200];
        titlePreviousButton = btn.currentTitle;
        [topView addSubview:buton];
    }
    
    
    dataView = [[UIView alloc]initWithFrame:CGRectMake( tagValue *self.bounds.size.width,0,self.backscrollView.bounds.size.width,self.backscrollView.bounds.size.height)];
    dataView.backgroundColor = [UIColor clearColor];
    dataView.tag = tagValue+MyTag;
    
    // top bar
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
        topView.backgroundColor = [UIColor lightGrayColor];
    topView.tag= 222;
    [dataView addSubview:topView];
    
    
    if (titlePreviousButton)
    {
        UIButton *buton = [self CreateButton:@selector(changeTableViewType:) andFrame:LeftButtonFrame andTag:(int)dataView.tag-1+200 andTitle:[self.locationsTypesArray objectAtIndex: tagValue-1]];
        [topView addSubview:buton];
    }
    
    
    UIButton *buton = [self CreateButton:@selector(changeTableViewType:) andFrame:CenterButtonFrame andTag:(int)dataView.tag+200 andTitle:[self.locationsTypesArray objectAtIndex: tagValue]];
    [topView addSubview:buton];
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[buton titleForState:UIControlStateNormal]];
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
    // using text on button
    [buton setAttributedTitle: titleString forState:UIControlStateNormal];
    UITableView *tableViewData;
    tableViewData = [[UITableView alloc]initWithFrame:CGRectMake(0, topView.frame.size.height, dataView.bounds.size.width, dataView.bounds.size.height-topView.frame.size.height)];

    
    tableViewData.tag = tagValue+TableViewTag;
    tableViewData.dataSource = self;
    tableViewData.delegate =self;
    [dataView addSubview:tableViewData];
    
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, tableViewData.frame.size.width, 44)];
    searchBar.tag = tagValue+SearchBarTag;
    searchBar.delegate = self;
 
//    if ([searchBar conformsToProtocol:@protocol(UITextInputTraits)]) {
//        
//        @try {
//            
//            [(UITextField *)searchBar setReturnKeyType:UIReturnKeyDone];
//            [(UITextField *)searchBar setKeyboardAppearance:UIKeyboardAppearanceAlert];
//        }
//        @catch (NSException * e) {
//            
//            // ignore exception
//        }
//    }
 searchBar.autocorrectionType = UITextAutocorrectionTypeYes;
    tableViewData.tableHeaderView = searchBar;
    
    UILabel *searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 200, 200, 40)];
    searchLabel.center = CGPointMake(self.center.x, 200);
    searchLabel.text = @"No Results";
    searchLabel.textAlignment=NSTextAlignmentCenter;
    searchLabel.tag = searchBar.tag+ 400;
    [tableViewData addSubview:searchLabel];
    
    [self viewWithTag:searchBar.tag+400].hidden = YES;
    [self.backscrollView addSubview:dataView];
    
}

#pragma -mark SearchBar Delegate methods...............

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
//    self.searchBarArray = nil;
    if (currentSearchBar.tag != searchBar.tag)
    [self searchBarCancelButtonClicked:currentSearchBar];
  
    currentSearchBar = searchBar;
    searchBar.showsCancelButton = YES;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self viewWithTag:searchBar.tag+400].hidden = YES;
      searchStatus=YES;
    self.searchBarArray = nil;
      searchBar.showsCancelButton = YES;
//      //NSLog(@" text is %@",searchBar.text);
    
    NSArray *totalData = [self.locationsDictionary valueForKey:[self.locationsTypesArray objectAtIndex:searchBar.tag-SearchBarTag]];
    

    currentSearchBar = searchBar;
   

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.Name contains[cd] %@", searchBar.text];
    
    NSArray *nameDataArray = [totalData  filteredArrayUsingPredicate:predicate];
     NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.City contains[cd] %@", searchBar.text];
    NSArray *cirysArray = [totalData  filteredArrayUsingPredicate:predicate2];
    

    NSMutableSet *dataSet = [NSMutableSet setWithArray:nameDataArray];
    [dataSet addObjectsFromArray:cirysArray];
    
    self.searchBarArray =[dataSet allObjects];
    //[self CustomSearchDataByUsingTwoKeys:nameDataArray andCitysArray:cirysArray andTotalDataArray:totalData];
    
    
//    //NSLog(@"%@",self.searchBarArray);
    if ([searchBar.text isEqualToString:@""])
    {
        searchStatus=NO;
        [self viewWithTag:searchBar.tag+400].hidden = YES;
    }
   // //NSLog(@"Array is %@",array);
  //  if (totalData.count)
    [ (UITableView *)   [self viewWithTag:searchBar.tag-100] reloadData] ;
    
}
//-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    [self searchBarKeyboardDismissed:searchBar];
//}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchStatus=NO;
    searchBar.showsCancelButton=NO;
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    [self viewWithTag:searchBar.tag+400].hidden = YES;
    [ (UITableView *)   [self viewWithTag:searchBar.tag-100] reloadData] ;

}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    for(id subview in [[[searchBar subviews] firstObject] subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
    //[self searchBarKeyboardDismissed:searchBar];
    searchBar.showsCancelButton=YES;
    
}

-(void)searchBarKeyboardDismissed:(UISearchBar *)searchBar
{
    // [searchBar resignFirstResponder];
   // searchBar.text = @"";
    currentSearchBar = searchBar;
    searchBar.showsCancelButton = YES;
//    self.searchBarArray = nil;
    [ (UITableView *)   [self viewWithTag:searchBar.tag-100] reloadData] ;
}

#pragma -mark scrollview delegate methods

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // [currentSearchBar resignFirstResponder];

    [self searchBarSearchButtonClicked:currentSearchBar];
}

#pragma mark - Search Content

-(NSArray *)CustomSearchDataByUsingTwoKeys:(NSArray *)namesArray andCitysArray :(NSArray *)cityArray andTotalDataArray:(NSArray *)totalArray
{
    
    NSMutableSet *searchObjects = [NSMutableSet set];
    
    if (namesArray.count || cityArray.count)
    {
   
        NSInteger maxValue = MAX(namesArray.count, cityArray.count);
        for (int i = 0; i < maxValue; i++)
        {
            NSString *resortName;
            
            if (i < namesArray.count)
                resortName = namesArray[i];
            
            
            for (NSDictionary *currentDictionary in totalArray)
            {
                if ([[currentDictionary objectForKey:@"Name"] isEqualToString:resortName] ||[[currentDictionary objectForKey:@"City"] isEqualToString:resortName] )
                    [searchObjects addObject:currentDictionary];
            }
        }
    }
    
    return [searchObjects allObjects];
    
//    NSString *str=[self.searchBarArray objectAtIndex:indexPath.row];
//    for (int j=0; j<[[self.locationsDictionary valueForKey:[self.locationsTypesArray objectAtIndex:tableView.tag-TableViewTag]]count]; j++) {
//        dic=[[self.locationsDictionary valueForKey:[self.locationsTypesArray objectAtIndex:tableView.tag-TableViewTag]]objectAtIndex:j];
//        NSString *str1=[dic valueForKey:@"Name"];
//        if ([str1 isEqualToString:str]) {
//            break;
//        }
//    }

    
}

@end
