//
//  JoinNowPageView.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 11/27/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "JoinNowPageView.h"

@implementation JoinNowPageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupVariable];
        
        [self initLayout];
    }
    
    return self;
}

- (void) setupVariable{
    self.helperIns = [Helper shareInstance];
}

-(void)initLayout{
    
    self.mainJoinView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height)];
    [self.mainJoinView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.mainJoinView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    UIButton *addPic=[UIButton buttonWithType:UIButtonTypeCustom];
    [addPic setFrame:CGRectMake(0.0f, 0.0, self.bounds.size.width, 100.0f)];
    [addPic addTarget:self action:@selector(changeAvatarGesture) forControlEvents:UIControlEventTouchUpInside];
    [self.mainJoinView addSubview:addPic];
    
    self.btnProfile = [[AvatarButton alloc] initWithFrame:CGRectMake(10.30f, 10.30f, 80.0f, 80.0f)];
    [self.btnProfile addTarget:self action:@selector(changeAvatarGesture) forControlEvents:UIControlEventTouchUpInside];
    [addPic addSubview:self.btnProfile];
    
    UILabel *lbAddPic=[ [UILabel alloc ] initWithFrame:CGRectMake(130.0f, 40.0f, 130.0f, 30.0f) ];
    [lbAddPic setTextColor:[UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1.0]];
    lbAddPic.text=@"ADD A PICTURE";
    lbAddPic.font=[self.helperIns getFontThin:18.0f];
    [self.mainJoinView addSubview:lbAddPic];
    
    UIImageView* imgArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(260.0f, 44.0f, 20.0f, 20.0f)];
    imgArrowView.image = [SVGKImage imageNamed:@"arrow-grey.svg"].UIImage;
    imgArrowView.alpha=0.25;
    [addPic addSubview:imgArrowView];
    
    CALayer *bottomPhoto = [CALayer layer];
    [bottomPhoto setFrame:CGRectMake(0.0f, 102.0f, self.bounds.size.width, 1.0f)];
    [bottomPhoto setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.mainJoinView.layer addSublayer:bottomPhoto];
    
    self.txtFirstN = [[SCTextField alloc] initWithdata:10.0f withPaddingRight:20.0f withIcon:nil withFont:[self.helperIns getFontThin:12.0f] withTextColor:nil withFrame:CGRectMake(0, 102.0f, self.bounds.size.width/2, 40.0f)];
    [self.txtFirstN setKeyboardType:UIKeyboardTypeAlphabet];
    [self.txtFirstN setPlaceholder:@"FIRST NAME"];
    [self.txtFirstN setAlpha:1.0f];
    [self.txtFirstN setTag:3];
    [self.txtFirstN setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.mainJoinView addSubview:self.txtFirstN];
    
    CALayer *centerName = [CALayer layer];
    [centerName setFrame:CGRectMake(self.bounds.size.width/2, 102.0f, 1.0f, 40.0f)];
    [centerName setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.layer addSublayer:centerName];
    
    self.txtLastN = [[SCTextField alloc] initWithdata:10.0f withPaddingRight:20.0f withIcon:nil withFont:[self.helperIns getFontThin:12.0f] withTextColor:nil withFrame:CGRectMake(self.bounds.size.width/2, 102.0f, self.bounds.size.width/2, 40.0f)];
    [self.txtLastN setKeyboardType:UIKeyboardTypeAlphabet];
    [self.txtLastN setPlaceholder:@"LAST NAME"];
    [self.txtLastN setAlpha:1.0f];
    [self.txtLastN setTag:3];
    [self.txtLastN setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.mainJoinView addSubview:self.txtLastN];
    
    CALayer *bottomFLName = [CALayer layer];
    [bottomFLName setFrame:CGRectMake(0.0f, 142.0f, self.bounds.size.width, 1.0f)];
    [bottomFLName setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.mainJoinView.layer addSublayer:bottomFLName];
    
    UIView *circleView1 = [[UIView alloc] initWithFrame: CGRectMake(7.68, 149.0f,25.0f ,25.0f )];
    [circleView1 setBackgroundColor:[UIColor colorWithRed:0/255.0f green:205/255.0f blue:210/255.0f alpha:1.0]];
    circleView1.layer.cornerRadius = circleView1.bounds.size.width / 2;
    [self.mainJoinView addSubview:circleView1];
    
    UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    imgUser.image = [SVGKImage imageNamed:@"form-icon-username.svg"].UIImage;
    [circleView1 addSubview:imgUser];
    
    UILabel *lbUser=[ [UILabel alloc ] initWithFrame:CGRectMake(38.40f, 142.0f, 74.67f, 40.0f) ];
    [lbUser setTextColor:[UIColor colorWithRed:187/255.0f green:187/255.0f blue:187/255.0f alpha:1.0]];
    lbUser.text=@"USERNAME";
    lbUser.font=[self.helperIns getFontThin:14.0f];
    [self.mainJoinView addSubview:lbUser];
    
    self.txtUserNameJoin = [[SCTextField alloc] initWithdata:0.0f withPaddingRight:10.0f withIcon:nil withFont:[self.helperIns getFontThin:12.0f] withTextColor:nil withFrame:CGRectMake(130.0f, 142.0f, self.bounds.size.width-130.0f, 40.0f)];
    [self.txtUserNameJoin setKeyboardType:UIKeyboardTypeAlphabet];
    [self.txtUserNameJoin setPlaceholder:@"USERNAME"];
    [self.txtUserNameJoin setAlpha:1.0f];
    [self.txtUserNameJoin setTag:3];
    [self.txtUserNameJoin setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.mainJoinView addSubview:self.txtUserNameJoin];
    
    CALayer *bottomUserName = [CALayer layer];
    [bottomUserName setFrame:CGRectMake(0.0f, 182.0f, self.bounds.size.width, 1.0f)];
    [bottomUserName setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.mainJoinView.layer addSublayer:bottomUserName];
    
    UIView *circleView2 = [[UIView alloc] initWithFrame: CGRectMake(7.68, 189.0f,25.0f ,25.0f )];
    [circleView2 setBackgroundColor:[UIColor colorWithRed:234/255.0f green:214/255.0f blue:7/255.0f alpha:1.0]];
    circleView2.layer.cornerRadius = circleView2.bounds.size.width / 2;
    [self.mainJoinView addSubview:circleView2];
    
    UIImageView* imgPass = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    imgPass.image = [SVGKImage imageNamed:@"form-icon-password.svg"].UIImage;
    [circleView2 addSubview:imgPass];
    
    UILabel *lbPass=[ [UILabel alloc ] initWithFrame:CGRectMake(38.40f, 182.0f, 74.67f, 40.0f) ];
    [lbPass setTextColor:[UIColor colorWithRed:187/255.0f green:187/255.0f blue:187/255.0f alpha:1.0]];
    lbPass.text=@"PASSWORD";
    lbPass.font=[self.helperIns getFontThin:14.0f];
    [self.mainJoinView addSubview:lbPass];
    
    self.txtPasswordJoin = [[SCTextField alloc] initWithdata:0.0f withPaddingRight:10.0f withIcon:nil withFont:[self.helperIns getFontThin:12.0f] withTextColor:nil withFrame:CGRectMake(130.0f, 182.0f, self.bounds.size.width-130.0f, 40.0f)];
    [self.txtPasswordJoin setKeyboardType:UIKeyboardTypeAlphabet];
    [self.txtPasswordJoin setSecureTextEntry:YES];
    [self.txtPasswordJoin setPlaceholder:@"PASSWORD"];
    [self.txtPasswordJoin setAlpha:1.0f];
    [self.txtPasswordJoin setTag:4];
    [self.txtPasswordJoin setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.mainJoinView addSubview:self.txtPasswordJoin];
    
    CALayer *bottomPassword = [CALayer layer];
    [bottomPassword setFrame:CGRectMake(0.0f, 222.0f, self.bounds.size.width, 1.0f)];
    [bottomPassword setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.mainJoinView.layer addSublayer:bottomPassword];
    
    UIView *circleView5 = [[UIView alloc] initWithFrame: CGRectMake(7.68, 229.0f,25.0f ,25.0f )];
    [circleView5 setBackgroundColor:[UIColor colorWithRed:156.0/255.0f green:106/255.0f blue:184/255.0f alpha:1.0]];
    circleView5.layer.cornerRadius = circleView5.bounds.size.width / 2;
    [self.mainJoinView addSubview:circleView5];
    
    UIImageView* imgBirth = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    imgBirth.image = [SVGKImage imageNamed:@"form-icon-birthdate.svg"].UIImage;
    [circleView5 addSubview:imgBirth];
    
    UILabel *lbBirthday=[ [UILabel alloc ] initWithFrame:CGRectMake(38.40f, 222.0f, 74.67f, 40.0f) ];
    [lbBirthday setTextColor:[UIColor colorWithRed:187/255.0f green:187/255.0f blue:187/255.0f alpha:1.0]];
    lbBirthday.text=@"BIRTHDAY";
    lbBirthday.font=[self.helperIns getFontThin:14.0f];
    [self.mainJoinView addSubview:lbBirthday];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate=[NSDate date];
    [datePicker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    
    //to make the done button aligned to the right
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    self.txtBirthDayJoin = [[SCTextField alloc] initWithdata:0.0f withPaddingRight:50.0f withIcon:nil withFont:[self.helperIns getFontThin:12.0f] withTextColor:nil withFrame:CGRectMake(130.0f,222.0f, self.bounds.size.width-130.0f, 40)];
    [self.txtBirthDayJoin setPlaceholder:@"BIRTHDAY"];
    [self.txtBirthDayJoin setAlpha:1.0f];
    self.txtBirthDayJoin.inputView=datePicker;
    self.txtBirthDayJoin.inputAccessoryView = toolbar;
    self.txtBirthDayJoin.text = [self formatDate:datePicker.date];
    [self.mainJoinView addSubview:self.txtBirthDayJoin];
    
    CALayer *bottomBirth = [CALayer layer];
    [bottomBirth setFrame:CGRectMake(0.0f, 262.0f, self.bounds.size.width, 1.0f)];
    [bottomBirth setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.mainJoinView.layer addSublayer:bottomBirth];
    
    self.btnGender =[[GenderView alloc] initWithFrame:1 withFrame:CGRectMake(0.0f, 263.0f, self.bounds.size.width, 40.0f)];
    [self.mainJoinView addSubview:self.btnGender];
    
    CALayer *bottomGender = [CALayer layer];
    [bottomGender setFrame:CGRectMake(0.0f, 303.0f, self.bounds.size.width, 1.0f)];
    [bottomGender setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.mainJoinView.layer addSublayer:bottomGender];
    
    self.cameraCapture = [[CameraCaptureV6 alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.cameraCapture.tag=1;
    [self.cameraCapture setIsFullCameraCapture:YES];
    
    UILabel *lblCancelCamera = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 80, self.bounds.size.width / 4, 60)];
    [lblCancelCamera setText:@"CANCEL"];
    [lblCancelCamera setFont:[self.helperIns getFontThin:15.0f]];
    [lblCancelCamera setTextAlignment:NSTextAlignmentCenter];
    [lblCancelCamera setTextColor:[UIColor whiteColor]];
    [lblCancelCamera setUserInteractionEnabled:YES];
    [self.cameraCapture addSubview:lblCancelCamera];
    
    UITapGestureRecognizer *tapCancelCamera = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCancelCamera:)];
    [tapCancelCamera setNumberOfTapsRequired:1];
    [tapCancelCamera setNumberOfTouchesRequired:1];
    [lblCancelCamera addGestureRecognizer:tapCancelCamera];
    
    UILabel *lblTakePhotoCamera = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 4, self.bounds.size.height - 80, self.bounds.size.width / 2, 60)];
    [lblTakePhotoCamera setText:@"TAP TAKE PHOTO"];
    [lblTakePhotoCamera setFont:[self.helperIns getFontThin:15.0f]];
    [lblTakePhotoCamera setTextAlignment:NSTextAlignmentCenter];
    [lblTakePhotoCamera setTextColor:[UIColor whiteColor]];
    [lblTakePhotoCamera setUserInteractionEnabled:YES];
    [self.cameraCapture addSubview:lblTakePhotoCamera];
    
    UITapGestureRecognizer *tapTakePhotoCamera = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTakePhotoCamera:)];
    [tapTakePhotoCamera setNumberOfTapsRequired:1];
    [tapTakePhotoCamera setNumberOfTouchesRequired:1];
    [lblTakePhotoCamera addGestureRecognizer:tapTakePhotoCamera];
    
    UILabel *lblUsePhoto = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width / 4) *3, self.bounds.size.height - 80, self.bounds.size.width / 4, 60)];
    [lblUsePhoto setText:@"USE"];
    [lblUsePhoto setFont:[self.helperIns getFontThin:15.0f]];
    [lblUsePhoto setTextAlignment:NSTextAlignmentCenter];
    [lblUsePhoto setTextColor:[UIColor whiteColor]];
    [lblUsePhoto setUserInteractionEnabled:YES];
    [self.cameraCapture addSubview:lblUsePhoto];
    
    UITapGestureRecognizer *tapUsePhotoCamera = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUsePhoto:)];
    [tapUsePhotoCamera setNumberOfTapsRequired:1];
    [tapUsePhotoCamera setNumberOfTouchesRequired:1];
    [lblUsePhoto addGestureRecognizer:tapUsePhotoCamera];
    
    TriangleView *triangleJoinNow = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 7, 7)];
    [triangleJoinNow setBackgroundColor:[UIColor colorWithRed:117.0/255.0f green:117.0/255.0f blue:117.0/255.0f alpha:1]];
    [triangleJoinNow drawTriangleSignIn];
    
    UIImage *imgJoinNow = [self.helperIns imageWithView:triangleJoinNow];
    
    self.btnJoinNow = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnJoinNow setFrame:CGRectMake(0.0f, 304, self.bounds.size.width, self.bounds.size.height/6)];
    [self.btnJoinNow setTitle:@"JOIN NOW" forState:UIControlStateNormal];
    [self.btnJoinNow setImage:imgJoinNow forState:UIControlStateNormal];
    
    CGSize sizeScreen = {self.bounds.size.width, self.bounds.size.height};
    
    CGSize sizeTitleLable = [self.btnJoinNow.titleLabel.text sizeWithFont:[self.helperIns getFontThin:15.0f] constrainedToSize:sizeScreen lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.btnJoinNow.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnJoinNow setContentMode:UIViewContentModeCenter];
    
    [self.btnJoinNow setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgJoinNow.size.width, 0, imgJoinNow.size.width)];
    self.btnJoinNow.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgJoinNow.size.width, 0, -((sizeTitleLable.width) + imgJoinNow.size.width));
    
    [self.btnJoinNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnJoinNow.titleLabel setFont:[self.helperIns getFontThin:15.0f]];
    UIColor *colorSignInNormal = [self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor"]];
    UIColor *colorSignInHighLight = [self.helperIns colorFromRGBWithAlpha:[self.helperIns getHexIntColorWithKey:@"GreenColor"] withAlpha:0.8f];
    [self.btnJoinNow setBackgroundImage:[self.helperIns imageWithColor:colorSignInNormal] forState:UIControlStateNormal];
    [self.btnJoinNow setBackgroundImage:[self.helperIns imageWithColor:colorSignInHighLight] forState:UIControlStateHighlighted | UIControlStateSelected];
    [self.mainJoinView addSubview:self.btnJoinNow];
    
    //Add back button
    
    TriangleView *triangleBack = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleBack setBackgroundColor:[UIColor colorWithRed:117.0/255.0f green:117.0/255.0f blue:117.0/255.0f alpha:1]];
    [triangleBack drawTriangleSignIn];
    UIImage *imgBack = [self.helperIns imageWithView:triangleBack];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnBack setFrame:CGRectMake(0.0f, 304 + (self.bounds.size.height/6), self.bounds.size.width, self.bounds.size.height/6)];
    [self.btnBack setTitle:@"BACK" forState:UIControlStateNormal];
    [self.btnBack setImage:imgBack forState:UIControlStateNormal];
    
    CGSize sizeTitleLableBack = [self.btnBack.titleLabel.text sizeWithFont:[self.helperIns getFontThin:15.0f] constrainedToSize:sizeScreen lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.btnBack.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnBack setContentMode:UIViewContentModeCenter];
    
    [self.btnBack setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgJoinNow.size.width, 0, imgJoinNow.size.width)];
    self.btnBack.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLableBack.width) + imgJoinNow.size.width, 0, -((sizeTitleLableBack.width) + imgJoinNow.size.width));
    
    [self.btnBack setTitleColor:[UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.btnBack.titleLabel setFont:[self.helperIns getFontThin:15.0f]];
    UIColor *colorBackNormal = [self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"BlueColor"]];
    UIColor *colorBackHighLight = [self.helperIns colorFromRGBWithAlpha:[self.helperIns getHexIntColorWithKey:@"BlueColor"] withAlpha:0.8f];
    [self.btnBack setBackgroundImage:[self.helperIns imageWithColor:colorBackNormal] forState:UIControlStateNormal];
    [self.btnBack setBackgroundImage:[self.helperIns imageWithColor:colorBackHighLight] forState:UIControlStateHighlighted | UIControlStateSelected];
    [self.mainJoinView addSubview:self.btnBack];
    
    UIImageView* imgArrowView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.btnJoinNow.bounds.size.width/2 +30, self.btnJoinNow.bounds.size.height/2-10, 20.0f, 20.0f)];
    imgArrowView1.image = [SVGKImage imageNamed:@"arrow-white.svg"].UIImage;
    [self.btnJoinNow addSubview:imgArrowView1];
}

