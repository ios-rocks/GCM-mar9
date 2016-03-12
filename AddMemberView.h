//
//  AddMemberView.h
//  Employee
//
//  Created by Country Club on 06/01/16.
//  Copyright © 2016 Country Club. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddMemberViewDelegate <NSObject>
-(void)NewMemberData:(NSDictionary *)dic;
@end


@interface AddMemberView : UIView<UITextFieldDelegate>
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic,assign) id <AddMemberViewDelegate> delegate;

@end
