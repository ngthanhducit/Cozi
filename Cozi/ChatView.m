//
//  ChatView.m
//  VPix
//
//  Created by Nguyen Thanh Duc on 10/28/14.
//  Copyright (c) 2014 khoa ngo. All rights reserved.
//

#import "ChatView.h"
#import "ViewController.h"

@implementation ChatView

@synthesize tbView;
@synthesize messageView;
@synthesize btnPhoto;
@synthesize btnTakePhoto;
@synthesize btnLocation;
@synthesize storeIns;
@synthesize viewSendMessage;
@synthesize viewToolKit;

@synthesize imgViewAvatar;
@synthesize viewInfo;
@synthesize lblFirstName;
@synthesize lblLastName;
@synthesize lblLocationInfo;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

const CGFloat spacingFirstLastName = 3.0f;
const CGFloat marginRightHeader = 10.0f;
const CGSize sizeAvatar = { 30, 30 };
const CGFloat heightTextField = 50.0f;
const CGFloat heightToolkitNormal = 20.0f;
const CGFloat heightToolkitShow = 120.0f;
const CGFloat heightLine = 5.0f;
const CGSize sizeCircle = { 30, 30 };
const CGSize sizeCircleButton = { 35, 35 };
const CGSize sizeButtonSend = { 30, 30 };

#define DEGREES_TO_RADIANS(degrees) ((degrees) / 180)

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
//        [self setBackgroundColor:[UIColor orangeColor]];
    }
    
    return self;
}

- (void) setup{
    self.backgroundColor = [UIColor clearColor];
    
    lastPhotoSelected = -1;
    self.storeIns = [Store shareInstance];
    coziCoreData = [CoziCoreData shareInstance];
    self.helperIns = [Helper shareInstance];
    self.networkIns = [NetworkCommunication shareInstance];
    self.dataMapIns = [DataMap shareInstance];
    
    [self setUserInteractionEnabled:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarddidBeHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesInTableView) name:@"touchTableView" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchEndTableView) name:@"touchEndTableView" object:nil];
    
    //endDeceleration
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchEndTableView) name:@"endDeceleration" object:nil];
    
    self.tbView = [[SCMessageTableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
    [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.bounds.size.width, self.bounds.size.height - [self getHeaderHeight] - heightTextField - heightToolkitNormal)];
    [self.tbView setScMessageTableViewDelegate:self];
    [self.tbView setContentOffset:CGPointMake(20, 0) animated:NO];
    
    [self addSubview:self.tbView];
    
    
    self.viewSendMessage = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - heightTextField, self.bounds.size.width, heightTextField)];
    [self.viewSendMessage setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.viewSendMessage];
    
    UISwipeGestureRecognizer *recognizerUpSendMessage = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    [recognizerUpSendMessage setDelegate:self];
    [recognizerUpSendMessage setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.viewSendMessage addGestureRecognizer:recognizerUpSendMessage];
    
    UISwipeGestureRecognizer *recognizerDownSendMessage = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    [recognizerDownSendMessage setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.messageView addGestureRecognizer:recognizerDownSendMessage];
    
    //TextView Chat
    self.hpTextChat = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - heightTextField, heightTextField)];
    [self.hpTextChat setPlaceholder:@"Type a message here"];
    [self.hpTextChat setIsScrollable:YES];
    [self.hpTextChat setDelegate:self];
    [self.hpTextChat setMinNumberOfLines:1];
    self.hpTextChat.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.hpTextChat.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    [self.hpTextChat setMaxNumberOfLines:3];
    [self.hpTextChat setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.hpTextChat setAlpha:0.3];
    [self.hpTextChat setFont:[self.helperIns getFontLight:20.0f]];
    [self.hpTextChat setTextColor:[UIColor blackColor]];
    [self.hpTextChat setTextAlignment:NSTextAlignmentJustified];
    [self.hpTextChat setUserInteractionEnabled:YES];
    [self.hpTextChat addGestureRecognizer:recognizerUpSendMessage];
    [self.hpTextChat addGestureRecognizer:recognizerDownSendMessage];
    [self.hpTextChat setBackgroundColor:[UIColor clearColor]];
    [self.viewSendMessage addSubview:self.hpTextChat];
    
    //Button Send
    UIImage *imgSendMessage = [SVGKImage imageNamed:@"icon-chat-sendMessage.svg"].UIImage;
    self.btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSend setFrame:CGRectMake(self.bounds.size.width - heightTextField, 0, heightTextField, heightTextField)];
    [self.btnSend setBackgroundColor:[UIColor clearColor]];
    [self.btnSend setImage:imgSendMessage forState:UIControlStateNormal];
    [self.btnSend setContentMode:UIViewContentModeCenter];
    [self.btnSend setBackgroundColor:[UIColor clearColor]];
    [self.btnSend addTarget:self action:@selector(btnSendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.viewSendMessage addSubview:self.btnSend];

    //add view toolkit
    self.messageView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - (heightTextField + heightToolkitNormal), self.bounds.size.width, heightToolkitNormal)];
    [self.messageView setBackgroundColor:[UIColor clearColor]];
    
    UISwipeGestureRecognizer *recognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    [recognizerUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.messageView addGestureRecognizer:recognizerUp];
    
    UISwipeGestureRecognizer *recognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    [recognizerDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.messageView addGestureRecognizer:recognizerDown];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, self.bounds.size.width, heightLine)];
//    [lineView setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor"]]];
    [lineView setBackgroundColor:[UIColor blackColor]];
    [self.messageView addSubview:lineView];
    
    UIView *roundCircle = [[UIView alloc] initWithFrame:CGRectMake(self.messageView.center.x - (sizeCircle.height / 2), 0, sizeCircle.width, sizeCircle.height)];
    [roundCircle setBackgroundColor:[UIColor clearColor]];
    CAShapeLayer *shapeView = [[CAShapeLayer alloc] init];
    [shapeView setPath:[self createArcPath].CGPath];
