//
//  Utils.h
//  Employee
//
//  Created by Country Club on 02/11/15.
//  Copyright © 2015 Country Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (BOOL)isConnectedToNetwork;
+(UIImage*)makeImageToCircleShape:(UIImage*)image;
+(void)makeImageToCircleShape:(UIImageView*)imageView cornerRadius:(int)cornerRadius;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
