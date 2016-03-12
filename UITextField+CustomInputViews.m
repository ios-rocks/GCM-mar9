//
//  UITextField+CustomInputViews.m
//  CCP
//
//  Created by ATS-Purna on 4/5/14.
//  Copyright (c) 2014 ATS-MacMini3. All rights reserved.
//
// reference document http://ddeville.me/2011/03/add-variables-to-an-existing-class-in-objective-c/


#import "UITextField+CustomInputViews.h"
#import <objc/runtime.h>
//#import <objc/objc-load.h>

@implementation UITextField (CustomInputViews)
static char defaultHashkey[100];
int  startpresentTextFieldTag,endpresentTextFieldTag,myArrayLength,selectedRow;
float lastTranslation;
BOOL isAgainShow,isiPad;
UIView *customView ;
UIPickerView *picker;


#pragma -mark textfield delegate methods
-(void)myTextFieldDidBeginEditing:(UITextField *)textField
{
    
    if (!textField.text.length)
    {
        self.text=[self defaultHashkey:0];
    }
    float keyboardHeight ;
    
  //  [self resignFirstResponder];
    UIView *view = [self.superview viewWithTag:self.tag+1234];
    view.hidden = NO;
    ////NSLog(@"inputview frame is %@",NSStringFromCGRect(textField));
//    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//    {
                keyboardHeight = self.superview.frame.size.height- 280.00;
//        //NSLog(@"data is %f",keyboardHeight);

    //}
    
    int inputAccessoryHeght = 0;
    
    if (textField.inputAccessoryView)
    {
        inputAccessoryHeght = textField.inputAccessoryView.frame.size.height;
    }
    
    if ((keyboardHeight-inputAccessoryHeght) < textField.center.y )
    {
//        //NSLog(@"print y is %f",textField.center.y);
        float currentHeight = textField.center.y-(keyboardHeight-inputAccessoryHeght);
        float changeValue;
        if (lastTranslation)
        {
            changeValue = lastTranslation < currentHeight?currentHeight-lastTranslation:currentHeight-lastTranslation;
            
            lastTranslation =lastTranslation+changeValue;
        }
        else
        {
            changeValue = currentHeight;
            lastTranslation = changeValue;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
        self.superview.center = CGPointMake(self.superview.center.x, self.superview.center.y-changeValue);
         }];

      
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.superview.center = CGPointMake(self.superview.center.x, self.superview.center.y+lastTranslation);
            lastTranslation = 0;
        }];
    }
    [self enableAndDisableToolButtons:self.tag andLastTag:self.tag-1];
//       //NSLog(@"text field fram %@",NSStringFromCGRect(self.frame));
    
    
}
-(void)myTextFieldDidEndEditing:(UITextField *)textField
{
   
//    textField.text= [self defaultHashkey:selectedRow];
     [self.superview viewWithTag:self.tag+1234].hidden = YES;
    if (lastTranslation && isAgainShow)
    {
         [UIView animateWithDuration:0.3 animations:^{
        self.superview.center = CGPointMake(self.superview.center.x, self.superview.center.y+lastTranslation);
        lastTranslation = 0;
         }];

    }
    
    
}


#pragma -mark setContent


-(NSString *)defaultHashkey:(NSInteger)pos
{
 
    return objc_getAssociatedObject(self, &defaultHashkey[pos]);
}