-(void)setBgColorForButton:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:187/255.0f green:187/255.0f blue:187/255.0f alpha:1.0]];
}

- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd'/'MM'/'yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

- (void)changeAvatarGesture{
    NSString *actionSheetTitle = @"Please Select Action"; //Action Sheet Title
    NSString *destructiveTitle = @"Take From Camera"; //Action Sheet Button Titles
    NSString *other1 = @"Select Image";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:other1, nil];
    
    [actionSheet showInView:self];
//    UIScrollView *parentView = (UIScrollView*)self.superview;
//    [self setFrame:CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height)];
    //    UIScrollView *scroll=[UIScrollView parentView.superview];
//    [parentView setContentSize:CGSizeMake(self.bounds.size.width,self.bounds.size.height)];
//    
//    [self endEditing:YES];
    
//    [self addSubview:self.cameraCapture.view];
    
//    UIButton *btnCancelUpdateAvatar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnCancelUpdateAvatar setAlpha:0.5f];
//    [btnCancelUpdateAvatar setFrame:CGRectMake(0, 0, 200, 40)];
//    [btnCancelUpdateAvatar setBackgroundColor:[UIColor cyanColor]];
//    [btnCancelUpdateAvatar setTitle:@"Cancel" forState:UIControlStateNormal];
//    [btnCancelUpdateAvatar addTarget:self action:@selector(cancelUpdateAvatar) forControlEvents:UIControlEventTouchUpInside];
//    btnCancelUpdateAvatar.tag=2;
//    [self.cameraCapture.view addSubview:btnCancelUpdateAvatar];
}