//    [shapeView setFillColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor"]].CGColor];
//    [shapeView setStrokeColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor"]].CGColor];
    [shapeView setFillColor:[UIColor blackColor].CGColor];
    [shapeView setStrokeColor:[UIColor blackColor].CGColor];
    [roundCircle.layer addSublayer: shapeView];
    [self.messageView addSubview:roundCircle];
    
    upTrian = [[TriangleView alloc] initWithFrame:CGRectMake(10, 5 , 10, 10)];
    [upTrian setBackgroundColor:[UIColor whiteColor]];
    [upTrian drawTriangleToolKit];
    [roundCircle addSubview:upTrian];
    
    downTrian = [[TriangleView alloc] initWithFrame:CGRectMake(10, 2, 8, 8)];
    [downTrian setBackgroundColor:[UIColor whiteColor]];
    [downTrian drawTrianDownToolkit];
    //    [roundCircle addSubview:downTrian];
    
    self.viewToolKit = [[UIView alloc] initWithFrame:CGRectMake(0, heightToolkitNormal, self.bounds.size.width, 0)];
    [self.viewToolKit setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7f]];
    [self.viewToolKit setClipsToBounds:YES];
    [self.messageView addSubview:self.viewToolKit];
    
    CGSize sizeButtonToolkit = { self.bounds.size.width / 3, 100 };
    
    UIView *viewTakePhoto = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeButtonToolkit.width, sizeButtonToolkit.height)];
    [viewTakePhoto setBackgroundColor:[UIColor clearColor]];
    [self.viewToolKit addSubview:viewTakePhoto];
    
    UIView *viewPhotoLibrary = [[UIView alloc] initWithFrame:CGRectMake(sizeButtonToolkit.width, 0, sizeButtonToolkit.width, sizeButtonToolkit.height)];
    [viewPhotoLibrary setBackgroundColor:[UIColor clearColor]];
    [self.viewToolKit addSubview:viewPhotoLibrary];
    
    UIView *viewSendLocation = [[UIView alloc] initWithFrame:CGRectMake(sizeButtonToolkit.width * 2, 0, sizeButtonToolkit.width, sizeButtonToolkit.height)];
    [viewSendLocation setBackgroundColor:[UIColor clearColor]];
    [self.viewToolKit addSubview:viewSendLocation];
    
    CGFloat topMargin = (sizeButtonToolkit.height - (sizeCircleButton.height + 20)) / 2;
    //icon-chat-imageLibrary
    UIImage *imgTakePhoto = [SVGKImage imageNamed:@"icon-chat-imageLibrary.svg"].UIImage;
    
    self.btnTakePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnTakePhoto setFrame:CGRectMake((sizeButtonToolkit.width / 2) - (sizeCircleButton.width / 2), topMargin, sizeCircleButton.width, sizeCircleButton.height)];
    [self.btnTakePhoto setAutoresizesSubviews:YES];
//    [self.btnTakePhoto setBackgroundColor:[self.helperIns colorWithHex:0xff5856]];
    [self.btnTakePhoto setBackgroundColor:[UIColor whiteColor]];
    [self.btnTakePhoto setImage:imgTakePhoto forState:UIControlStateNormal];
    self.btnTakePhoto.layer.cornerRadius = self.btnTakePhoto.bounds.size.width / 2;
    [self.btnTakePhoto addTarget:self action:@selector(btnTakePhotoTap) forControlEvents:UIControlEventTouchUpInside];
    [viewTakePhoto addSubview:self.btnTakePhoto];
    
    UILabel *lblTakePhoto = [[UILabel alloc] initWithFrame:CGRectMake(0, topMargin + sizeCircleButton.height, sizeButtonToolkit.width, 20)];
    [lblTakePhoto setText:@"TAKE PHOTO"];
    [lblTakePhoto setTextAlignment:NSTextAlignmentCenter];
    [lblTakePhoto setTextColor:[UIColor whiteColor]];
    [lblTakePhoto setFont:[self.helperIns getFontLight:10]];
    [viewTakePhoto addSubview:lblTakePhoto];
    
    UIImage *imgPhoto = [SVGKImage imageNamed:@"icon-chat-sendPicture.svg"].UIImage;
    
    self.btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnPhoto setFrame:CGRectMake((sizeButtonToolkit.width / 2) - (sizeCircleButton.width / 2), topMargin, sizeCircleButton.width, sizeCircleButton.height)];
    [self.btnPhoto setAutoresizesSubviews:YES];
    [self.btnPhoto setImage:imgPhoto forState:UIControlStateNormal];
//    [self.btnPhoto setBackgroundColor:[self.helperIns colorWithHex:0x76c062]];
    [self.btnPhoto setBackgroundColor:[UIColor whiteColor]];
    self.btnPhoto.layer.cornerRadius = self.btnPhoto.bounds.size.width / 2;
    [self.btnPhoto addTarget:self action:@selector(btnPhotoLibraryTap) forControlEvents:UIControlEventTouchUpInside];
    [viewPhotoLibrary addSubview:self.btnPhoto];

    UILabel *lblPhotoLibrary = [[UILabel alloc] initWithFrame:CGRectMake(0, topMargin + sizeCircleButton.height, sizeButtonToolkit.width, 20)];
    [lblPhotoLibrary setText:@"PHOTO LIBRARY"];
    [lblPhotoLibrary setTextColor:[UIColor whiteColor]];
    [lblPhotoLibrary setTextAlignment:NSTextAlignmentCenter];
    [lblPhotoLibrary setFont:[self.helperIns getFontLight:10]];
    [viewPhotoLibrary addSubview:lblPhotoLibrary];
    
    UIImage *imgLocation = [SVGKImage imageNamed:@"icon-chat-sendLocation.svg"].UIImage;
    
    self.btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnLocation setFrame:CGRectMake((sizeButtonToolkit.width / 2) - (sizeCircleButton.width / 2), topMargin, sizeCircleButton.width, sizeCircleButton.height)];
    [self.btnLocation setAutoresizesSubviews:YES];
    [self.btnLocation setImage:imgLocation forState:UIControlStateNormal];
//    [self.btnLocation setBackgroundColor:[self.helperIns colorWithHex:0xff7c00]];
    [self.btnLocation setBackgroundColor:[UIColor whiteColor]];
    self.btnLocation.layer.cornerRadius = self.btnLocation.bounds.size.width / 2;
    [self.btnLocation addTarget:self action:@selector(btnSendLocationTap) forControlEvents:UIControlEventTouchUpInside];
    [viewSendLocation addSubview:self.btnLocation];
    
    UILabel *lblSendLocation = [[UILabel alloc] initWithFrame:CGRectMake(0, topMargin + sizeCircleButton.height, sizeButtonToolkit.width, 20)];
    [lblSendLocation setText:@"SEND LOCATION"];
    [lblSendLocation setTextColor:[UIColor whiteColor]];
    [lblSendLocation setTextAlignment:NSTextAlignmentCenter];
    [lblSendLocation setFont:[self.helperIns getFontLight:10]];
    [viewSendLocation addSubview:lblSendLocation];
    
    [self addSubview:self.messageView];
    
    viewLibrary = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 0)];
    [viewLibrary setBackgroundColor:[UIColor whiteColor]];
    [viewLibrary setContentMode:UIViewContentModeCenter];
    [viewLibrary setClipsToBounds:YES];
    [self addSubview:viewLibrary];
    
    toolkitCamera = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 80, self.bounds.size.width, 60)];
    [toolkitCamera setBackgroundColor:[UIColor clearColor]];
    [toolkitCamera setHidden:YES];
