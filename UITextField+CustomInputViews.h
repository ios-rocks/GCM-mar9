//
//  UITextField+CustomInputViews.h
//  CCP
//
//  Created by ATS-Purna on 4/5/14.
//  Copyright (c) 2014 ATS-MacMini3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (CustomInputViews) <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
   
}


-(void)setFirsttag:(int)start andLastTag:(int)last ;
-(void)AddCustomToolBarAndStartTextFiledTag:(int)startTag andEndFieldTag:(int)endTag;
-(void)changeInputViewAsPickerView:(NSMutableArray *)dataArray;
-(void)changeInputViewAsDatePickerView;
// keyborad show and hide
-(void)myTextFieldDidBeginEditing:(UITextField *)textField;
-(void)myTextFieldDidEndEditing:(UITextField *)textField;
@end