-(void)setDefaultHash:(NSString *)data andpostion:(int)pos
{
    objc_setAssociatedObject(self, &defaultHashkey[pos], data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
 
    
}

//-(void)ChangeTextFieldPlaceWhenKeybordHeightShownAndHide
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:@"UIKeyboardWillShowNotification"
//                                               object:nil];
//    
// /*  [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidHide:)
//                                                 name:@"UIKeyboardDidHideNotification"
//                                               object:nil];*/
//}
//
//- (void) keyboardWillShow:(NSNotification *)note
//{
//    
//    NSDictionary *userInfo = [note userInfo];
//    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    CGRect keybordFrame =[[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    
//    
//    
//    //NSLog(@"keyboar frame %@",NSStringFromCGRect(self.frame));
//    //NSLog(@"Keyboard Height: %f Width: %f", kbSize.height, kbSize.width);
//    /* [[NSNotificationCenter defaultCenter] postNotificationName:@"myevent"
//                                                        object:self
//                                                      userInfo:userInfo];*/
//    // move the view up by 30 pts
////    CGRect frame = self.view.frame;
////    frame.origin.y = -30;
//    
////    [UIView animateWithDuration:0.3 animations:^{
////        self.view.frame = frame;
////    }];
//}
//
//- (void) keyboardDidHide:(NSNotification *)note {
//    
//    //NSLog(@"keybora hide ");
//    // move the view back to the origin
//  //  CGRect frame = self.view.frame;
// //   frame.origin.y = 0;
//    
////    [UIView animateWithDuration:0.3 animations:^{
////        self.view.frame = frame;
////    }];
//}
//
-(void)myTextField
{
//    //NSLog(@"my  methods frame %@",NSStringFromCGRect(self.frame));
}
#pragma -mark Create Custom Tool Bar Methods

-(void)changeStartFiledTag:(int )startTag AndEndFieldTag:(int)endTag
{
    startpresentTextFieldTag = startTag;
    endpresentTextFieldTag = endTag;
   }

-(void)AddCustomToolBarAndStartTextFiledTag:(int)startTag andEndFieldTag:(int)endTag
{
    //here delegate assign for using calling category methods
     //self.delegate = self;
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        isiPad = YES;
    }
    
    startpresentTextFieldTag = startTag;
    endpresentTextFieldTag = endTag;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
//    if (isiPad)
//    customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 44)];
//    else
        customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,screenRect.size.width, 44)];
    
    UIButton *previousButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 0,30, 44)];
        [previousButton setTitle:@"<" forState:UIControlStateNormal];
        [previousButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        previousButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:30];
        [previousButton addTarget:self action:@selector(myToolBarActions:) forControlEvents:UIControlEventTouchUpInside];
        previousButton.tag = 24241;
        [customView addSubview:previousButton];
        
        UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(55, 0, 30, 44)];
        [nextButton setTitle:@">" forState:UIControlStateNormal];
        [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        nextButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:30];
        [nextButton addTarget:self action:@selector(myToolBarActions:) forControlEvents:UIControlEventTouchUpInside];
        nextButton.tag = 24242;
        [customView addSubview:nextButton];
        
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame = CGRectMake(customView.bounds.size.width-90, 0, 64, 44);
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(myToolBarActions:) forControlEvents:UIControlEventTouchUpInside];
        doneButton.tag = 24243;
        [customView addSubview:doneButton];
        customView.backgroundColor = [UIColor lightGrayColor];
    
    //Avenir Heavy 15.0
        
        UILabel *currentTextfiledTitle = [[UILabel alloc]init];
    
        currentTextfiledTitle.text = self.placeholder;
    
        currentTextfiledTitle.tag = 24244;
    currentTextfiledTitle.font = [UIFont fontWithName:@"Avenir Heavy" size:15.0];
        currentTextfiledTitle.textColor = [UIColor blackColor];
    currentTextfiledTitle.backgroundColor=[UIColor clearColor];
        [customView addSubview:currentTextfiledTitle];
     CGSize constraintSize = currentTextfiledTitle.frame.size;
    CGSize dims;
//           dims = [currentTextfiledTitle.text  sizeWithFont:currentTextfiledTitle.font];
      dims = [currentTextfiledTitle.text boundingRectWithSize:constraintSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: currentTextfiledTitle.font}
                                               context:nil].size;
   
    currentTextfiledTitle.frame = CGRectMake(0, 0, dims.width, dims.height);
    currentTextfiledTitle.center = CGPointMake(customView.bounds.size.width/2, customView.bounds.size.height/2);

    self.inputAccessoryView = customView;
    
}