//    [self addSubview:toolkitCamera];
    
    lblCancelSend = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 80, self.bounds.size.width / 4, 60)];
    [lblCancelSend setText:@"CANCEL"];
    [lblCancelSend setTextAlignment:NSTextAlignmentCenter];
    [lblCancelSend setTextColor:[UIColor whiteColor]];
    [lblCancelSend setFont:[self.helperIns getFontThin:20.0f]];
    [lblCancelSend setHidden:YES];
    [lblCancelSend setUserInteractionEnabled:YES];
    [self addSubview:lblCancelSend];
    
    lblTapTakePhoto = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - (self.bounds.size.width / 4), self.bounds.size.height - 80, self.bounds.size.width / 2, 60)];
    [lblTapTakePhoto setText:@"TAP TO SHOT"];
    [lblTapTakePhoto setTextAlignment:NSTextAlignmentCenter];
    [lblTapTakePhoto setTextColor:[UIColor whiteColor]];
    [lblTapTakePhoto setFont:[self.helperIns getFontThin:20.0f]];
    [lblTapTakePhoto setHidden:YES];
    [lblTapTakePhoto setUserInteractionEnabled:YES];
    [self addSubview:lblTapTakePhoto];
    
    lblSendPhoto = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width / 4) * 3, self.bounds.size.height - 80, self.bounds.size.width / 4, 60)];
    [lblSendPhoto setText:@"SEND"];
    [lblSendPhoto setTextAlignment:NSTextAlignmentCenter];
    [lblSendPhoto setTextColor:[UIColor whiteColor]];
    [lblSendPhoto setFont:[self.helperIns getFontThin:20.0f]];
    [lblSendPhoto setHidden:YES];
    [lblSendPhoto setUserInteractionEnabled:YES];
    [self addSubview:lblSendPhoto];
    
    lblChangeCamera = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width / 4) * 3, self.bounds.size.height - 80, self.bounds.size.width / 4, 60)];
    [lblChangeCamera setText:@"SWITCH"];
    [lblChangeCamera setTextAlignment:NSTextAlignmentCenter];
    [lblChangeCamera setTextColor:[UIColor whiteColor]];
    [lblChangeCamera setFont:[self.helperIns getFontThin:20.0f]];
    [lblChangeCamera setHidden:YES];
    [lblChangeCamera setUserInteractionEnabled:YES];
    [self addSubview:lblChangeCamera];
    
    UITapGestureRecognizer *tapTakePhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCameraTakePhoto:)];
    [tapTakePhoto setNumberOfTapsRequired:1];
    [tapTakePhoto setNumberOfTouchesRequired:1];
    [lblTapTakePhoto addGestureRecognizer:tapTakePhoto];
    
    UITapGestureRecognizer *tapSendPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSendPhoto:)];
    [tapSendPhoto setNumberOfTapsRequired:1];
    [tapSendPhoto setNumberOfTouchesRequired:1];
    [lblSendPhoto addGestureRecognizer:tapSendPhoto];
    
    UITapGestureRecognizer *tapCancelSendPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCancelSendPhoto:)];
    [tapCancelSendPhoto setNumberOfTapsRequired:1];
    [tapCancelSendPhoto setNumberOfTouchesRequired:1];
    [lblCancelSend addGestureRecognizer:tapCancelSendPhoto];
    
    UITapGestureRecognizer *tapChangeCamera = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChangeCamera:)];
    [tapChangeCamera setNumberOfTapsRequired:1];
    [tapChangeCamera setNumberOfTouchesRequired:1];
    [lblChangeCamera addGestureRecognizer:tapChangeCamera];
    
    //icon-chat-imageLibrary
    UIImage *imgCameraCapture = [SVGKImage imageNamed:@"icon-chat-imageLibrary.svg"].UIImage;
    btnCameraCapture = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCameraCapture setFrame:CGRectMake((self.bounds.size.width / 2) - 30, 0, 60, 60)];
    [btnCameraCapture setAutoresizesSubviews:YES];
    [btnCameraCapture setBackgroundColor:[self.helperIns colorWithHex:0xff5856]];
    [btnCameraCapture setImage:imgCameraCapture forState:UIControlStateNormal];
    btnCameraCapture.layer.cornerRadius = btnCameraCapture.bounds.size.width / 2;
    [btnCameraCapture addTarget:self action:@selector(btnCaptureImage:) forControlEvents:UIControlEventTouchUpInside];
    [toolkitCamera addSubview:btnCameraCapture];
    
//    cameraPreview = [[CameraCaptureV6 alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
    
    UITapGestureRecognizer *tapLogo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCameraTakePhoto:)];
    [tapLogo setNumberOfTapsRequired:1];
    [tapLogo setNumberOfTouchesRequired:1];
    [cameraPreview addGestureRecognizer:tapLogo];
    
    UISwipeGestureRecognizer *recognizerUpAssets = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpAssets:)];
    [recognizerUpAssets setDirection:UISwipeGestureRecognizerDirectionUp];
    
    [cameraPreview addGestureRecognizer:recognizerUpAssets];
    
    UISwipeGestureRecognizer *recognizerDownAssets = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownAssets:)];
    [recognizerDownAssets setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [cameraPreview addGestureRecognizer:recognizerDownAssets];
}

