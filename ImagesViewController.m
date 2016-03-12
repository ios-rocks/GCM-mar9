//
//  ImagesViewController.m
//  Employee
//
//  Created by Country Club on 10/12/15.
//  Copyright © 2015 Country Club. All rights reserved.
//

#import "ImagesViewController.h"
#import "MBProgressHUD.h"
#import "FTWCache.h"
#import "NSString+MD5.h"

@interface ImagesViewController ()
{
    MBProgressHUD *HUD;
    NSMutableData *responseData;
    UIPageControl *pageControl;
    NSMutableArray *imagesArray;
}


@end

@implementation ImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self gettingImages];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gettingImages
{
    if (![Utils isConnectedToNetwork]) {
        [_gAppDelegate showAlertView:YES message:@"Please Check Inernet Connection"];
        return;
    }

    
    if ([self.resortId isEqual:[NSNull null]]) {
        self.resortId=@"null";
    }
    NSString* post = [NSString stringWithFormat:@"eid=%@&dname=%@",self.resortName,self.resortId];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    
   NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"http://www.countryclubworld.com/akhilapp/ccapp/index_v1.php/resortimages1"]];
    
     NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:postData];
    
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
                                      {
                                          
                                       //   NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *)response;
                                          
                                          
                                          //NSLog(@" reponse is %@ ",httpResponse);
                                          //NSLog(@"  response is %ld ",(long)httpResponse.statusCode);
                                          
                                          NSDictionary *dict = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] objectForKey:@"image"];
                                          
                             dispatch_async(dispatch_get_main_queue(), ^(void){
                                              imagesArray = [NSMutableArray array];
                                              for (NSDictionary *dic in dict) {
                                                  [imagesArray addObject:[dic objectForKey:@"img"]];
                                              }
                                              //NSLog(@"%@",imagesArray);
                                             [self showImages];
                             });
                                          
                                      }];
    [dataTask resume];
    
}

//- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
//{
//    //NSLog(@"Did Fail");
//    
//    [HUD hide:YES];
//    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet Connection" message:@"Sorry, no internet connectivity detected Please reconnect and try again" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    [alertController addAction:ok];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
//    
//}
//- (void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//    self.scroll.contentOffset = CGPointZero;
//    self.scroll.contentInset = UIEdgeInsetsZero;
//}
//

-(void)showImages

{
    CGFloat width = self.view.frame.size.width;
 //   CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    // CGFloat imageheight,imagewidth;
    
  //  imagewidth = width;
       //  self.scroll.frame = CGRectMake(self.scroll.frame.origin.x, self.scroll.frame.origin.y, width, height);
//
    
    
    CGFloat height ;
        if (width>400) {
            height = 279;
            
        }
        else
        {
            height = 186;
            
        }
   
    
//    if (self.view.frame.size.height==568) {
//        
//        self.scroll.frame = CGRectMake(self.scroll.frame.origin.x, self.scroll.frame.origin.y, self.scroll.frame.size.width, self.scroll.frame.size.height+88);
//          
//    }
    //self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.delegate = self;
    
    for (UIView *view in self.scroll.subviews) {
        [view removeFromSuperview];
    }
    int x = 0;
    for (int i=0; i<imagesArray.count; i++) {
        
        UIImageView  *changeViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, x, width, height)];

    changeViewImage.layer.borderWidth = 1.0f;
    changeViewImage.layer.borderColor = [UIColor whiteColor].CGColor;
    NSString *urlString = [imagesArray objectAtIndex:i];
        
    changeViewImage.image = [UIImage imageNamed:@"placeholder.png"];
        
        NSURL *imageURL = [NSURL URLWithString:urlString];
        NSString *key = [urlString MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            [changeViewImage stopAnimating];
            UIImage *image2 = [UIImage imageWithData:data];
            changeViewImage.image = [ImagesViewController imageWithImage:image2 scaledToSize:CGSizeMake(width, height)];
        } else {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image2 = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [changeViewImage stopAnimating];
                    changeViewImage.image = [ImagesViewController imageWithImage:image2 scaledToSize:CGSizeMake(width, height)];
                    if (!data) {
                        changeViewImage.image = [UIImage imageNamed:@"placeholder.png"];
                    }
                    
                });
            });
        }
        
        
        [self.scroll addSubview:changeViewImage];
        
        x = x+height;
    }
    
    self.scroll.contentSize = CGSizeMake(width,height*imagesArray.count);
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
}




- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [self showImages];
    
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
