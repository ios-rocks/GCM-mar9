//
//  AddMemberView.m
//  Employee
//
//  Created by Country Club on 06/01/16.
//  Copyright © 2016 Country Club. All rights reserved.
//

#import "AddMemberView.h"
#define ViewTag 5500

@implementation AddMemberView
{
    UITextField *currenTextFiled;
    BOOL isValiadEmail,isValidPhonenumber;
    AppDelegate *app;
    UIScrollView *scrollView;
    int padding;
    CGFloat textFieldHight;
    NSArray *ValuesArray;
    NSMutableArray *feeArray;
    NSUserDefaults *userDefaults;
    NSString *stringTotal;
}


//creating textFields and submit button for newmember
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    
        padding=0;
        // Initialization code
        app=(AppDelegate*)[UIApplication sharedApplication].delegate;
        self.backgroundColor =[UIColor whiteColor];
       ValuesArray =@[@"Venue",@"club",@"Mem Fee",@"AMC",@"Total price",@"Towards Mem Fee No",@"Member Name",@"DOB",@"Address Line1",@"Address Line2",@"Pincode",@"intro Member",@"Agreement No",@"Mobile",@"Email",@"Spouse Name",@"Spouse Dob",@"Father Name",@"Mother Name",@"Child1 Name",@"Child1 Dob",@"Child2 Name",@"child2 Dob",@"Child3 Name",@"Child3 Dob",@"Additional Benfits",@"Initial Amount Paid"];
        
         textFieldHight = ((self.bounds.size.height-100)/9.f)-2;
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        scrollView.showsVerticalScrollIndicator=YES;
        for (int i =0 ; i < ValuesArray.count; i++)
        {
            UITextField *textfiled = [self createTextFiledWithTag:ViewTag+i+1 PlaceHolderText:[ValuesArray objectAtIndex:i] KeyboardType:UIKeyboardTypeEmailAddress RetunKeyType:UIReturnKeyNext andFrame:CGRectMake(30, 60+padding+(i*textFieldHight), self.bounds.size.width-50, 44) andSecure:NO];
            padding=padding+8;
            [self addSubview:scrollView];
            [scrollView addSubview:textfiled];
            
            [textfiled AddCustomToolBarAndStartTextFiledTag:ViewTag+1 andEndFieldTag:ViewTag+27];
            
        }
        
        UIButton *submitButton = [self createButtonWithtag:ViewTag+23 andTitle:@"Submit" andTitleColor:[UIColor whiteColor] andFrame:CGRectMake(40, textFieldHight*34, self.bounds.size.width-90, textFieldHight)];
        [scrollView addSubview:submitButton];
        [submitButton addTarget:self action:@selector(submitData:) forControlEvents:UIControlEventTouchUpInside];
        
        scrollView.contentSize = CGSizeMake(self.bounds.size.width,textFieldHight*34);
       // [scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(currenTextFiled.frame)-50) animated:NO];
       userDefaults = [NSUserDefaults standardUserDefaults];
        currenTextFiled =(UITextField *)[self viewWithTag:ViewTag+1];
        [currenTextFiled changeInputViewAsPickerView:[userDefaults objectForKey:@"venues"]];
        
        currenTextFiled =(UITextField *)[self viewWithTag:ViewTag+2];
        [currenTextFiled changeInputViewAsPickerView:[userDefaults objectForKey:@"catgs"]];
        
    }
    return self;
}

