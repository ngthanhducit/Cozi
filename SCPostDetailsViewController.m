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
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initVariable];
        [self setup];
    }
    
    return self;
}

- (void) initVariable{
    hHeader = 40;
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    networkControllerIns = [NetworkController shareInstance];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAmazoneUpload:) name:@"setAmazoneUpload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setResultUpload:) name:@"setResultUpload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setResultAddWall:) name:@"setResultAddWall" object:nil];
}

- (void) setup{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, hHeader)];
    [self.vHeader setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.vHeader];
    
    UILabel *lblPhotoDetails = [[UILabel alloc] initWithFrame:CGRectMake(hHeader, 0, self.view.bounds.size.width - (hHeader * 2), hHeader)];
    [lblPhotoDetails setText:@"PHOTO DETAILS"];
    [lblPhotoDetails setFont:[helperIns getFontLight:18.0f]];
    [lblPhotoDetails setTextColor:[UIColor whiteColor]];
    [lblPhotoDetails setTextAlignment:NSTextAlignmentCenter];
    [self.vHeader addSubview:lblPhotoDetails];
    
    self.btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnClose setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.btnClose setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.btnClose setFrame:CGRectMake(self.view.bounds.size.width - hHeader, 0, hHeader, hHeader)];
    [self.btnClose setTitle:@"x" forState:UIControlStateNormal];
    [self.btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnClose.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    //    [self.btnClose.titleLabel setFont:[helperIns getFontLight:20.0f]];
    [self.btnClose addTarget:self action:@selector(btnCloseClick) forControlEvents:UIControlEventTouchUpInside];
    [self.vHeader addSubview:self.btnClose];
    
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
//    [self.vAddFacebook setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
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
    
    imgSelectFB = [[UIImageView alloc] initWithImage:[helperIns getImageFromSVGName:@"icon-TickGrey"]];
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

- (void) btnCloseClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    //CGRect frame = self.vCaption.frame;
    
    //CGFloat keyboardPos = self.view.bounds.size.height - kbSize.height;
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        [self.vCaption setFrame:CGRectMake(0, posI, self.vCaption.bounds.size.width, self.vCaption.bounds.size.height)];
//        [self.vAddFacebook setFrame:CGRectMake(0, self.btnPostPhoto.frame.origin.y - (self.vAddFacebook.bounds.size.height), self.vAddFacebook.bounds.size.width, self.vAddFacebook.bounds.size.height)];
        
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
//        [self.vCaption setFrame:CGRectMake(0, (self.view.bounds.size.height / 3) + (hHeader - 10), self.vCaption.bounds.size.width, self.vCaption.bounds.size.height)];
//        [self.vAddFacebook setFrame:CGRectMake(0, imgQuotes.bounds.size.height + 30 + self.txtCaption.bounds.size.height, self.view.bounds.size.width, 60)];
        
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
    NSLog(@"did hidden");
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
        vLoading = [[SCActivityIndicatorView alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - hHeader)];
        [vLoading setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:0.5]];
        [self.view addSubview:vLoading];
        
        [networkControllerIns getUploadPostUrl];
    }
}

- (void) setAmazoneUpload:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    amazonInfomation = (AmazonInfoPost*)[userInfo objectForKey:@"GETUPLOADPOSTURL"];
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

- (void) setResultUpload:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
//    NSNumber *_result = (NSNumber*)[userInfo objectForKey:@"RESULTUPLOADPOSTIMAGE"];
    NSString *_result = (NSString*)[userInfo objectForKey:@"RESULTUPLOADPOSTIMAGE"];
    NSArray *subResult = [_result componentsSeparatedByString:@"}"];
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
            __weak NSString *strFullName = storeIns.user.nickName;
            _newWall.fullName = strFullName;
            _newWall.urlFull = [NSString stringWithFormat:@"%@%@", amazonInfomation.url, amazonInfomation.key];
            _newWall.video = @"";
            _newWall.longitude = @"";
            _newWall.latitude = @"";
            _newWall.time = [subCommand objectAtIndex:0];
            _newWall.typePost = 1;
            _newWall.clientKey = [NSString stringWithFormat:@"%i", (int)_clientKeyID];
            
            [storeIns insertWallData:_newWall];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadWallAndNoises" object:nil];
            
        }else{
            //Error add post
        }
    }
    
    [vLoading removeFromSuperview];
    
    [self dismissViewControllerAnimated:YES completion:^{

    }];
    
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
