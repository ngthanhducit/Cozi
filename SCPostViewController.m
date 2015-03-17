//
//  SCPostViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/6/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCPostViewController.h"

@interface SCPostViewController ()

@end

@implementation SCPostViewController

@synthesize cameraCapture;
@synthesize btnClose;
@synthesize vTool;
@synthesize vHeader;
@synthesize btnGrid;
@synthesize btnSwithCamera;
@synthesize btnFlash;
@synthesize btnTakePhoto;
@synthesize vGridLine;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupVariable];
    [self initNotification];
    [self setupUI];

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.lblTitle setText:@"TAKE A SHOT"];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

//    [self.cameraCapture removeFromSuperview];
//    self.cameraCapture = nil;
}

- (void) setupVariable{
    statusFlash = 0;
    helperIns = [Helper shareInstance];
    hHeader = 40;
    hTool = self.view.bounds.size.height - (self.view.bounds.size.width + hHeader);
}

- (void) initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nsCompleteCapture) name:@"SC_CompleteCaptureCamera" object:nil];
}

- (void) setupUI{
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.navigationController setNavigationBarHidden:YES];

    self.cameraCapture = [[SCCameraCaptureV7 alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - hHeader)];
    [self.view addSubview:cameraCapture];
    
    self.vTool = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - hTool, self.view.bounds.size.width, hTool)];
    [self.vTool setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
//    [self.vTool setAlpha:0.8];
    [self.view addSubview:self.vTool];
    
    yLineTool = (self.vTool.bounds.size.height / 5)  * 2;
    
    CALayer *likeTool = [CALayer layer];
    [likeTool setFrame:CGRectMake(0.0f, yLineTool, self.view.bounds.size.width, 0.5f)];
    [likeTool setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
    [self.vTool.layer addSublayer:likeTool];
    
    UIView  *vGrid = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width / 3, yLineTool)];
    [vGrid setBackgroundColor:[UIColor clearColor]];
    [vGrid setContentMode:UIViewContentModeCenter];
    [self.vTool addSubview:vGrid];
    
//    CGFloat xDelta = (self.view.bounds.size.width / 3) - yLineTool;
//    CGFloat hButton = (yLineTool - (xDelta / 2));
    CGFloat hButton = 40;
//    if ([[UIScreen mainScreen] bounds].size.height == 568)
//    {
//        hButton = 45;
//        //iphone 5
//    }
//    else
//    {
//        hButton = 35;
//        //iphone 3.5 inch screen iphone 3g,4s
//    }
    
    self.btnGrid = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnGrid setBackgroundColor:[UIColor blackColor]];
    [self.btnGrid setFrame:CGRectMake((vGrid.bounds.size.width / 2) - (hButton / 2), (vGrid.bounds.size.height / 2) - (hButton / 2), hButton, hButton)];
    [self.btnGrid setClipsToBounds:YES];
    [self.btnGrid setContentMode:UIViewContentModeScaleAspectFill];
    [self.btnGrid setAutoresizingMask:UIViewAutoresizingNone];
    self.btnGrid.layer.cornerRadius = self.btnGrid.bounds.size.height / 2;
    self.btnGrid.layer.borderWidth = 1.0f;
    self.btnGrid.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btnGrid setImage:[helperIns getImageFromSVGName:@"icon-GridWhite-25px-V4.svg"] forState:UIControlStateNormal];
    [self.btnGrid addTarget:self action:@selector(btnShowHiddenGridTap:) forControlEvents:UIControlEventTouchUpInside];
    [vGrid addSubview:self.btnGrid];

    UIView *vSwithCamera = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 3, 0, self.view.bounds.size.width / 3, yLineTool)];
    [vSwithCamera setBackgroundColor:[UIColor clearColor]];
    [vSwithCamera setContentMode:UIViewContentModeCenter];
    [self.vTool addSubview:vSwithCamera];
    
    self.btnSwithCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSwithCamera setBackgroundColor:[UIColor blackColor]];
    [self.btnSwithCamera setFrame:CGRectMake((vSwithCamera.bounds.size.width / 2) - (hButton / 2), (vSwithCamera.bounds.size.height / 2) - (hButton / 2), hButton, hButton)];
    [self.btnSwithCamera setClipsToBounds:YES];
    [self.btnSwithCamera setContentMode:UIViewContentModeScaleAspectFill];
    [self.btnSwithCamera setAutoresizingMask:UIViewAutoresizingNone];
    self.btnSwithCamera.layer.cornerRadius = self.btnGrid.bounds.size.height / 2;
    self.btnSwithCamera.layer.borderWidth = 1.0f;
    self.btnSwithCamera.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btnSwithCamera setImage:[helperIns getImageFromSVGName:@"icon-CameraWhite-25px.svg"] forState:UIControlStateNormal];
    [self.btnSwithCamera addTarget:self action:@selector(btnSwitchCamera:) forControlEvents:UIControlEventTouchUpInside];
    [vSwithCamera addSubview:self.btnSwithCamera];
    
    UIView *vFlash = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 3) * 2, 0, self.view.bounds.size.width / 3, yLineTool)];
    [vFlash setBackgroundColor:[UIColor clearColor]];
    [vFlash setContentMode:UIViewContentModeCenter];
    [self.vTool addSubview:vFlash];
    
    self.btnFlash = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.btnFlash setTitle:@"ON" forState:UIControlStateNormal];