#pragma mark - TextFiled Delgate Methods
-(void)submitData:(UIButton *)sender
{
    
    NSMutableDictionary *newMemDic = [[NSMutableDictionary alloc]init];
    for (int i =0 ; i < ValuesArray.count; i++)
    {
        currenTextFiled = (UITextField*)[self viewWithTag:ViewTag+i+1];
        [newMemDic setObject:currenTextFiled.text forKey:[ValuesArray objectAtIndex:i]];
        
    }
    webServiceHelper *share=[webServiceHelper new];
    
    [share postSalesDataDic:newMemDic completionBlock:^(NSMutableArray *array, NSInteger stastuscode, NSError *err)
     {
         
     }];


    
   // //NSLog(@"dic dats is %@ ",newMemDic);
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(NewMemberData:)])
    {
       // [self.delegate NewMemberData:newMemDic];
    
    }
    
    
    BOOL isAlertShow = NO,isMobileNumberEmpty= NO,isEmailEmpty = NO;
    
    BOOL firstcome = YES;

    [currenTextFiled resignFirstResponder];
    NSMutableString *alertString = [[NSMutableString alloc]initWithString:@"Please Enter "];

    for (int i= 1; i <= ValuesArray.count; i++)
    {
        currenTextFiled = (UITextField*)[self viewWithTag:ViewTag+i];
        NSString *alert =currenTextFiled.text.length?@"":currenTextFiled.placeholder;
        
        if (currenTextFiled.tag == ViewTag+15 && !currenTextFiled.text.length)
            isEmailEmpty = YES;
        else if (currenTextFiled.tag == ViewTag+14&& !currenTextFiled.text.length)
            isMobileNumberEmpty = YES;
        
        
        if (alert.length)
        {
            if (!firstcome)
                [alertString appendString:@","];
            isAlertShow = YES;
            firstcome = NO;
            [alertString appendString:alert];
            
        }
        
    } if (!isAlertShow)
    {
        
        if ((!isValiadEmail && !isValidPhonenumber)&&(!isMobileNumberEmpty && !isEmailEmpty) )
        {
            [alertString  appendString:@"Correct Email and Mobile No"];
            isAlertShow = YES;
        }
        else if (!isValidPhonenumber && !isMobileNumberEmpty)
        {
            [alertString  appendString:@"Correct Mobile No"];
            isAlertShow = YES;
        }
        else if (!isValiadEmail && !isEmailEmpty)
        {
            [alertString  appendString:@"Correct Email"];
            isAlertShow = YES;
        }
    }
    
    if (isAlertShow)
    {
        
        [_gAppDelegate showAlertView:YES message:alertString];
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:alertString message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
    }
    else
    {

    webServiceHelper *share=[webServiceHelper new];
    
[share postSalesDataDic:newMemDic completionBlock:^(NSMutableArray *array, NSInteger stastuscode, NSError *err)
    {
        
    }];
    }
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    
    currenTextFiled = textField;
    if ([currenTextFiled.placeholder isEqualToString:@"DOB"]||[currenTextFiled.placeholder isEqualToString:@"Child1 Dob"]||[currenTextFiled.placeholder isEqualToString:@"child2 Dob"]||[currenTextFiled.placeholder isEqualToString:@"Child3 Dob"]||[currenTextFiled.placeholder isEqualToString:@"Spouse Dob"])
    {
        [currenTextFiled changeInputViewAsDatePickerView];
        
    }
    if ([currenTextFiled.placeholder isEqualToString:@"Mobile"]||[currenTextFiled.placeholder isEqualToString:@"Pincode"])
    {
        currenTextFiled.keyboardType =UIKeyboardTypeNumberPad;
    }
    if ([currenTextFiled.placeholder isEqualToString:@"Email"])
    {
        currenTextFiled.keyboardType =UIKeyboardTypeEmailAddress;;
    }

    
    
    
    return YES;
    

}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    if (textField.tag == ViewTag+15)
        isValiadEmail = NO;
    if (textField.tag == ViewTag+14)
        isValidPhonenumber = NO;

    currenTextFiled = textField;
    [scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(currenTextFiled.frame)-50) animated:NO];