- (void) initLibraryImage{
    
    if (scrollImageLibrary == nil) {
        
        NSMutableArray *assets = [self.storeIns getAssetsThumbnail];
        
        scrollImageLibrary = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 250)];
        [viewLibrary addSubview:scrollImageLibrary];
        
        [scrollImageLibrary setBackgroundColor:[UIColor clearColor]];
        [scrollImageLibrary setShowsHorizontalScrollIndicator:YES];
        [scrollImageLibrary setShowsVerticalScrollIndicator:YES];
        CGFloat widthContent = [[self.storeIns getAssetsThumbnail] count] * 202;
        [scrollImageLibrary setContentSize:CGSizeMake(widthContent, viewLibrary.bounds.size.height)];
        
        int count = (int)[[self.storeIns getAssetsThumbnail] count];
        
        for (int i = 0; i < count; i++) {
            
            UIImage *img = [assets objectAtIndex:i];
            
            UIView *viewImage = [[UIView alloc] initWithFrame:CGRectMake(i * 202, 0, 200, 200)];
            [viewImage setContentMode:UIViewContentModeCenter];
            [viewImage setAutoresizingMask:UIViewAutoresizingNone];
            [viewImage setTag:i + 300];
            [viewImage setClipsToBounds:YES];
            
            UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
            [imgView setFrame:CGRectMake(0, 0, 200, 200)];
            [imgView setUserInteractionEnabled:YES];
            [imgView setContentMode:UIViewContentModeScaleAspectFill];
            [imgView setAutoresizingMask:UIViewAutoresizingNone];
            [imgView setClipsToBounds:YES];
            [imgView setTag:i];
            
            UIView *_layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
            [_layerView setHidden:YES];
            [_layerView setTag:i + 500];
            [_layerView setAlpha:0.4];
            [_layerView setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor"]]];
            [viewImage addSubview:_layerView];
            
            UITapGestureRecognizer *tapLayer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLayerView:)];
            [tapLayer setNumberOfTapsRequired:1];
            [tapLayer setNumberOfTouchesRequired:1];
            [_layerView addGestureRecognizer:tapLayer];
            
            UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            [tapImage setNumberOfTapsRequired:1];
            [tapImage setNumberOfTouchesRequired:1];
            [imgView addGestureRecognizer:tapImage];
            
            [viewImage addSubview:imgView];
            
            UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnSend setFrame:CGRectMake(75, 75, 50, 50)];
            [btnSend setTitle:@"Send" forState:UIControlStateNormal];
            [btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnSend setBackgroundColor:[UIColor whiteColor]];
            btnSend.layer.cornerRadius = btnSend.bounds.size.width / 2;
            [btnSend setAlpha:0.0f];
            [btnSend.titleLabel setFont:[self.helperIns getFontThin:15]];
            [btnSend setTag:i + 100];
            [viewImage addSubview:btnSend];
            
            [scrollImageLibrary addSubview:viewImage];
        }
        
        btnShowLibrary = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnShowLibrary setFrame:CGRectMake(20, self.bounds.size.height - 70, 50, 50)];
        [btnShowLibrary setBackgroundColor:[UIColor orangeColor]];
        [btnShowLibrary setTitle:@"Show" forState:UIControlStateNormal];
        [btnShowLibrary addTarget:self action:@selector(showImageLibrary:) forControlEvents:UIControlEventTouchUpInside];
        [btnShowLibrary setHidden:YES];
        [self addSubview:btnShowLibrary];
        
        [self bringSubviewToFront:btnShowLibrary];
    }
}

- (void) showImageLibrary:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowListImage" object:nil];
    
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (void) btnCaptureImage:(UIButton*)sender{
    [cameraPreview captureImage:nil];
}

- (void) tapLayerView:(UITapGestureRecognizer *)recognizer{
    UIView *_layerView = (UIView*)[recognizer view];
    int row = (int)_layerView.tag - 500;
    if (lastPhotoSelected == row) {
        UIView *mainView = (UIView*)[[recognizer view] superview];
        
        UIButton *btnSend = (UIButton*)[mainView viewWithTag:row + 100];
        UIImageView *imgView = (UIImageView*)[mainView viewWithTag:row];
        [_layerView setHidden:YES];
        
        imgView.image = lastImageSelected;
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             
                             [btnSend setAlpha:0.0f];
                             
                             imgView.transform=CGAffineTransformMakeScale(1.0, 1.0);
                         }
                         completion:^(BOOL finished){
                             
                         }];
        
        lastPhotoSelected = -1;
    }
}

- (void) autoScrollTbView{
    
    [self.tbView reloadTableView];
}

- (void) tapImage:(UITapGestureRecognizer *)recognizer{
    UIImageView *imgView = (UIImageView*)[recognizer view];
    int row = (int)imgView.tag;
    
    if (lastPhotoSelected == row) {
        UIView *mainView = (UIView*)[[recognizer view] superview];
        
        UIButton *btnSend = (UIButton*)[mainView viewWithTag:row + 100];
        UIView *_layerView = [mainView viewWithTag:row + 100];
        [_layerView setHidden:YES];
        
        imgView.image = lastImageSelected;
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             
                             [btnSend setAlpha:0.0f];
                             
                             imgView.transform=CGAffineTransformMakeScale(1.0, 1.0);
                         }
                         completion:^(BOOL finished){
                             
                         }];
        
        lastPhotoSelected = -1;
    }else{
        
        //Reset Last Select row
        UIView *lastView = (UIView*)[[[[recognizer view] superview] superview] viewWithTag:lastPhotoSelected + 300];
        UIImageView *lastImage = (UIImageView*)[lastView viewWithTag:lastPhotoSelected];
        if (lastImage != nil) {
            lastImage.image = lastImageSelected;
        }
        UIButton *btnSendLast = (UIButton*)[lastView viewWithTag:lastPhotoSelected + 100];
        UIView *lastLayer = [lastView viewWithTag:lastPhotoSelected + 500];
        [lastLayer setHidden:YES];
        
        UIView *mainView = (UIView*)[[recognizer view] superview];
        
        UIButton *btnSend = (UIButton*)[mainView viewWithTag:row + 100];
        [btnSend addTarget:self action:@selector(btnSendImage:) forControlEvents:UIControlEventTouchUpInside];

        lastImageSelected = imgView.image;
        UIImage *imgBlur = [self blurWithImageEffectsRestore:[self.helperIns takeSnapshotOfView:imgView.viewForBaselineLayout] withRadius:5.0f];
        imgView.image = imgBlur;
        
        UIView *_layerView = [mainView
                              viewWithTag:row + 500];
        [_layerView setHidden:NO];
        [mainView bringSubviewToFront:_layerView];
        [mainView bringSubviewToFront:btnSend];
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             
                             //reset button
                             if (btnSendLast != nil) {
                                 [btnSendLast setAlpha:0.0f];
//                                 [btnEditLast setAlpha:0.0f];
                             }
                             lastImage.transform=CGAffineTransformMakeScale(1.0, 1.0);
                             
                             [btnSend setAlpha:1.0f];
//                             [btnEdit setAlpha:1.0f];
                             
                             imgView.transform=CGAffineTransformMakeScale(1.5, 1.5);
                         }
                         completion:^(BOOL finished){
                             
                         }];
        
        lastPhotoSelected = row;
    }
}

