//
//  SCPostDetailsViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/7/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCPostDetailsViewController.h"

@interface SCPostDetailsViewController ()

@end

@implementation SCPostDetailsViewController

@synthesize vHeader;
@synthesize btnClose;
@synthesize imgPost;
@synthesize vCaption;
@synthesize btnPostPhoto;
@synthesize txtCaption;
@synthesize vAddFacebook;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupVariable];
    [self setupUI];
}

- (void) setupVariable{
    hHeader = 40;
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    networkControllerIns = [NetworkController shareInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAmazoneUpload:) name:@"setAmazoneUpload" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setResultUpload:) name:@"setResultUpload" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setResultAddWall:) name:@"setResultAddWall" object:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.lblTitle setText:@"POST TO WALL"];
    [networkControllerIns addListener:self];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [networkControllerIns removeListener:self];
}

- (void) setupUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.imgPost = [[UIImageView alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, (self.view.bounds.size.height / 3))];
    
    [self.imgPost setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgPost setClipsToBounds:YES];
    [self.imgPost setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.imgPost];
    
    self.vCaption = [[SCPhotoDetailsView alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height / 3) + (hHeader - 10), self.view.bounds.size.width, self.view.bounds.size.height - (hHeader + self.imgPost.bounds.size.height) + 10)];
    [self.vCaption setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.vCaption];
    
    imgQuotes = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"icon-QuoteGreenLarge"]];
    [imgQuotes setFrame:CGRectMake(self.view.bounds.size.width / 2 - 15, 15, 25, 25)];
    [self.vCaption addSubview:imgQuotes];
    
    //TextView Chat
    self.txtCaption = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(20, imgQuotes.bounds.size.height + 10, self.view.bounds.size.width - 40, 30)];
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
    
    CGSize size = { self.view.bounds.size.width, self.view.bounds.size.height };
    TriangleView *triangleJoinNow = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleJoinNow setBackgroundColor:[UIColor whiteColor]];
    [triangleJoinNow drawTriangleSignIn];
    UIImage *imgJoinNow = [helperIns imageWithView:triangleJoinNow];
    
    self.btnPostPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnPostPhoto setFrame:CGRectMake(0, (vCaption.bounds.size.height) - 100, self.view.bounds.size.width, 100)];
    [self.btnPostPhoto setBackgroundColor:[UIColor blackColor]];
    [self.btnPostPhoto setImage:imgJoinNow forState:UIControlStateNormal];
    [self.btnPostPhoto.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnPostPhoto setContentMode:UIViewContentModeCenter];
    [self.btnPostPhoto setTitle:@"POST PHOTO" forState:UIControlStateNormal];
    [self.btnPostPhoto setTitleColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]] forState:UIControlStateNormal];
    [self.btnPostPhoto addTarget:self action:@selector(btnPostPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPostPhoto.titleLabel setFont:[helperIns getFontLight:15.0f]];
    
    CGSize sizeTitleLable = [self.btnPostPhoto.titleLabel.text sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnPostPhoto setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgJoinNow.size.width, 0, imgJoinNow.size.width)];
    self.btnPostPhoto.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgJoinNow.size.width, 0, -((sizeTitleLable.width) + imgJoinNow.size.width));
    
    [vCaption addSubview:self.self.btnPostPhoto];
}