//    [self.btnFlash setTitle:@"OFF" forState:UIControlStateSelected];
    [self.btnFlash.titleLabel setFont:[helperIns getFontLight:8.0f]];
    [self.btnFlash setBackgroundColor:[UIColor blackColor]];
    [self.btnFlash setFrame:CGRectMake((vFlash.bounds.size.width / 2) - (hButton / 2), (vFlash.bounds.size.height / 2) - (hButton / 2), hButton, hButton)];
    [self.btnFlash setClipsToBounds:YES];
    [self.btnFlash setContentMode:UIViewContentModeScaleAspectFill];
    [self.btnFlash setAutoresizingMask:UIViewAutoresizingNone];
    self.btnFlash.layer.cornerRadius = self.btnGrid.bounds.size.height / 2;
    self.btnFlash.layer.borderWidth = 1.0f;
    self.btnFlash.layer.borderColor = [UIColor whiteColor].CGColor;
//    [self.btnFlash setImage:[helperIns getImageFromSVGName:@"icon-camera-flash-off-25px.svg"] forState:UIControlStateNormal];
    [self.btnFlash addTarget:self action:@selector(btnChangeFlash:) forControlEvents:UIControlEventTouchUpInside];
    [vFlash addSubview:self.btnFlash];
    
    [self centerVerticalWithPading:0 withButton:self.btnFlash];
    
    UIView *vTakePhoto = [[UIView alloc] initWithFrame:CGRectMake(0, yLineTool, self.view.bounds.size.width, (self.vTool.bounds.size.height / 5)  * 3)];
    [vTakePhoto setBackgroundColor:[UIColor clearColor]];
    [vTakePhoto setContentMode:UIViewContentModeCenter];
    [self.vTool addSubview:vTakePhoto];
    
    CGSize size = { self.view.bounds.size.width, self.view.bounds.size.height };
    
    TriangleView *triangleJoinNow = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleJoinNow setBackgroundColor:[UIColor colorWithRed:117.0/255.0f green:117.0/255.0f blue:117.0/255.0f alpha:1]];
    [triangleJoinNow drawTriangleSignIn];
    UIImage *imgJoinNow = [helperIns imageWithView:triangleJoinNow];
    
//    self.btnTakePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.btnTakePhoto setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
//    [self.btnTakePhoto setImage:imgJoinNow forState:UIControlStateNormal];
//    [self.btnTakePhoto.titleLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.btnTakePhoto setContentMode:UIViewContentModeCenter];
//    [self.btnTakePhoto setFrame:CGRectMake(0, 0, self.view.bounds.size.width, vTakePhoto.bounds.size.height)];
//    [self.btnTakePhoto setTitle:@"TAKE A SHOT" forState:UIControlStateNormal];
//    [self.btnTakePhoto addTarget:self action:@selector(btnTakePhotoTap:) forControlEvents:UIControlEventTouchUpInside];
//    [self.btnTakePhoto.titleLabel setFont:[helperIns getFontLight:15.0f]];
//    
//    CGSize sizeTitleLable = [self.btnTakePhoto.titleLabel.text sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
//    [self.btnTakePhoto setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgJoinNow.size.width, 0, imgJoinNow.size.width)];
//    self.btnTakePhoto.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgJoinNow.size.width, 0, -((sizeTitleLable.width) + imgJoinNow.size.width));
//    
//    [self.btnTakePhoto setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//    [self.btnTakePhoto setAlpha:0.8];
//    [vTakePhoto addSubview:self.btnTakePhoto];
    
    UIView *vBorder = [[UIView alloc] initWithFrame:CGRectMake((vTakePhoto.bounds.size.width / 2) - ((vTakePhoto.bounds.size.height / 2) - 10), 10, vTakePhoto.bounds.size.height - 20, vTakePhoto.bounds.size.height - 20)];
    vBorder.clipsToBounds = YES;
    vBorder.layer.borderColor = [helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]].CGColor;
    vBorder.layer.borderWidth = 1.0f;
    [vBorder setBackgroundColor:[UIColor clearColor]];
    vBorder.layer.cornerRadius = vBorder.bounds.size.width / 2;
    vBorder.contentMode = UIViewContentModeScaleAspectFill;
    [vTakePhoto addSubview:vBorder];
    
    self.btnTakePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnTakePhoto setBackgroundColor:[UIColor whiteColor]];
    [self.btnTakePhoto.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnTakePhoto setFrame:CGRectMake((vTakePhoto.bounds.size.width / 2) - ((vTakePhoto.bounds.size.height / 2) - 15), 15, vTakePhoto.bounds.size.height - 30, vTakePhoto.bounds.size.height - 30)];
    self.btnTakePhoto.layer.cornerRadius = self.btnTakePhoto.bounds.size.width / 2;
    self.btnTakePhoto.clipsToBounds = YES;
    self.btnTakePhoto.contentMode = UIViewContentModeScaleAspectFill;