- (void) btnSendImage:(UIButton*)sender{
    int tagNumber = (int)sender.tag - 100;

    NSURL *assetURL = (NSURL*)[[self.storeIns getAssetsLibrary] objectAtIndex:tagNumber];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        
        CGImageRef imgRef = [representation fullScreenImage];
        
        UIImage *img = [UIImage imageWithCGImage:imgRef];
        
        [self sendPhoto:img];
        
        imgRef = nil;
    } failureBlock:^(NSError *error) {
        
    }];
}

- (UIImage *)blurWithImageEffectsRestore:(UIImage *)image withRadius:(CGFloat)_radius{
    
    return [image applyBlurWithRadius:_radius tintColor:nil saturationDeltaFactor:1.0 maskImage:nil];
    
}

- (UIImage *)blurWithCoreImage:(UIImage *)sourceImage{
    
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    // Apply Affine-Clamp filter to stretch the image so that it does not look shrunken when gaussian blur is applied
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:inputImage forKey:@"inputImage"];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    // Apply gaussian blur filter with radius of 30
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:clampFilter.outputImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:@50.0 forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[inputImage extent]];
    
    // Set up output context.
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.frame.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, self.frame, cgImage);
    
    // Apply white tint
    CGContextSaveGState(outputContext);
    CGContextSetFillColorWithColor(outputContext, [UIColor colorWithWhite:1 alpha:0.2].CGColor);
    CGContextFillRect(outputContext, self.frame);
    CGContextRestoreGState(outputContext);
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (void) btnTakePhotoTap{
    [scrollImageLibrary removeFromSuperview];
    [viewLibrary addSubview:cameraPreview];
    
    [toolkitCamera setHidden:NO];
    [toolkitCamera bringSubviewToFront:self];
    
    [lblTapTakePhoto setHidden:NO];
    [lblChangeCamera setHidden:NO];
    [btnShowLibrary setHidden:YES];
    
    [self showLibrary];
}

- (void) btnSendLocationTap{
    [self.storeIns updateLocation];
    
    NSInteger _keyMessage = [self.storeIns incrementKeyMessage:self.friendIns.friendID];
    
    NSString *_long = [self.storeIns getLongitude];
    NSString *_lati = [self.storeIns getlatitude];
    
    NSString *cmd = [self.dataMapIns sendLocation:self.friendIns.friendID withLong:[self.storeIns getLongitude] withLati:[self.storeIns getlatitude] withKeyMessage:_keyMessage withTimeOut:0];
    
    Messenger *newMessage = [[Messenger alloc] init];
    [newMessage setTypeMessage:2];
    [newMessage setStatusMessage:0];
    [newMessage setTimeMessage:[self.helperIns getDateFormatMessage:[NSDate date]]];
    [newMessage setFriendID:self.friendIns.friendID];
    [newMessage setDataImage:nil];
    [newMessage setThumnail:nil];
    [newMessage setLongitude:_long];
    [newMessage setLatitude:_lati];
    [newMessage setKeySendMessage:_keyMessage];
    [newMessage setUserID:self.storeIns.user.userID];
    
    [self.networkIns sendData:cmd];
    
    [self.friendIns.friendMessage addObject:newMessage];
    
    [self autoScrollTbView];
    
    [self.tbView reloadData];
    
    ReceiveLocation *_receiveLoca = [[ReceiveLocation alloc] init];
    _receiveLoca.senderID = 0;
    _receiveLoca.friendID = self.friendIns.friendID;
    _receiveLoca.keySendMessage = _keyMessage;
    _receiveLoca.longitude = _long;
    _receiveLoca.latitude = _lati;
    
    [self.storeIns.receiveLocation addObject:_receiveLoca];
    [self.storeIns processReceiveLocation];
}

- (void) btnPhotoLibraryTap{
    [scrollImageLibrary bringSubviewToFront:self];
    [cameraPreview removeFromSuperview];
    
    [toolkitCamera setHidden:YES];
    [lblTapTakePhoto setHidden:YES];
    [lblChangeCamera setHidden:YES];
    
    [btnShowLibrary setHidden:NO];
    
    [viewLibrary addSubview:scrollImageLibrary];
    
    [self showLibrary];
}

- (void) showLibrary{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self endEditing:YES];
        [viewLibrary setFrame:CGRectMake(0, self.bounds.size.height - 200, self.bounds.size.width, 200)];
        [scrollImageLibrary setFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
        [self.messageView setFrame:CGRectMake(0, self.bounds.size.height - 320, self.bounds.size.width, 120)];
        [self.viewToolKit setFrame:CGRectMake(0, 20, self.bounds.size.width, 100)];
        
        [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.bounds.size.width, self.bounds.size.height - [self getHeaderHeight] - viewLibrary.bounds.size.height)];
        
        [self scrollToBottom];
        
    } completion:^(BOOL finished) {
        isShowPanel = YES;
        
    }];
}

