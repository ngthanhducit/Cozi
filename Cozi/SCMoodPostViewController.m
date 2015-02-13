//
//  SCMoodPostViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/15/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCMoodPostViewController.h"

@interface SCMoodPostViewController ()

@end

@implementation SCMoodPostViewController

@synthesize vCaption;
@synthesize vAddFacebook;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupVariable];
    [self setupUI];
}

- (void) setupVariable{
    
    networkControllerIns = [NetworkController shareInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setResultAddWall:) name:@"setResultAddWall" object:nil];
}

- (void) setupUI{
    
    self.vCaption = [[UIView alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, 100)];
    [self.vCaption setBackgroundColor:[UIColor colorWithRed:248.0/255.0f green:248.0/255.0f blue:248.0/255.0f alpha:1]];
    [self.view addSubview:self.vCaption];
    
    imgQuotes = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"icon-QuoteGreenLarge"]];
    [imgQuotes setFrame:CGRectMake(self.view.bounds.size.width / 2 - 15, 15, 30, 30)];
    [self.vCaption addSubview:imgQuotes];
    
    //TextView Chat
    self.txtCaption = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(40, imgQuotes.bounds.size.height + 20, self.view.bounds.size.width - 60, 30)];
    [self.txtCaption setPlaceholder:@"Write a caption..."];
    [self.txtCaption setIsScrollable:YES];
    [self.txtCaption setDelegate:self];
    [self.txtCaption setMinNumberOfLines:1];
    self.txtCaption.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    [self.txtCaption setMaxNumberOfLines:5];
    [self.txtCaption setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.txtCaption setAlpha:0.3];
    [self.txtCaption setFont:[helperIns getFontLight:15.0f]];
    [self.txtCaption setTextColor:[UIColor blackColor]];
    [self.txtCaption setTextAlignment:NSTextAlignmentJustified];
    [self.txtCaption setUserInteractionEnabled:YES];
    [self.txtCaption setBackgroundColor:[UIColor clearColor]];
    [self.vCaption addSubview:self.txtCaption];
    
    [self initAddFB];
    
    self.vButton = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100)];
    [self.vButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.vButton];
    
    CGSize size = { self.view.bounds.size.width, self.view.bounds.size.height };
    TriangleView *triangleJoinNow = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleJoinNow setBackgroundColor:[UIColor whiteColor]];
    [triangleJoinNow drawTriangleSignIn];
    UIImage *imgJoinNow = [helperIns imageWithView:triangleJoinNow];
    
    self.btnPostMood = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnPostMood setFrame:CGRectMake(0, (vCaption.bounds.size.height) - 100, self.view.bounds.size.width, 100)];
    [self.btnPostMood setBackgroundColor:[UIColor blackColor]];
    [self.btnPostMood setImage:imgJoinNow forState:UIControlStateNormal];
    [self.btnPostMood.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnPostMood setContentMode:UIViewContentModeCenter];
    [self.btnPostMood setTitle:@"POST PHOTO" forState:UIControlStateNormal];
    [self.btnPostMood setTitleColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] forState:UIControlStateNormal];
    [self.btnPostMood addTarget:self action:@selector(btnPostMood:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPostMood.titleLabel setFont:[helperIns getFontLight:15.0f]];
    
    CGSize sizeTitleLable = [self.btnPostMood.titleLabel.text sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnPostMood setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgJoinNow.size.width, 0, imgJoinNow.size.width)];
    self.btnPostMood.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgJoinNow.size.width, 0, -((sizeTitleLable.width) + imgJoinNow.size.width));
    
    [self.vButton addSubview:self.self.btnPostMood];
}