-(void)scropImage{
//    UIImage *img= [self.cameraCapture scropImage];
//    self.imgAvatar = img;
    self.imgAvatar  = [self.helperIns resizeImage:self.imgAvatar  resizeSize:CGSizeMake(300, 300)];
    [self.btnProfile setImage:self.imgAvatar];
    [self cancelUpdateAvatar];
}

-(void)cancelUpdateAvatar{
    [[self viewWithTag:1] removeFromSuperview];
//    [self.cameraCapture closeImage];
    [self setFrame:CGRectMake(0, self.bounds.size.height - ((self.bounds.size.height / 3) * 2), self.bounds.size.width, self.bounds.size.height)];
    UIScrollView *parentView= (UIScrollView*)self.superview;
    [parentView setContentSize:CGSizeMake(self.bounds.size.width,self.bounds.size.height+ (self.bounds.size.height - ((self.bounds.size.height / 3) * 2)))];
}

-(void)doneClicked:(id) sender{
    
    [self endEditing:YES];
    
}

- (void) keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
//    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect frame = self.frame;
//    CGFloat span1=frame.size.height - kbSize.height;
    
//    [self.mainScroll setFrame:CGRectMake(0, 0, self.bounds.size.width, span1)];
    [self setFrame:frame];
}

- (void) keyboardWillBeHidden:(NSNotification*)aNotification{
    
    CGRect frame = self.frame;
    frame.origin.y =0;
//    [self.mainScroll setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    //    [self setFrame:frame];
}

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
    }
    return nil;
}