//    [self.btnTakePhoto setTitle:@"TAKE A SHOT" forState:UIControlStateNormal];
    [self.btnTakePhoto addTarget:self action:@selector(btnTakePhotoTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnTakePhoto.titleLabel setFont:[helperIns getFontLight:15.0f]];
    [vTakePhoto addSubview:self.btnTakePhoto];
    
    self.vGridLine = [[SCGridView alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.width)];
    [self.vGridLine setBackgroundColor:[UIColor clearColor]];
    [self.vGridLine setHidden:YES];
    [self.view addSubview:self.vGridLine];
}

//- (void) btnCloseClick{
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//}

- (void) btnTakePhotoTap:(id)sender{
    [storeIns playSoundPress];
    
    if (inCapture) {
        return;
    }
    
    inCapture = YES;
    [self.cameraCapture captureImage:nil];
}

- (void) nsCompleteCapture{
    UIImage *img = [self.cameraCapture getImageCapture];
//    UIImage *_newImage = [helperIns imageByScalingAndCroppingForSize:img withSize:CGSizeMake(self.view.bounds.size.width * [[UIScreen mainScreen] scale], self.view.bounds.size.width * [[UIScreen mainScreen] scale])];
    
//    UIImage *_newImage1 = [helperIns squareImageWithImage:img scaledToSize:CGSizeMake(self.view.bounds.size.width * [[UIScreen mainScreen] scale], self.view.bounds.size.width * [[UIScreen mainScreen] scale])];
    
    UIImage *_newImage = [helperIns cropImage:img withFrame:CGRectMake(0, 0, self.view.bounds.size.width * [[UIScreen mainScreen] scale], self.view.bounds.size.width * [[UIScreen mainScreen] scale])];
    
    SCPostDetailsViewController *post = [[SCPostDetailsViewController alloc] initWithNibName:nil bundle:nil];
    [post showHiddenClose:YES];
    //set image to post
    [post setImagePost:_newImage];
    
    //call show
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];
    
    [self.cameraCapture closeImage];
    
    inCapture = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) centerVerticalWithPading:(float)padding withButton:(UIButton*)_btn{
    CGSize imageSize = _btn.imageView.frame.size;
    CGSize titleSize = _btn.titleLabel.frame.size;
    
    _btn.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + padding),
                                            0.0f,
                                            0.0f,
                                            - titleSize.width);
    
    _btn.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
                                            - (imageSize.width),
                                            - (imageSize.height + padding),
                                            0.0f);
}

- (void) btnShowHiddenGridTap:(id)sender{
    [storeIns playSoundPress];
    
    [self.vGridLine setHidden:!self.vGridLine.isHidden];
}

- (void) btnSwitchCamera:(id)sender{
    [storeIns playSoundPress];
    
    if (inSwitchCamera) {
        return;
    }
    
    inSwitchCamera = YES;
    [self.cameraCapture switchCamera:YES];
    inSwitchCamera = NO;
}

- (void) btnChangeFlash:(id)sender{
    [storeIns playSoundPress];
    
    if (inChangeFlash) {
        return;
    }
    
    inChangeFlash = YES;
    statusFlash += 1;
    if (statusFlash > 2) {
        statusFlash = 0;
    }
    
    switch (statusFlash) {
        case 0:{
            UIImage *imgFlashOff = [helperIns getImageFromSVGName:@"icon-camera-flash-off-25px.svg"];
            [self.btnFlash setImage:imgFlashOff forState:UIControlStateNormal];
            [self.cameraCapture enableFlash:AVCaptureFlashModeOff];
        }
            break;
            
        case 1:{
            UIImage *imgFlashOn = [helperIns getImageFromSVGName:@"icon-camera-flash-on-25px.svg"];
            [self.btnFlash setImage:imgFlashOn forState:UIControlStateNormal];
            [self.cameraCapture enableFlash:AVCaptureFlashModeOn];
        }
            break;
            
        case 2:{
            UIImage *imgFlashAuto = [helperIns getImageFromSVGName:@"icon-camera-flash-auto-25px.svg"];
            [self.btnFlash setImage:imgFlashAuto forState:UIControlStateNormal];
            [self.cameraCapture enableFlash:AVCaptureFlashModeAuto];
        }
            break;
            
        default:
            break;
    }
    
    inChangeFlash = NO;
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