- (void) initAddFB{
    self.vAddFacebook = [[UIView alloc] initWithFrame:CGRectMake(0, self.vCaption.bounds.size.height + hHeader + 20, self.view.bounds.size.width, 60)];
    //    [self.vAddFacebook setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [self.vAddFacebook setBackgroundColor:[UIColor grayColor]];
    [self.vAddFacebook setUserInteractionEnabled:YES];
    [self.view addSubview:self.vAddFacebook];
    
    UIImageView *imgLogoFB = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"icon-FBWhite.svg"]];
    [imgLogoFB setFrame:CGRectMake(10, self.vAddFacebook.bounds.size.height / 2 - 15, 30, 30)];
    [self.vAddFacebook addSubview:imgLogoFB];
    
    UILabel *lblTitleFB = [[UILabel alloc] initWithFrame:CGRectMake(50, self.vAddFacebook.bounds.size.height / 2 - 15, self.view.bounds.size.width - 100, 30)];
    [lblTitleFB setText:@"Add to facebook"];
    [lblTitleFB setFont:[helperIns getFontLight:18.0f]];
    [lblTitleFB setTextColor:[UIColor whiteColor]];
    [lblTitleFB setBackgroundColor:[UIColor clearColor]];
    [self.vAddFacebook addSubview:lblTitleFB];
    
    imgSelectFB = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"icon-TickGrey-v3.svg"]];
    [imgSelectFB setFrame:CGRectMake(self.view.bounds.size.width - 50, self.vAddFacebook.bounds.size.height / 2 - 15, 30, 30)];
    [imgSelectFB setHidden:YES];
    [self.vAddFacebook addSubview:imgSelectFB];
    
    UITapGestureRecognizer *tapSelectFB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelectFB)];
    [tapSelectFB setNumberOfTapsRequired:1];
    [tapSelectFB setNumberOfTouchesRequired:1];
    [self.vAddFacebook addGestureRecognizer:tapSelectFB];
}

- (void) tapSelectFB{
    
    if (isSelectFB) {
        [self.vAddFacebook setBackgroundColor:[UIColor grayColor]];
        [imgSelectFB setHidden:YES];
        isSelectFB = NO;
    }else{
        [self.vAddFacebook setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
        [imgSelectFB setHidden:NO];
        isSelectFB = YES;
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    
    float diff = (height - growingTextView.frame.size.height);
    CGFloat hVCaption = self.vCaption.bounds.size.height + diff;
    [self.vCaption setFrame:CGRectMake(0, self.vCaption.frame.origin.y, self.vCaption.bounds.size.width, hVCaption)];
    [self.vCaption setNeedsDisplay];
    [self.vAddFacebook setFrame:CGRectMake(0, self.vCaption.bounds.size.height + hHeader + 20, self.view.bounds.size.width, 60)];
    
    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void) btnPostMood:(id)sender{
    if (![self.txtCaption.text isEqualToString:@""]) {
        NSString *contentEncode = [helperIns encodedBase64:[self.txtCaption.text dataUsingEncoding:NSUTF8StringEncoding]];
        _clientKeyID = [storeIns randomKeyMessenger];
        NSString *tempClientKey = [helperIns encodedBase64:[[NSString stringWithFormat:@"%@", _clientKeyID] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [networkControllerIns addMood:contentEncode withClientKey:tempClientKey withCode:0];
    }
}

- (void) setResultAddWall:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSString *_strResult = (NSString*)[userInfo objectForKey:@"ADDPOST"];
    
    NSArray *subCommand = [_strResult componentsSeparatedByString:@"}"];
    if ([subCommand count] == 2) {
        NSInteger key = [[helperIns decode:[subCommand objectAtIndex:1]] integerValue];
        if (key > 0) {
            
            DataWall *_newWall = [DataWall new];
            _newWall.userPostID = storeIns.user.userID;
            _newWall.content = self.txtCaption.text;
            _newWall.images = [NSMutableArray new];
            _newWall.video = @"";
            _newWall.longitude = @"";
            _newWall.latitude = @"";
//            __weak NSString *strFullName = storeIns.user.nickName;
            _newWall.fullName = [NSString stringWithFormat:@"%@ %@", storeIns.user.firstname, storeIns.user.lastName];
            _newWall.firstName = storeIns.user.firstname;
            _newWall.lastName = storeIns.user.lastName;
            _newWall.time = [subCommand objectAtIndex:0];
//            _newWall.typePost = 0;
            _newWall.codeType = 0;
            _newWall.clientKey = [NSString stringWithFormat:@"%i", (int)_clientKeyID];
            
            [storeIns insertWallData:_newWall];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadWallAndNoises" object:nil];
        }else{
            //Error add post
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.lblTitle setText:@"ADD MOOD"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