- (void)updateDateField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.txtBirthDayJoin.inputView;
    self.txtBirthDayJoin.text = [self formatDate:picker.date];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            UIScrollView *parentView = (UIScrollView*)self.superview;
            [self setFrame:CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height)];
            [parentView setContentSize:CGSizeMake(self.bounds.size.width,self.bounds.size.height)];
            
            [self endEditing:YES];
            [self addSubview:self.cameraCapture];
        }
            break;
            
        case 1:
            
            break;
            
        default:
            break;
    }
}

- (void) tapCancelCamera:(UIGestureRecognizer *)recognizer{
    BOOL isShow = [self.cameraCapture getInShowPhoto];
    if (isShow) {
        [self.cameraCapture closeImage];
    }else{
        [self.cameraCapture removeFromSuperview];
        [self setFrame:CGRectMake(0, self.bounds.size.height - ((self.bounds.size.height / 3) * 2), self.bounds.size.width, self.bounds.size.height)];
        UIScrollView *parentView= (UIScrollView*)self.superview;
        [parentView setContentSize:CGSizeMake(self.bounds.size.width,self.bounds.size.height+ (self.bounds.size.height - ((self.bounds.size.height / 3) * 2)))];        
    }
}

- (void) tapTakePhotoCamera:(UIGestureRecognizer *)recognizer{
    [self.cameraCapture captureImage:nil];
}