//[scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(currenTextFiled.frame)) animated:NO];

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField myTextFieldDidEndEditing:textField];
    
    
    if (textField.tag == ViewTag+15)
        isValiadEmail = [self validEmail:textField.text];
    else if(textField.tag == ViewTag+14)
        isValidPhonenumber = 10 <= textField.text.length?YES:NO;
    else if(textField.tag == ViewTag+5)
        textField.text = [textField.text integerValue]?textField.text:nil;

    
    UITextField *textField2=(UITextField *)[self viewWithTag:ViewTag+2];
   // //NSLog(@"text is %@ ",textField2.text);
    NSArray *arr;
    if (textField2 ==(UITextField *)[self viewWithTag:ViewTag+2])
    {
        NSArray *salesinfo=[userDefaults objectForKey:@"salesinfo"];
        arr=[userDefaults objectForKey:@"catgs"];
        for (int i=0; i<arr.count; i++)
        {
                    if ([textField2.text isEqualToString:[arr objectAtIndex:i]])
                   {
               UITextField *textField3=(UITextField *)[self viewWithTag:ViewTag+3];
                       
        NSString *str1=[NSString stringWithFormat:@"MemFee=%@",[[salesinfo objectAtIndex:i] valueForKey:@"mfee"]];
     NSString *str2=[NSString stringWithFormat:@"OneShot=%@",[[salesinfo objectAtIndex:i] valueForKey:@"oneshot"]];
     [textField3 changeInputViewAsPickerView:(NSMutableArray *)@[str1,str2]];
               
    
            UITextField *textField4=(UITextField *)[self viewWithTag:ViewTag+4];

            textField4.text=[[salesinfo objectAtIndex:i] valueForKey:@"amc"];
  //  [textField3 changeInputViewAsPickerView:(NSMutableArray *)@[[[salesinfo objectAtIndex:i] valueForKey:@"mfee"],[[salesinfo objectAtIndex:i] valueForKey:@"oneshot"]]];
                
    }}}
    
    UITextField *textField5=(UITextField *)[self viewWithTag:ViewTag+5];

    if (textField5 ==(UITextField *)[self viewWithTag:ViewTag+5])
    {
        UITextField *textField3=(UITextField *)[self viewWithTag:ViewTag+3];
        UITextField *textField4=(UITextField *)[self viewWithTag:ViewTag+4];
        NSString *trimmed = [textField3.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString* firstString = [[trimmed componentsSeparatedByString:@","] objectAtIndex:0];
        //NSLog( @"lenghth is  u s %lu ",(unsigned long)firstString.length);
        if (firstString.length>0)
        {
            
            NSString *string=[firstString substringToIndex:7];
            //NSLog(@"val is %@ ",string);

            if ([string isEqualToString:@"OneShot"])
            {
                NSString *str=[firstString substringFromIndex:8];
                NSInteger value=[str integerValue]+[textField4.text integerValue];
                textField5.text=[NSString stringWithFormat:@"%ld",(long)value];
                stringTotal=textField5.text;
            }
            
            else
            {
          
            NSString *str=[firstString substringFromIndex:7];
            NSInteger value=[str integerValue]+[textField4.text integerValue];
            textField5.text=[NSString stringWithFormat:@"%ld",(long)value];
            stringTotal=textField5.text;
                
            }
        }
        
    }

}

- (BOOL) validEmail:(NSString*) emailString
{
    
    
    
    if([emailString length]==0){
        
        return NO;
        
    }
    
    
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    
    
    //    //NSLog(@"%lu", (unsigned long)regExMatches);
    //
    if (regExMatches == 0) {
        
        return NO;
        
    } else {
        
        return YES;
        
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


//custom button and textfileds
-(UIButton *)createButtonWithtag:(NSInteger)tag andTitle:(NSString *)buttonTitle andTitleColor:(UIColor *)titleColor andFrame:(CGRect)frame
{
    UIButton *button =[[UIButton alloc]initWithFrame:frame];
    button.layer.cornerRadius = 5.0;
    button.titleLabel.font =[UIFont boldSystemFontOfSize:18];
       if (buttonTitle)
        [button setTitle:buttonTitle forState:UIControlStateNormal];
    
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithHexString:@"26AE90"];
    
    return button;
}
-(UITextField *)createTextFiledWithTag:(NSInteger)tag PlaceHolderText:(NSString *)placeholderText KeyboardType:(UIKeyboardType) keyboardtype RetunKeyType:(UIReturnKeyType) returnKeyType andFrame:(CGRect)frame andSecure:(BOOL)isSecure
{
    UITextField *textFiled = [[UITextField alloc]initWithFrame:frame];
    textFiled.tag = tag;
    textFiled.keyboardType = keyboardtype;
    textFiled.returnKeyType = returnKeyType;
    textFiled.secureTextEntry = isSecure;
    textFiled.placeholder = placeholderText;
    textFiled.layer.borderWidth=1;
    textFiled.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textFiled.layer.cornerRadius=5;
    textFiled.font =[UIFont fontWithName:@"Helvetica" size:12];
    textFiled.delegate = self;
    textFiled.textColor = [UIColor blackColor];
    return textFiled;
}


@end
