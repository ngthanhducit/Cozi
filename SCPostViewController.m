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
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initVariable];
        [self initNotification];
        [self setup];
    }
    
    return self;
}

- (void) initVariable{
    statusFlash = 0;
    helperIns = [Helper shareInstance];
    hHeader = 40;
    hTool = self.view.bounds.size.height - (self.view.bounds.size.width + hHeader);
}

- (void) initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nsCompleteCapture) name:@"SC_CompleteCaptureCamera" object:nil];
}

- (void) setup{
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.navigationController setNavigationBarHidden:YES];
    
//    self.cameraCapture = [[SCCameraCaptureV7 alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - hHeader)];
//    [self.view addSubview:cameraCapture];
    
    self.vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, hHeader)];
    [self.vHeader setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.vHeader];
    
    UILabel     *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(hHeader, 0, self.view.bounds.size.width - (hHeader * 2), hHeader)];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setText:@"TAKE A SHOT"];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setFont:[helperIns getFontLight:18.0f]];
    [self.vHeader addSubview:lblTitle];
    
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
    CGFloat hButton = 0;
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        hButton = 45;
        //iphone 5
    }
    else
    {
        hButton = 35;
        //iphone 3.5 inch screen iphone 3g,4s
    }
    
    
    self.btnGrid = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnGrid setBackgroundColor:[UIColor blackColor]];
    [self.btnGrid setFrame:CGRectMake((vGrid.bounds.size.width / 2) - (hButton / 2), (vGrid.bounds.size.height / 2) - (hButton / 2), hButton, hButton)];
    [self.btnGrid setClipsToBounds:YES];
    [self.btnGrid setContentMode:UIViewContentModeScaleAspectFill];
    [self.btnGrid setAutoresizingMask:UIViewAutoresizingNone];
    self.btnGrid.layer.cornerRadius = self.btnGrid.bounds.size.height / 2;
    self.btnGrid.layer.borderWidth = 1.0f;
    self.btnGrid.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btnGrid setImage:[helperIns getImageFromSVGName:@"icon-GridWhite.svg"] forState:UIControlStateNormal];
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
    [self.btnSwithCamera setImage:[helperIns getImageFromSVGName:@"icon-CameraWhite.svg"] forState:UIControlStateNormal];
    [self.btnSwithCamera addTarget:self action:@selector(btnSwitchCamera:) forControlEvents:UIControlEventTouchUpInside];
    [vSwithCamera addSubview:self.btnSwithCamera];
    
    UIView *vFlash = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 3) * 2, 0, self.view.bounds.size.width / 3, yLineTool)];
    [vFlash setBackgroundColor:[UIColor clearColor]];
    [vFlash setContentMode:UIViewContentModeCenter];
    [self.vTool addSubview:vFlash];
    
    self.btnFlash = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnFlash setTitle:@"ON" forState:UIControlStateNormal];
    [self.btnFlash setTitle:@"OFF" forState:UIControlStateSelected];
    [self.btnFlash.titleLabel setFont:[helperIns getFontLight:8.0f]];
    [self.btnFlash setBackgroundColor:[UIColor blackColor]];
    [self.btnFlash setFrame:CGRectMake((vFlash.bounds.size.width / 2) - (hButton / 2), (vFlash.bounds.size.height / 2) - (hButton / 2), hButton, hButton)];
    [self.btnFlash setClipsToBounds:YES];
    [self.btnFlash setContentMode:UIViewContentModeScaleAspectFill];
    [self.btnFlash setAutoresizingMask:UIViewAutoresizingNone];
    self.btnFlash.layer.cornerRadius = self.btnGrid.bounds.size.height / 2;
    self.btnFlash.layer.borderWidth = 1.0f;
    self.btnFlash.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btnFlash setImage:[helperIns getImageFromSVGName:@"icon-FlashWhite.svg"] forState:UIControlStateNormal];
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
    
    self.btnTakePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnTakePhoto setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [self.btnTakePhoto setImage:imgJoinNow forState:UIControlStateNormal];
    [self.btnTakePhoto.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnTakePhoto setContentMode:UIViewContentModeCenter];
    [self.btnTakePhoto setFrame:CGRectMake(0, 0, self.view.bounds.size.width, vTakePhoto.bounds.size.height)];
    [self.btnTakePhoto setTitle:@"JOIN NOW" forState:UIControlStateNormal];
    [self.btnTakePhoto addTarget:self action:@selector(btnTakePhotoTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnTakePhoto.titleLabel setFont:[helperIns getFontLight:15.0f]];
    
    CGSize sizeTitleLable = [self.btnTakePhoto.titleLabel.text sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [self.btnTakePhoto setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgJoinNow.size.width, 0, imgJoinNow.size.width)];
    self.btnTakePhoto.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgJoinNow.size.width, 0, -((sizeTitleLable.width) + imgJoinNow.size.width));
    
    [self.btnTakePhoto setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.btnTakePhoto setAlpha:0.8];
    [vTakePhoto addSubview:self.btnTakePhoto];
    
    self.vGridLine = [[SCGridView alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.width)];
    [self.vGridLine setBackgroundColor:[UIColor clearColor]];
    [self.vGridLine setHidden:YES];
    [self.view addSubview:self.vGridLine];
}

- (void) btnCloseClick{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) btnTakePhotoTap:(id)sender{
    [self.cameraCapture captureImage:nil];
}

- (void) nsCompleteCapture{
    UIImage *img = [self.cameraCapture getImageCapture];
//    UIImage *_newImage = [helperIns squareImageWithImage:img scaledToSize:CGSizeMake(self.view.bounds.size.width , self.view.bounds.size.width)];
//    UIImage *_newImage1 = [helperIns cropImage:img withFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
//    UIImage *_newImage2 = [helperIns resizeImage:img resizeSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width)];
    UIImage *_newImage = [helperIns imageByScalingAndCroppingForSize:img withSize:CGSizeMake(self.view.bounds.size.width * [[UIScreen mainScreen] scale], self.view.bounds.size.width * [[UIScreen mainScreen] scale])];
//    NSData *_dataCompress = [helperIns compressionImage:_newImage];
    
    SCPostDetailsViewController *post = [[SCPostDetailsViewController alloc] initWithNibName:nil bundle:nil];
    //set image to post
    [post setImagePost:_newImage];
    
    //call show
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];
    
    [self.cameraCapture closeImage];
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
    
    [self.vGridLine setHidden:!self.vGridLine.isHidden];
}

- (void) btnSwitchCamera:(id)sender{
    if (inSwitchCamera) {
        return;
    }
    
    inSwitchCamera = YES;
    [self.cameraCapture switchCamera:YES];
    inSwitchCamera = NO;
}

- (void) btnChangeFlash:(id)sender{
    if (inChangeFlash) {
        return;
    }
    
    inChangeFlash = YES;
    statusFlash += 1;
    if (statusFlash > 2) {
        statusFlash = 0;
    }
    
    switch (statusFlash) {
        case 0:
            [self.cameraCapture enableFlash:AVCaptureFlashModeOff];
            break;
            
        case 1:
            [self.cameraCapture enableFlash:AVCaptureFlashModeOn];
            break;
            
        case 2:
            [self.cameraCapture enableFlash:AVCaptureFlashModeAuto];
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