- (void) tapUsePhoto:(UIGestureRecognizer *)recognizer{

    self.avatarPreview = [[AvatarPreview alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UIImage *resizeImage = [self.helperIns resizeImage:[self.cameraCapture getImageSend] resizeSize:CGSizeMake(640, 1136)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:resizeImage];
    [self.avatarPreview setImageCycle:imgView];
    
    //[self.cameraCapture removeFromSuperview];
    [self.cameraCapture closeImage];
    
    UIScrollView *parentView = (UIScrollView*)self.superview;
    [self setFrame:CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height)];
    [parentView setContentSize:CGSizeMake(self.bounds.size.width,self.bounds.size.height)];
    
    [self endEditing:YES];
    [self addSubview:self.avatarPreview];
}

- (void) setAvatar:(UIImage *)_imgAvatar withThumbnail:(UIImage *)_imgThumbnail{
    
    self.thumbnail = _imgThumbnail;
    self.avatar = _imgAvatar;
    
    [self.cameraCapture removeFromSuperview];
    
    //set frame scroll
    [self setFrame:CGRectMake(0, self.bounds.size.height - ((self.bounds.size.height / 3) * 2), self.bounds.size.width, self.bounds.size.height)];
    UIScrollView *parentView= (UIScrollView*)self.superview;
    [parentView setContentSize:CGSizeMake(self.bounds.size.width,self.bounds.size.height+ (self.bounds.size.height - ((self.bounds.size.height / 3) * 2)))];
    
    [self.btnProfile setImage:_thumbnail];
    self.btnProfile.layer.cornerRadius = CGRectGetHeight(self.btnProfile.bounds) / 2;
}
@end