- (void) initFriendInfo:(Friend *)_myFriend{
    
    [self.viewInfo removeFromSuperview];
    
    self.viewInfo = [[UIView alloc] init];
    
    [self.viewInfo setBackgroundColor:[UIColor clearColor]];
    
    [self._headPanel addSubview:self.viewInfo];
    
    CGSize textSize = { 260.0, 10000.0 };
    
    NSArray *subNickName = nil;
    if (![_myFriend.nickName isEqualToString:@""]) {
        subNickName = [_myFriend.nickName componentsSeparatedByString:@" "];
    }

//    UILabel *lbl = ((ViewController*)[self superview]).lblNickName;

//    UILabel *lblFirstName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, [self getHeaderHeight])];
//    [lblFirstName setText:@"HELEN BROOK"];
//    [lblFirstName setTextColor:[UIColor blackColor]];
//    [lblFirstName setTextAlignment:NSTextAlignmentCenter];
//    [lblFirstName setFont:[self.helperIns getFontLight:15]];
//    [self.viewInfo addSubview:lblFirstName];
    
//    UIImage *imgAvatar = _myFriend.thumbnail;
//    if (imgAvatar == nil) {
//        if ([[_myFriend.gender uppercaseString] isEqualToString:@"MALE"]) {
//            imgAvatar = [self.helperIns getImageFromSVGName:@"icon-contact-male"];
//        }else{
//            imgAvatar = [self.helperIns getImageFromSVGName:@"icon-contact-female"];
//        }
//    }
//    
//    self.imgViewAvatar = [[UIImageView alloc] initWithImage:imgAvatar];
//    [self.imgViewAvatar setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GrayColor2"]]];
//    
//    [self.viewInfo addSubview:self.imgViewAvatar];
    
    self.lblLastName= [[UILabel alloc] init];
    [self.lblLastName setBackgroundColor:[UIColor clearColor]];
    [self.lblLastName setTextAlignment:NSTextAlignmentRight];
    [self.lblLastName setTextColor:[UIColor blackColor]];
    [self.lblLastName setFont:[self.helperIns getFontThin: 15]];
    [self.lblLastName setText:[[subNickName objectAtIndex:0] uppercaseString]];
    
    CGSize sizeLastName = [self.lblLastName.text sizeWithFont:[self.helperIns getFontThin:15] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.viewInfo addSubview:self.lblLastName];

    self.lblFirstName = [[UILabel alloc] init];
    [self.lblFirstName setBackgroundColor:[UIColor clearColor]];
    [self.lblFirstName setTextColor:[UIColor blackColor]];
    [self.lblFirstName setTextAlignment:NSTextAlignmentRight];
    [self.lblFirstName setFont:[self.helperIns getFontMedium: 15]];
    [self.lblFirstName setText:[[subNickName objectAtIndex:1] uppercaseString]];

    CGSize sizeFirstName = [self.lblFirstName.text sizeWithFont:[self.helperIns getFontMedium:15] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.viewInfo addSubview:self.lblFirstName];

//    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
//    [DateFormatter setDateFormat:@"LLLL d"];
//    NSString *strTime = [[DateFormatter stringFromDate:[NSDate date]] uppercaseString];
//    
//    self.lblLocationInfo = [[UILabel alloc] init];
//    [self.lblLocationInfo setBackgroundColor:[UIColor clearColor]];
//    [self.lblLocationInfo setTextColor:[UIColor whiteColor]];
//    [self.lblLocationInfo setTextAlignment:NSTextAlignmentRight];
//    [self.lblLocationInfo setFont:[self.helperIns getFontThin: 18]];
//    [self.lblLocationInfo setText:[NSString stringWithFormat:@"%@ | HANOI", strTime]];
//    
//    CGSize sizeLocationInfo = [self.lblLocationInfo.text sizeWithFont:[self.helperIns getFontThin: 18] constrainedToSize:textSize lineBreakMode:NSLineBreakByCharWrapping];
//    
//    [self.viewInfo addSubview:self.lblLocationInfo];
//    
//    CGFloat h = sizeLastName.height + sizeLocationInfo.height;
//    
//    [self.imgViewAvatar setFrame:CGRectMake(self.bounds.size.width - (marginRightHeader + h + [self getSizeLogo].width), 0, h, h)];
//    self.imgViewAvatar.layer.cornerRadius = h / 2;
//    [self.imgViewAvatar setContentMode:UIViewContentModeScaleAspectFill];
//    [self.imgViewAvatar setAutoresizingMask:UIViewAutoresizingNone];
//    self.imgViewAvatar.layer.borderWidth = 0.0f;
//    [self.imgViewAvatar setClipsToBounds:YES];
//
    
    
    [self.lblLastName setFrame:CGRectMake(0, ([self getHeaderHeight] / 2) - (sizeLastName.height / 2), sizeLastName.width, sizeLastName.height)];
    
    [self.lblFirstName setFrame:CGRectMake(sizeLastName.width + 5, ([self getHeaderHeight] / 2) - (sizeLastName.height / 2), sizeFirstName.width, sizeFirstName.height)];

    [self.viewInfo setFrame:CGRectMake((self.bounds.size.width / 2) - ((sizeFirstName.width + 5 + sizeLastName.width) / 2), 0, sizeFirstName.width + 5 + sizeLastName.width, [self getHeaderHeight])];
}

- (UIBezierPath*) createArcPath{
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(sizeCircle.width / 2, sizeCircle.height - 10) radius:12 startAngle:DEGREES_TO_RADIANS(M_PI * -180) endAngle:0 clockwise:YES];
    
    return aPath;
}

- (void) handleSwipeUpAssets:(UISwipeGestureRecognizer*)recognizer{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        
//        [viewLibrary setFrame:CGRectMake(0, [self getHeaderHeight], self.bounds.size.width, self.bounds.size.height - [self getHeaderHeight])];
        CGFloat height = self.bounds.size.height - 320;
        
        [viewLibrary setFrame:CGRectMake(0, self.bounds.size.height - self.bounds.size.width, self.bounds.size.width, self.bounds.size.width)];
        [cameraPreview setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - [self getHeaderHeight])];
        [cameraPreview resizeCameraPreview];
        [cameraPreview setIsFullCameraCapture:YES];
        
    } completion:^(BOOL finished) {
        isShowPanel = YES;
    }];
}

- (void) handleSwipeDownAssets:(UISwipeGestureRecognizer*)recognizer{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [viewLibrary setFrame:CGRectMake(0, self.bounds.size.height - 200, self.bounds.size.width, 200)];
        [cameraPreview setFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
        [cameraPreview resizeCameraPreview];
        [cameraPreview setIsFullCameraCapture:NO];
    } completion:^(BOOL finished) {
        isShowPanel = YES;
    }];
}

- (void) handleSwipeUp:(UISwipeGestureRecognizer*)recognizer{

    [self showToolkit];
    
}

- (void) handleSwipeDown:(UISwipeGestureRecognizer*)recognizer{
    
    [self hiddenToolkit];
    
}

- (void) showToolkit{

    if (isShowPanel) {
        return;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        if (isShowKeyboar) {
            [self.messageView setFrame:CGRectMake(0, self.viewSendMessage.frame.origin.y - heightToolkitShow, self.bounds.size.width, heightToolkitShow)];
            [self.viewToolKit setFrame:CGRectMake(0, 20, self.bounds.size.width, 100)];
        }else{
            [self.messageView setFrame:CGRectMake(0, self.viewSendMessage.frame.origin.y - heightToolkitShow, self.bounds.size.width, heightToolkitShow)];
            [self.viewToolKit setFrame:CGRectMake(0, 20, self.bounds.size.width, 100)];
        }
        
//        [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.bounds.size.width, self.bounds.size.height - [self getHeaderHeight] - heightTextField)];
        
    } completion:^(BOOL finished) {
        isShowPanel = YES;
    }];
}