- (void) initAddFB{
    self.vAddFacebook = [[UIView alloc] initWithFrame:CGRectMake(0, imgQuotes.bounds.size.height + 30 + self.txtCaption.bounds.size.height, self.view.bounds.size.width, 60)];
    [self.vAddFacebook setBackgroundColor:[UIColor grayColor]];
    [self.vCaption addSubview:self.vAddFacebook];
    
    UIImageView *imgLogoFB = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"icon-FBWhite"]];
    [imgLogoFB setFrame:CGRectMake(10, self.vAddFacebook.bounds.size.height / 2 - 15, 30, 30)];
    [self.vAddFacebook addSubview:imgLogoFB];
    
    UILabel *lblTitleFB = [[UILabel alloc] initWithFrame:CGRectMake(50, self.vAddFacebook.bounds.size.height / 2 - 15, self.view.bounds.size.width - 100, 30)];
    [lblTitleFB setText:@"Add to facebook"];
    [lblTitleFB setFont:[helperIns getFontLight:18.0f]];
    [lblTitleFB setTextColor:[UIColor whiteColor]];
    [lblTitleFB setBackgroundColor:[UIColor clearColor]];
    [self.vAddFacebook addSubview:lblTitleFB];
    
    imgSelectFB = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"icon-TickWhite-V2.svg"]];
    [imgSelectFB setFrame:CGRectMake(self.view.bounds.size.width - 50, self.vAddFacebook.bounds.size.height / 2 - 15, 30, 30)];
    [imgSelectFB setHidden:YES];
    [self.vAddFacebook addSubview:imgSelectFB];
    
    UITapGestureRecognizer *tapSelectFB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelectFB)];
    [tapSelectFB setNumberOfTapsRequired:1];
    [tapSelectFB setNumberOfTouchesRequired:1];
    [self.vAddFacebook addGestureRecognizer:tapSelectFB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setImagePost:(UIImage*)_imagePost{
    [self.imgPost setImage:_imagePost];
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

#pragma -mark keyboardDelegate

- (void) keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"heigth keyboard: %f", kbSize.height);
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{

        [self.vAddFacebook setFrame:CGRectMake(0, self.vCaption.bounds.size.height, self.vAddFacebook.bounds.size.width, self.vAddFacebook.bounds.size.height)];
        [self.btnPostPhoto setFrame:CGRectMake(0, self.vCaption.bounds.size.height, self.btnPostPhoto.bounds.size.width, self.btnPostPhoto.bounds.size.height)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void) keyboardWillBeHidden:(NSNotification*)aNotification{

    NSDictionary *userInfo = [aNotification userInfo];
    CGSize kbSize = [[userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    CGRect frameSendView = self.vCaption.frame;
    frameSendView.origin.y += kbSize.height;
    
    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{

        [self.vAddFacebook setFrame:CGRectMake(0, imgQuotes.bounds.size.height + 30 + self.txtCaption.bounds.size.height, self.view.bounds.size.width, 60)];
        CGFloat temp = self.vCaption.bounds.size.height - 100;
        [self.btnPostPhoto setFrame:CGRectMake(0, temp, self.btnPostPhoto.bounds.size.width, 100)];
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void) keyboarddidBeHidden:(NSNotification *)notification{

}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    
    float diff = (height - growingTextView.frame.size.height);
    CGFloat hVCaption = self.vCaption.bounds.size.height + diff;
    [self.vCaption setFrame:CGRectMake(0, self.vCaption.frame.origin.y - diff, self.vCaption.bounds.size.width, hVCaption)];
    [self.vCaption setNeedsDisplay];
    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{

        
    } completion:^(BOOL finished) {
        
    }];
}

- (void) btnPostPhoto:(id)sender{
    if (self.imgPost.image != nil && ![self.txtCaption.text isEqualToString:@""]) {
        vLoading = [[SCWaitingView alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - hHeader)];
        [self.view addSubview:vLoading];
        
        [networkControllerIns getUploadPostUrl];
    }
}

- (void) setResult:(NSString *)_strResult{
    _strResult = [_strResult stringByReplacingOccurrencesOfString:@"<EOF>" withString:@""];
    
    NSArray *subData = [_strResult componentsSeparatedByString:@"{"];
    if ([subData count] == 2) {
        /* @code: get Url upload amazon */
        if ([[subData objectAtIndex:0] isEqualToString:@"GETUPLOADPOSTURL"]) {
//            NSArray *subCommand = [[subData objectAtIndex:1] componentsSeparatedByString:@"}"];
            DataMap *dm = [DataMap shareInstance];
            
            amazonInfomation = [dm mapAmazonUploadPost:[subData objectAtIndex:1]];
            
            AmazonInfo *thumb = [AmazonInfo new];
            thumb.key = amazonInfomation.keyThumb;
            thumb.policy = amazonInfomation.policyThumb;
            thumb.signature = amazonInfomation.signatureThumb;
            thumb.accessKey = amazonInfomation.accessKeyThumb;
            thumb.url = amazonInfomation.url;
            
            AmazonInfo *full = [AmazonInfo new];
            full.key = amazonInfomation.key;
            full.policy = amazonInfomation.policy;
            full.signature = amazonInfomation.signature;
            full.accessKey = amazonInfomation.accessKey;
            full.url = amazonInfomation.url;
            
            UIImage *imgThumb = [helperIns resizeImage:imgPost.image resizeSize:CGSizeMake(160, 160)];
            UIImage *imgFull = [helperIns resizeImage:imgPost.image resizeSize:CGSizeMake(640, 640)];
            NSData *compressImage = [helperIns compressionImage:imgFull];
            NSData *compressThumb = [helperIns compressionImage:imgThumb];
            
            int code = [self uploadAvatarAmazon:full withImage:compressImage];
            int codeThumb = [self uploadAvatarAmazon:thumb withImage:compressThumb];
            
            [networkControllerIns resultUploadImagePost:code withCodeThumb:codeThumb];
        }

        if ([[subData objectAtIndex:0] isEqualToString:@"RESULTUPLOADPOSTIMAGE"]) {
            
            NSArray *subResult = [[subData objectAtIndex:1] componentsSeparatedByString:@"}"];
            if ([subResult count] == 2) {
                if ([[subResult objectAtIndex:0] intValue] == 0 && [[subResult objectAtIndex:1] intValue] == 0) {
                    //add to wall
                    NSString *contentEncode = [helperIns encodedBase64:[self.txtCaption.text dataUsingEncoding:NSUTF8StringEncoding]];
                    NSString *imageEncode = [helperIns encodedBase64:[amazonInfomation.key dataUsingEncoding:NSUTF8StringEncoding]];
                    _clientKeyID = [storeIns randomKeyMessenger];
                    NSString *imgThumbEncode = [helperIns encodedBase64:[amazonInfomation.keyThumb dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    NSString *tempClientKey = [helperIns encodedBase64:[_clientKeyID dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    [networkControllerIns addPost:contentEncode withImage:imageEncode withImageThumb:imgThumbEncode withVideo:@"" withLocation:@"" withClientKey:tempClientKey withCode:1];
                }else{
                    //Error
                    //Error upload phot try again and up wall
                    [vLoading removeFromSuperview];
                }
            }else{
                //Error
                //Error upload phot try again and up wall
                [vLoading removeFromSuperview];
            }
        }
        
        if ([[subData objectAtIndex:0] isEqualToString:@"ADDPOST"]) {
            
            NSArray *subCommand = [[subData objectAtIndex:1] componentsSeparatedByString:@"}"];
            if ([subCommand count] == 2) {
                NSInteger key = [[helperIns decode:[subCommand objectAtIndex:1]] integerValue];
                if (key > 0) {
                    
                    DataWall *_newWall = [DataWall new];
                    _newWall.userPostID = storeIns.user.userID;
                    _newWall.content = self.txtCaption.text;
                    _newWall.fullName = [NSString stringWithFormat:@"%@ %@", storeIns.user.firstname, storeIns.user.lastName];
                    _newWall.firstName = storeIns.user.firstname;
                    _newWall.lastName = storeIns.user.lastName;
                    _newWall.urlFull = [NSString stringWithFormat:@"%@%@", amazonInfomation.url, amazonInfomation.key];
                    _newWall.urlThumb = [NSString stringWithFormat:@"%@%@", amazonInfomation.url, amazonInfomation.keyThumb];
                    _newWall.urlAvatarThumb = storeIns.user.urlThumbnail;
                    _newWall.urlAvatarFull = storeIns.user.urlAvatar;
                    _newWall.video = @"";
                    _newWall.longitude = @"0";
                    _newWall.latitude = @"0";
                    _newWall.time = [subCommand objectAtIndex:0];
                    _newWall.codeType = 1;
                    _newWall.clientKey = _clientKeyID;
                    _newWall.comments = [NSMutableArray new];
                    _newWall.likes = [NSMutableArray new];
                    
                    [storeIns insertWallData:_newWall];
                    [storeIns insertNoisesData:_newWall];
                    
                    [storeIns.listHistoryPost addObject:_newWall];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadWallAndNoises" object:nil];
                    
                }else{
                    //Error add post
                }
            }
            
            [vLoading removeFromSuperview];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        
    }
}

- (int) uploadAvatarAmazon:(AmazonInfo *)info withImage:(NSData *)imgData{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:info.url]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"***";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // key
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"key\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:info.key] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // content-type
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"content-type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"image/jpeg" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // AWSAccessKeyId
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"AWSAccessKeyId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:info.accessKey] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // acl
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"acl\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"public-read" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // policy
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"policy\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:info.policy] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // signature
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"signature\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:info.signature] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"jpg"];
    //    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"ios.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imgData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    
    //return and test
    NSHTTPURLResponse *response=nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    int code = (int)[response statusCode];
    
    return code;
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
