//
//  webServiceHelper.h
//  Employee
//
//  Created by Country Club on 02/11/15.
//  Copyright © 2015 Country Club. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface webServiceHelper : NSObject


+(instancetype)sharedWebService;


-(void)ProfileEmpNumber:(NSString*)empid completionBlock:(void(^)(NSMutableDictionary *responseDictionry,NSInteger statuscode, NSError *err))completionHandler;

-(void)postSalesDataDic:(NSDictionary *)dic completionBlock:(void(^)(NSMutableArray *array,NSInteger stastuscode, NSError *err))completionHandler;


-(void)GetVenues:(NSString*)uid completionBlock:(void(^)(NSMutableArray *responseDictionry,NSInteger statuscode, NSError *err))completionHandler;

-(void)GetCategories:(NSString*)uid ;

-(void)GetHistory:(NSString *)uid Utype:(NSString *)utype completionBlock:(void(^)(NSArray *responseDictionry,NSInteger statuscode, NSError *err))completionHandler;


@end