- (void) hiddenToolkit{

    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        if (isShowKeyboar) {
            [viewLibrary setFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 200)];
            
            [self.messageView setFrame:CGRectMake(0, self.viewSendMessage.frame.origin.y - heightToolkitNormal, self.bounds.size.width, 20)];
            [self.viewToolKit setFrame:CGRectMake(0, 20, self.bounds.size.width, 0)];

        }else{
            [viewLibrary setFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 200)];
            
            [self.messageView setFrame:CGRectMake(0, viewSendMessage.frame.origin.y - heightToolkitNormal, self.bounds.size.width, 20)];
            [self.viewToolKit setFrame:CGRectMake(0, 20, self.bounds.size.width, 0)];
        }
        
        [lblTapTakePhoto setHidden:YES];
        [lblCancelSend setHidden:YES];
        [lblSendPhoto setHidden:YES];
        [lblChangeCamera setHidden:YES];
        [btnShowLibrary setHidden:YES];
        
        [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.bounds.size.width, self.bounds.size.height - [self getHeaderHeight] - heightTextField)];
        
        if (lastPhotoSelected > -1) {
            UIView *mainView = [scrollImageLibrary viewWithTag:lastPhotoSelected + 300];
            
            UIButton *btnSend = (UIButton*)[mainView viewWithTag:lastPhotoSelected + 100];
            UIImageView *imgView = (UIImageView*)[mainView viewWithTag:lastPhotoSelected];
            
            imgView.image = lastImageSelected;
            [UIView animateWithDuration:0.2
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:(void (^)(void)) ^{
                                 
                                 [btnSend setAlpha:0.0f];
                                 //                             [btnEdit setAlpha:0.0f];
                                 
                                 imgView.transform=CGAffineTransformMakeScale(1.0, 1.0);
                             }
                             completion:^(BOOL finished){
                                 
                             }];
            
            lastPhotoSelected = -1;
        }

    } completion:^(BOOL finished) {
        isShowPanel = NO;
    }];
}

- (void) addFriendIns:(Friend *)_friendInstance{
    self.friendIns = _friendInstance;
    
    self.tbView.friendIns = _friendInstance;
}

- (void) reloadFriend{
    [self.hpTextChat setText:@""];
    
    [self hiddenToolkit];
}


/**1
 *  touches send message
 */
- (void) btnSendMessage{
//    if (![self.scTextChat.text isEqualToString:@""]) {
//        [self sendMessage];
//    }
    
    if (![self.hpTextChat.text isEqualToString:@""]) {
        [self sendMessage];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
//    if (![self.scTextChat.text isEqualToString:@""]) {
//        [self sendMessage];
//    }
    
    if (![self.hpTextChat.text isEqualToString:@""]) {
        [self sendMessage];
    }

    return YES;
}

- (void) sendPhoto:(UIImage*)img{
    UIImage *newImage = [[UIImage alloc] init];
    newImage = [self.helperIns resizeImage:img resizeSize:CGSizeMake(640, 1136)];
    
    imgDataSend = [self.helperIns compressionImage:newImage];
    
    NSInteger keyMessage = [self.storeIns incrementKeyMessage:self.friendIns.friendID];
    
    NSString *cmd = [self.dataMapIns getUploadAmazonUrl:self.friendIns.friendID withMessageKye:keyMessage withIsNotify:1];
    [self.networkIns sendData:cmd];
    
    AmazonInfo *_amazonInfo = [[AmazonInfo alloc] init];
    [_amazonInfo setKeyMessage:(int)keyMessage];
    [_amazonInfo setImgDataSend:imgDataSend];
    
    [self.storeIns.sendAmazon addObject:_amazonInfo];
    
    UIImage *imgThum = [[UIImage alloc] init];
    imgThum = [self.helperIns resizeImage:newImage resizeSize:CGSizeMake(320, 568)];
    
    Messenger *newMessage = [[Messenger alloc] init];
    [newMessage setTypeMessage:1];
    [newMessage setStatusMessage:0];
    [newMessage setTimeMessage:[self.helperIns getDateFormatMessage:[NSDate date]]];
    [newMessage setFriendID:self.friendIns.friendID];
    [newMessage setDataImage:imgDataSend];
    [newMessage setThumnail:imgThum];
    [newMessage setKeySendMessage:keyMessage];
    
    NSString *stringImage = [self.helperIns encodedBase64:imgDataSend];
    
    [newMessage setStrMessage: @""];
    [newMessage setStrImage:stringImage];
    [newMessage setUserID:self.storeIns.user.userID];
    
    [self.friendIns.friendMessage addObject:newMessage];
    
    [self autoScrollTbView];
    
    [self.tbView reloadData];
    
    if (lastPhotoSelected > -1) {
        UIView *mainView = [scrollImageLibrary viewWithTag:lastPhotoSelected + 300];
        
        UIButton *btnSend = (UIButton*)[mainView viewWithTag:lastPhotoSelected + 100];
        UIImageView *imgView = (UIImageView*)[mainView viewWithTag:lastPhotoSelected];
        UIView *_layerView = [mainView viewWithTag:lastPhotoSelected + 500];
        [_layerView setHidden:YES];
        imgView.image = lastImageSelected;
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             
                             [btnSend setAlpha:0.0f];
                             //                             [btnEdit setAlpha:0.0f];
                             
                             imgView.transform=CGAffineTransformMakeScale(1.0, 1.0);
                         }
                         completion:^(BOOL finished){
                             
                         }];
        
        lastPhotoSelected = -1;
    }
}

- (void) sendMessage{
    NSInteger _keyMessage = [self.storeIns incrementKeyMessage:self.friendIns.friendID];
    
    NSString *cmd = [self.dataMapIns sendMessageCommand:self.friendIns.friendID withKeyMessage:_keyMessage withMessage:self.hpTextChat.text withTimeout:0];
    [self.networkIns sendData:cmd];
    
    Messenger *_newMessage = [[Messenger alloc] init];
    [_newMessage setStrMessage: self.hpTextChat.text];
    [_newMessage setTypeMessage:0];
    [_newMessage setStatusMessage:0];
    [_newMessage setKeySendMessage:_keyMessage];
    [_newMessage setTimeMessage:[self.helperIns getDateFormatMessage:[NSDate date]]];
    [_newMessage setDataImage:nil];
    [_newMessage setThumnail:nil];
    [_newMessage setFriendID:self.friendIns.friendID];
    [_newMessage setUserID:self.storeIns.user.userID];
    
    [self.friendIns.friendMessage addObject:_newMessage];
    
    [self autoScrollTbView];
    
    self.hpTextChat.text = @"";
}

#pragma -mark keyboardDelegate

- (void) keyboardWillShow:(NSNotification *)notification{
    isShowKeyboar = YES;
    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"heigth keyboard: %f", kbSize.height);
    CGRect frame = self.messageView.frame;
    CGRect frameSendVIew = self.viewSendMessage.frame;
    
    CGFloat keyboardPos = self.bounds.size.height - kbSize.height;
    keyboardPos -= frame.size.height;
    CGFloat posI = frame.origin.y - kbSize.height;
    
    if (posI > frame.size.height) {
        frame.origin.y -= kbSize.height;
        frameSendVIew.origin.y -= kbSize.height;
        [UIView animateWithDuration:0.1 animations:^{
            [self.messageView setFrame:frame];
            [self.viewSendMessage setFrame:frameSendVIew];
            
            [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.bounds.size.width, self.frame.size.height - kbSize.height - [self getHeaderHeight] - heightToolkitNormal - heightTextField)];
            
            [self scrollToBottom];
            
        }];
    }
}