-(void)myToolBarActions:(UIButton *)sender
{
    
    
    if (sender.tag == 24241)
    {
        if (self.tag >= (startpresentTextFieldTag+1))
        {
            isAgainShow = NO;
            [self enableAndDisableToolButtons:self.tag-1 andLastTag:self.tag];
        }
    }
    else if (sender.tag == 24242)
    {
        if (self.tag <= endpresentTextFieldTag-1)
        {
            isAgainShow = NO;
            [self enableAndDisableToolButtons:self.tag+1 andLastTag:self.tag];
        }
    }
    else
    {
         isAgainShow = YES;
       
          [self resignFirstResponder];
        
    }
    
}
-(void)setFirsttag:(int)start andLastTag:(int)last
{
    startpresentTextFieldTag = start;
    endpresentTextFieldTag = last;
}
-(void)enableAndDisableToolButtons:(NSInteger)presentTextFieldTag andLastTag:(NSInteger)lastUsedpresentTextFieldTag
{
    
    UITextField *textField =(UITextField *) [self.superview viewWithTag:presentTextFieldTag];
    if (!textField.isUserInteractionEnabled)
    {
        if (textField.tag!=startpresentTextFieldTag &&textField.tag != endpresentTextFieldTag)
        {
           presentTextFieldTag = presentTextFieldTag >lastUsedpresentTextFieldTag ? presentTextFieldTag+1:presentTextFieldTag-1;
        }
        
    }
    textField =(UITextField *) [self.superview viewWithTag:presentTextFieldTag];
    [UIView animateWithDuration:0.5 animations:^{
         [textField becomeFirstResponder];
    }];
   
    
    if (textField.tag == startpresentTextFieldTag)
    {
        UIButton *button = (UIButton *)[[textField.inputAccessoryView subviews]objectAtIndex:0] ;
        button.enabled = NO;
        button.alpha = 0.3;
    }
    else if(textField.tag == endpresentTextFieldTag)
    {
        UIButton *button = (UIButton *)[[textField.inputAccessoryView subviews]objectAtIndex:1] ;
        button.enabled = NO;
        button.alpha = 0.3;
    }
    else
    {
        UIButton *button = (UIButton *)[[textField.inputAccessoryView subviews]objectAtIndex:0] ;
        button.enabled = YES;
        button.alpha = 1;
        UIButton *button1 = (UIButton *)[[textField.inputAccessoryView subviews]objectAtIndex:1] ;
        button1.enabled = YES;
        button1.alpha = 1;
    }
}

#pragma -mark Datepicker View Methods

-(void)changeInputViewAsDatePickerView
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    self.inputView = datePicker;
    datePicker.tag = self.tag;
    [datePicker addTarget:self action:@selector(changeDatePicker:) forControlEvents:UIControlEventValueChanged];
}
-(void)changeDatePicker:(UIDatePicker *)picker
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.text =[dateFormat stringFromDate:picker.date];
}

#pragma -mark PickerViewCreation, DataSource and Delegate Methods

-(void)changeInputViewAsPickerView:(NSMutableArray *)dataArray
{
    
    myArrayLength = (int)dataArray.count;
    if (dataArray.count)
    for (int i= 0;i < dataArray.count;i++)
        [self setDefaultHash:[dataArray objectAtIndex:i] andpostion:i];
    else
    {
        myArrayLength = 1;
        [self setDefaultHash:@"No Data" andpostion:0];
        self.text = @"NO Data";
        self.userInteractionEnabled = NO;
    }
       picker = [[UIPickerView alloc]init];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    picker.tag = self.tag;
    [[NSUserDefaults standardUserDefaults]setInteger:dataArray.count forKey:[NSString stringWithFormat:@"%ld",(long)self.tag]];
    
           self.inputView =picker;
    
}
-(NSInteger )numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return   [[NSUserDefaults standardUserDefaults]integerForKey:[NSString stringWithFormat:@"%ld",(long)self.tag]];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [self  defaultHashkey:row];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    [pickerLabel setText:[self defaultHashkey:row]];
    
    return pickerLabel;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(int)row inComponent:(NSInteger)component
{
    selectedRow=row;
    self.text = [self defaultHashkey:row];
    
}

@end