- (void) keyboardDidShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"heigth keyboard Did Show: %f", kbSize.height);
}

- (void) keyboardWillBeHidden:(NSNotification*)aNotification{
    isShowKeyboar = NO;
    NSDictionary *userInfo = [aNotification userInfo];
    CGSize kbSize = [[userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"Will be hidden: %f", kbSize.height);
//    CGRect frame = self.messageView.frame;
//    frame.origin.y += kbSize.height;
    
    CGRect frameSendView = self.viewSendMessage.frame;
    frameSendView.origin.y += kbSize.height;
    
    [UIView animateWithDuration:0.0 animations:^{
//        [self.messageView setFrame:frame];
        if (isShowPanel) {
            [self.messageView setFrame:CGRectMake(0, frameSendView.origin.y - heightToolkitShow, self.bounds.size.width, heightToolkitShow)];
        }else{
            [self.messageView setFrame:CGRectMake(0, frameSendView.origin.y - heightToolkitNormal, self.bounds.size.width, heightToolkitNormal)];
        }
        
        [self.viewSendMessage setFrame:frameSendView];
        
        [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.bounds.size.width, self.bounds.size.height - [self getHeaderHeight] - heightTextField - heightToolkitNormal)];
        
        [self autoScrollTbView];
    }];
}

- (void) keyboarddidBeHidden:(NSNotification *)notification{
    NSLog(@"did hidden");
}

- (void) tapCameraTakePhoto:(UITapGestureRecognizer *)recognizer{
    if (![cameraPreview getInShowPhoto]) {
        [cameraPreview captureImage:nil];
        [lblSendPhoto setHidden:NO];
        [lblCancelSend setHidden:NO];
        [lblTapTakePhoto setHidden:YES];
        [lblChangeCamera setHidden:YES];
    }
}

- (void) tapSendPhoto:(UITapGestureRecognizer *)recognizer{
    NSLog(@"send photo");
    
    [cameraPreview closeImage];
    
    UIImage *imgSend = [cameraPreview getImageSend];
    [self sendPhoto:imgSend];
    
    [lblCancelSend setHidden:YES];
    [lblSendPhoto setHidden:YES];
    [lblTapTakePhoto setHidden:NO];
}

- (void) tapCancelSendPhoto:(UITapGestureRecognizer *)recognizer{
    NSLog(@"cancel send photo");
    [cameraPreview closeImage];
    [lblCancelSend setHidden:YES];
    [lblSendPhoto setHidden:YES];
    [lblTapTakePhoto setHidden:NO];
    [lblChangeCamera setHidden:NO];
}

- (void) tapChangeCamera:(UITapGestureRecognizer *)recognizer{
    if (isBackCamera) {
        [cameraPreview switchCamera:NO];
        isBackCamera = NO;
    }else{
        [cameraPreview switchCamera:YES];
        isBackCamera = YES;
    }
}

- (void) touchesInTableView{
    [self endEditing:YES];
    [self hiddenToolkit];
    
    [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.bounds.size.width, self.bounds.size.height - [self getHeaderHeight] - heightTextField)];
    
    isTouchTableView = YES;
}

- (void) touchEndTableView{
    isTouchTableView = NO;
}

- (NSData*) getImgDataSend{
    return imgDataSend;
}

- (void) scrollToBottom{
    //scroll to bottom
    double y = self.tbView.contentSize.height - self.tbView.bounds.size.height;
    CGPoint bottomOffset = CGPointMake(0, y);
    if (y > -self.tbView.contentInset.top)
        [self.tbView setContentOffset:bottomOffset animated:YES];
}

- (void) resetCamera{

    [cameraPreview closeImage];
    [lblCancelSend setHidden:YES];
    [lblSendPhoto setHidden:YES];
    
    [lblTapTakePhoto setHidden:YES];
    [lblChangeCamera setHidden:YES];
    
    [cameraPreview switchCamera:NO];
    
}

#pragma -mark SCMessageTableView Delegate
- (void) sendIsReadMessage:(int)_friendID withKeyMessage:(NSInteger)_keyMessage withTypeMessage:(int)_typeMessage{
    
    NSString *cmd = nil;
    
    if (_typeMessage == 0) {
        cmd = [self.dataMapIns sendIsReadMessage:_friendID withKeyMessage:_keyMessage];
    }else if (_typeMessage == 1){
        cmd = [self.dataMapIns sendIsReadPhoto:_friendID withKeyMessage:_keyMessage];
    }else{
        cmd = [self.dataMapIns sendIsReadLocation:_friendID withKeyMessage:_keyMessage];
    }
    
    [self.storeIns updateStatusMessageFriendWithKey:_friendID withMessageID:_keyMessage withStatus:2];
    
    Messenger *_messenger = [self.storeIns getMessageFriendID:_friendID withKeyMessage:_keyMessage];
    
    [coziCoreData updateMessenger:_messenger];
    
    if (cmd != nil) {
        [self.networkIns sendData:cmd];
    }
}

- (void) notifyDeleteMessage:(Messenger *)_messenger{

    NSString *cmd = @"";
    if (_messenger.typeMessage == 0) {
        cmd = [self.dataMapIns removeMessage:_messenger.friendID withKeyMessage:(int)_messenger.keySendMessage];
    }else if (_messenger.typeMessage == 1){
        cmd = [self.dataMapIns removePhoto:_messenger.friendID withKeyMessage:(int)_messenger.keySendMessage];
    }else{
        cmd = [self.dataMapIns removeLocation:_messenger.friendID withKeyMessage:(int)_messenger.keySendMessage];
    }
    
    if (![cmd isEqualToString:@""]) {
        [self.networkIns sendData:cmd];
    }
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.viewSendMessage.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.viewSendMessage.frame = r;
    if (isShowPanel) {
        [self.messageView setFrame:CGRectMake(0, r.origin.y - heightToolkitShow, self.bounds.size.width, heightToolkitShow)];
    }else{
        [self.messageView setFrame:CGRectMake(0, r.origin.y - heightToolkitNormal, self.bounds.size.width, heightToolkitNormal)];
    }
    
    [self.btnSend setFrame:CGRectMake(self.bounds.size.width - heightTextField, 0, heightTextField, height)];
}
@end
