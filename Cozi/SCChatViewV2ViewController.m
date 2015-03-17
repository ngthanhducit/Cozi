//
//  SCChatViewV2ViewController.m
//  Cozi
//
//  Created by ChjpCoj on 3/8/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCChatViewV2ViewController.h"

@interface SCChatViewV2ViewController ()

@end

@implementation SCChatViewV2ViewController

@synthesize tbView;
@synthesize btnPhoto;
@synthesize btnTakePhoto;
@synthesize btnLocation;
@synthesize viewSendMessage;
@synthesize viewToolKit;
@synthesize storeIns;
@synthesize imgViewAvatar;
@synthesize viewInfo;
@synthesize lblFirstName;
@synthesize lblLastName;
@synthesize lblLocationInfo;
@synthesize chatToolKit;

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

#define SWIPE_UP_THRESHOLD -800.0f
#define SWIPE_DOWN_THRESHOLD 800.0f

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerNotification];
    
    [self setup];
}

- (void) registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesInTableView) name:@"touchTableView" object:nil];
    
    //endDeceleration
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchEndTableView) name:@"endDeceleration" object:nil];
    
    //endDeceleration
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showIsShowFullImage) name:@"showFullImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeIsFullImage) name:@"closeFullImage" object:nil];
}

- (void) setup{
    hHeader = 40;
    lastPhotoSelected = -1;
    self.storeIns = [Store shareInstance];
    coziCoreData = [CoziCoreData shareInstance];
    self.helperIns = [Helper shareInstance];
    self.networkIns = [NetworkCommunication shareInstance];
    self.dataMapIns = [DataMap shareInstance];
    self.recentIns = [Recent new];
    
    vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, hHeader)];
    [vHeader setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor2"]]];
    [self.view addSubview:vHeader];
    
    self.lblNickName = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, vHeader.bounds.size.width - 80, vHeader.bounds.size.height)];
    [self.lblNickName setText:@"NICK NAME"];
    [self.lblNickName setUserInteractionEnabled:YES];
    [self.lblNickName setTextAlignment:NSTextAlignmentCenter];
    [self.lblNickName setTextColor:[UIColor whiteColor]];
    [self.lblNickName setFont:[self.helperIns getFontLight:16.0f]];
    [vHeader addSubview:self.lblNickName];
    
    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFriendHeader)];
    [tapHeader setNumberOfTapsRequired:1];
    [tapHeader setNumberOfTouchesRequired:1];
    [self.lblNickName addGestureRecognizer:tapHeader];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnBack setFrame:CGRectMake(self.view.bounds.size.width - hHeader, 0, hHeader, hHeader)];
    [self.btnBack setImage:[self.helperIns getImageFromSVGName:@"icon-backarrow-25px-V2.svg"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [vHeader addSubview:self.btnBack];
    
    self.tbView = [[SCMessageTableViewV3 alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - hHeader - heightTextField - heightToolkitNormal) style:UITableViewStylePlain];
    [self.tbView setScMessageGroupTableViewDelegate:self];
    [self.tbView setContentOffset:CGPointMake(20, 0) animated:NO];
    self.tbView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeInteractive;
    [self.view addSubview:self.tbView];
    
    self.viewSendMessage = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - heightTextField, self.view.bounds.size.width, heightTextField)];
    [self.view addSubview:self.viewSendMessage];
    
    CALayer *bottomLine = [CALayer layer];
    [bottomLine setFrame:CGRectMake(0.0f, 0.0, self.viewSendMessage.bounds.size.width, 0.5f)];
    [bottomLine setBackgroundColor:[self.helperIns colorWithHex:[self.helperIns getHexIntColorWithKey:@"GreenColor2"]].CGColor];
    [self.viewSendMessage.layer addSublayer:bottomLine];
    
    self.chatToolKit = [[SCChatToolKitView alloc] initWithFrame:CGRectMake(0, 0.5, self.view.bounds.size.width, self.viewSendMessage.bounds.size.height - 0.5)];
    [self.chatToolKit setBackgroundColor:[UIColor clearColor]];
    [self.viewSendMessage addSubview:self.chatToolKit];
    
    //register event
    [self.chatToolKit.btnText addTarget:self action:@selector(btnTextTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatToolKit.btnPing addTarget:self action:@selector(btnPingTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatToolKit.btnCamera addTarget:self action:@selector(btnTakePhotoTap) forControlEvents:UIControlEventTouchUpInside];
    [self.chatToolKit.btnPhoto addTarget:self action:@selector(btnPhotoLibraryTap) forControlEvents:UIControlEventTouchUpInside];
    [self.chatToolKit.btnLocation addTarget:self action:@selector(btnSendLocationTap) forControlEvents:UIControlEventTouchUpInside];
    [self.chatToolKit.btnSendMessage addTarget:self action:@selector(btnSendMessageTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.chatToolKit.hpTextChat setDelegate:self];
    
    viewLibrary = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 0)];
    [viewLibrary setBackgroundColor:[UIColor whiteColor]];
    [viewLibrary setContentMode:UIViewContentModeCenter];
//    [viewLibrary setClipsToBounds:YES];
    [self.view addSubview:viewLibrary];
    
    [self setupCamera];
    
    //init view new messenger
    self.vNewMessage = [[UIView alloc] initWithFrame:CGRectMake(50, self.viewSendMessage.frame.origin.y - (30), self.view.bounds.size.width - 100, 30)];
    [self.vNewMessage setHidden:YES];
    [self.vNewMessage setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.vNewMessage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNewMessenger:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self.vNewMessage addGestureRecognizer:tap];
    
    self.lblNewMessenger = [[UILabel alloc] initWithFrame:self.vNewMessage.bounds];
    [self.lblNewMessenger setText:@"New Message"];
    [self.lblNewMessenger setTextAlignment:NSTextAlignmentCenter];
    [self.lblNewMessenger setFont:[self.helperIns getFontLight:12.0f]];
    [self.lblNewMessenger setTextColor:[UIColor whiteColor]];
    [self.vNewMessage addSubview:self.lblNewMessenger];
    
    self.vRequestChat = [[SCRequestChat alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 30 - [UIApplication sharedApplication].statusBarFrame.size.height, self.view.bounds.size.width, 30)];
    [self.vRequestChat setHidden:YES];
//    [self.viewSendMessage addSubview:self.vRequestChat];
    [self.view addSubview:self.vRequestChat];
    
    [self.vRequestChat.btnDeny addTarget:self action:@selector(btnDenyChatClick) forControlEvents:UIControlEventTouchUpInside];
    [self.vRequestChat.btnAllow addTarget:self action:@selector(btnAllowChatClick) forControlEvents:UIControlEventTouchUpInside];
    
    scrollImageLibrary = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 250)];
    [scrollImageLibrary setBackgroundColor:[UIColor clearColor]];
    [scrollImageLibrary setBounces:YES];
    [viewLibrary addSubview:scrollImageLibrary];
}

- (void) setupCamera{
    cameraPreview = [[CameraCaptureV6 alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    [cameraPreview.session stopRunning];
    [viewLibrary addSubview:cameraPreview];
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
//    [cameraPreview addGestureRecognizer:pan];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [cameraPreview addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [cameraPreview addGestureRecognizer:swipeDown];
    
    self.vCameraTool = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width, 80)];
    [self.vCameraTool setBackgroundColor:[UIColor blackColor]];
    [self.vCameraTool setAlpha:0.6];
    [self.vCameraTool setHidden:YES];
    [self.view addSubview:self.vCameraTool];
    
//    lblCancelSend = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width / 4, 60)];
//    [lblCancelSend setText:@"CANCEL"];
//    [lblCancelSend setTextAlignment:NSTextAlignmentCenter];
//    [lblCancelSend setTextColor:[UIColor whiteColor]];
//    [lblCancelSend setFont:[self.helperIns getFontThin:20.0f]];
//    [lblCancelSend setHidden:YES];
//    [lblCancelSend setUserInteractionEnabled:YES];
//    [self.view addSubview:lblCancelSend];
//    
//    lblTapTakePhoto = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - (self.view.bounds.size.width / 4), self.view.bounds.size.height - 80, self.view.bounds.size.width / 2, 60)];
//    [lblTapTakePhoto setText:@"TAP TO SHOT"];
//    [lblTapTakePhoto setTextAlignment:NSTextAlignmentCenter];
//    [lblTapTakePhoto setTextColor:[UIColor whiteColor]];
//    [lblTapTakePhoto setFont:[self.helperIns getFontThin:20.0f]];
//    [lblTapTakePhoto setHidden:YES];
//    [lblTapTakePhoto setUserInteractionEnabled:YES];
//    [self.view addSubview:lblTapTakePhoto];
//    
//    lblSendPhoto = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 4) * 3, self.view.bounds.size.height - 80, self.view.bounds.size.width / 4, 60)];
//    [lblSendPhoto setText:@"SEND"];
//    [lblSendPhoto setTextAlignment:NSTextAlignmentCenter];
//    [lblSendPhoto setTextColor:[UIColor whiteColor]];
//    [lblSendPhoto setFont:[self.helperIns getFontThin:20.0f]];
//    [lblSendPhoto setHidden:YES];
//    [lblSendPhoto setUserInteractionEnabled:YES];
//    [self.view addSubview:lblSendPhoto];
//    
//    lblChangeCamera = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 4) * 3, self.view.bounds.size.height - 80, self.view.bounds.size.width / 4, 60)];
//    [lblChangeCamera setText:@"SWITCH"];
//    [lblChangeCamera setTextAlignment:NSTextAlignmentCenter];
//    [lblChangeCamera setTextColor:[UIColor whiteColor]];
//    [lblChangeCamera setFont:[self.helperIns getFontThin:20.0f]];
//    [lblChangeCamera setHidden:YES];
//    [lblChangeCamera setUserInteractionEnabled:YES];
//    [self.view addSubview:lblChangeCamera];
//    
//    UITapGestureRecognizer *tapTakePhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCameraTakePhoto:)];
//    [tapTakePhoto setNumberOfTapsRequired:1];
//    [tapTakePhoto setNumberOfTouchesRequired:1];
//    [lblTapTakePhoto addGestureRecognizer:tapTakePhoto];
//    
//    UITapGestureRecognizer *tapSendPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSendPhoto:)];
//    [tapSendPhoto setNumberOfTapsRequired:1];
//    [tapSendPhoto setNumberOfTouchesRequired:1];
//    [lblSendPhoto addGestureRecognizer:tapSendPhoto];
//    
//    UITapGestureRecognizer *tapCancelSendPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCancelSendPhoto:)];
//    [tapCancelSendPhoto setNumberOfTapsRequired:1];
//    [tapCancelSendPhoto setNumberOfTouchesRequired:1];
//    [lblCancelSend addGestureRecognizer:tapCancelSendPhoto];
//    
//    UITapGestureRecognizer *tapChangeCamera = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChangeCamera:)];
//    [tapChangeCamera setNumberOfTapsRequired:1];
//    [tapChangeCamera setNumberOfTouchesRequired:1];
//    [lblChangeCamera addGestureRecognizer:tapChangeCamera];
}

- (void) panView:(UIPanGestureRecognizer*)recognizer{
    // Get the translation in the view
    CGPoint t = [recognizer translationInView:recognizer.view];
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    
    [self.view bringSubviewToFront:viewLibrary];
    [viewLibrary bringSubviewToFront:cameraPreview];
    [viewLibrary setBackgroundColor:[UIColor orangeColor]];
    
    // TODO: Here, you should translate your target view using this translation
//    viewLibrary.center = CGPointMake(viewLibrary.center.x, viewLibrary.center.y + t.y);

    [viewLibrary setFrame:CGRectMake(viewLibrary.frame.origin.x, viewLibrary.center.y + t.y, viewLibrary.bounds.size.width, viewLibrary.bounds.size.height - t.y)];
    
    cameraPreview.frame = CGRectMake(0, 0, self.view.bounds.size.width, cameraPreview.bounds.size.height - t.y);
    [cameraPreview resizeCameraPreview];

}

- (void) swipeView:(UISwipeGestureRecognizer*)recognizer{
    if ([recognizer direction] == UISwipeGestureRecognizerDirectionUp) {
        [self.view bringSubviewToFront:viewLibrary];

        [viewLibrary setFrame:CGRectMake(0, viewLibrary.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [viewLibrary setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];

            [cameraPreview setFrame:CGRectMake(0, 0, cameraPreview.bounds.size.width, self.view.bounds.size.height)];
            [cameraPreview resizeCameraPreview];
            
        } completion:^(BOOL finished) {

        }];
    }
    
    if ([recognizer direction] == UISwipeGestureRecognizerDirectionDown) {

        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [viewLibrary setFrame:CGRectMake(0, self.view.bounds.size.height - 200, self.view.bounds.size.width, 200)];
            
            [cameraPreview setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];

            [cameraPreview resizeCameraPreview];
        } completion:^(BOOL finished) {

        }];
        
    }
}

-(void) loadAssets{
    
    assetsThumbnail = [NSMutableArray new];
    urlAssetsImage = [NSMutableArray new];
    
    waitingLoadPhoto = [[SCActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 250)];
    [waitingLoadPhoto setText:@"Loading..."];
    [viewLibrary addSubview:waitingLoadPhoto];
    
    [[scrollImageLibrary subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    __block ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos | ALAssetsGroupLibrary usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
            if (group == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self initLibraryImage];
                    
                });
            }
            
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    CGImageRef iref = [result aspectRatioThumbnail];
                    
                    UIImage *img =  [UIImage imageWithCGImage:iref];
                    
                    if (img) {
                        
                        [assetsThumbnail addObject:img];
                        
                        [urlAssetsImage addObject:[[result defaultRepresentation] url]];
                        
                    }else{
                        
                        NSLog(@"image error");
                        
                    }
                }
            }];
            
        } failureBlock:^(NSError *error) {
            NSLog(@"No groups: %@", error);
        }];
        
    });
}

- (void) initLibraryImage{
    
    //        NSMutableArray *assets = [self.storeIns getAssetsThumbnail];
    NSMutableArray *assets = assetsThumbnail;
    
    CGFloat widthContent = [assets count] * 202;
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
    [btnShowLibrary setFrame:CGRectMake(20, self.view.bounds.size.height - 70, 50, 50)];
    [btnShowLibrary setImage:[self.helperIns getImageFromSVGName:@"icon-Chat-ViewAll-V3.svg"] forState:UIControlStateNormal];
    [btnShowLibrary setClipsToBounds:YES];
    [btnShowLibrary setContentMode:UIViewContentModeScaleAspectFill];
    btnShowLibrary.layer.cornerRadius = btnShowLibrary.bounds.size.width / 2;
    [btnShowLibrary addTarget:self action:@selector(showImageLibrary:) forControlEvents:UIControlEventTouchUpInside];
    [btnShowLibrary setHidden:YES];
    [self.view addSubview:btnShowLibrary];
    
    [self.view bringSubviewToFront:btnShowLibrary];
    
    [waitingLoadPhoto removeFromSuperview];
}

- (void) showImageLibrary:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowListImage" object:nil];
    
}

- (void) addRecent:(Recent *)_recent;{
    self.recentIns = _recent;
    
    self.tbView.recentIns = _recent;
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

- (void) autoScrollTbView{
    
    [self.vNewMessage setFrame:CGRectMake(self.vNewMessage.frame.origin.x, self.viewSendMessage.frame.origin.y - self.vNewMessage.bounds.size.height, self.vNewMessage.bounds.size.width, self.vNewMessage.bounds.size.height)];
    
    [self.tbView reloadTableView];
    
}

- (void) btnSendImage:(UIButton*)sender{
    int tagNumber = (int)sender.tag - 100;
    
//    NSURL *assetURL = (NSURL*)[[self.storeIns getAssetsLibrary] objectAtIndex:tagNumber];
    NSURL *assetURL = (NSURL*)[urlAssetsImage objectAtIndex:tagNumber];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc(rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//this is NSData may be what you want
        UIImage *img = [UIImage imageWithData:data];
        
        [self sendPhoto:img];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (UIImage *)blurWithImageEffectsRestore:(UIImage *)image withRadius:(CGFloat)_radius{
    
    return [image applyBlurWithRadius:_radius tintColor:nil saturationDeltaFactor:1.0 maskImage:nil];
    
}

- (void) btnTextTap:(id)sender{
    [storeIns playSoundPress];
    
    [self hiddenToolkit];
    
    [self upChatView];
    
    [self.chatToolKit.hpTextChat becomeFirstResponder];
    
    [self.chatToolKit showTextField];
}

- (void) btnSendMessageTap:(id)sender{
    [storeIns playSoundPress];
    
    if (![self.chatToolKit.hpTextChat.text isEqualToString:@""]) {
        [self sendMessage:self.chatToolKit.hpTextChat.text];
    }
}

- (void) btnPingTap:(id)sender{
    [storeIns playSoundPress];
    
    //check last message if have ping and time < 5s then not send
//    Messenger *_messenger = [self.friendIns.friendMessage lastObject];
//    if (_messenger.userID == storeIns.user.userID) {
//        
//        NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:self.storeIns.timeServer];
//        NSDate *_dateTimeMessage = [_messenger.timeServerMessage dateByAddingTimeInterval:deltaTime];
//        NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:_dateTimeMessage];
//        
//        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        NSDateComponents *components = [calendar components:NSSecondCalendarUnit
//                                                   fromDate:_messenger.timeServerMessage
//                                                     toDate:self.storeIns.timeServer
//                                                    options:0];
//        
//        NSLog(@"Difference in date components: %i/%i/%i/%i/%i/%i", components.day, components.month, components.year, components.hour, components.minute, components.second);
//        
//        if (components.second > 5) {
//            [self sendMessage:@"(Ping)"];
//        }
//    }else{
        [self sendMessage:@"(Ping)"];
//    }
}

- (void) btnTakePhotoTap{
    [storeIns playSoundPress];
    
    [cameraPreview setHidden:NO];
    [scrollImageLibrary setHidden:YES];
    [self.vCameraTool setHidden:NO];
    
    [self.chatToolKit.btnPhoto setEnabled:NO];
    
    if (!cameraPreview.session.isRunning) {
        [cameraPreview.session startRunning];
    }
    
//    [scrollImageLibrary removeFromSuperview];
    [viewLibrary bringSubviewToFront:cameraPreview];
    
//    [self resetCamera];
    
    [self enablePan:NO];
    
//    [viewLibrary addSubview:cameraPreview];
    
    [toolkitCamera setHidden:NO];
    [self.view bringSubviewToFront:toolkitCamera];
    
    [lblTapTakePhoto setHidden:NO];
    [lblChangeCamera setHidden:NO];
    [btnShowLibrary setHidden:YES];
    
    [self showLibrary];
    
    [self.chatToolKit.btnPhoto setEnabled:YES];
}

- (void) btnSendLocationTap{
    [storeIns playSoundPress];
    
    [self.storeIns updateLocation];
    
    NSString *_keyMessage = [self.storeIns randomKeyMessenger];
    NSString *_long = [self.storeIns getLongitude];
    NSString *_lati = [self.storeIns getlatitude];
    
    NSString *cmd = [self.dataMapIns sendLocation:self.recentIns.recentID withLong:[self.storeIns getLongitude] withLati:[self.storeIns getlatitude] withKeyMessage:_keyMessage withTimeOut:0];
    
    Messenger *newMessage = [[Messenger alloc] init];
    [newMessage setTypeMessage:2];
    [newMessage setStatusMessage:0];
    [newMessage setTimeMessage:[self.helperIns getDateFormatMessage:[NSDate date]]];
    [newMessage setFriendID:self.recentIns.recentID];
    [newMessage setDataImage:nil];
    [newMessage setThumnail:nil];
    [newMessage setLongitude:_long];
    [newMessage setLatitude:_lati];
    [newMessage setKeySendMessage:_keyMessage];
    [newMessage setUserID:self.storeIns.user.userID];
    NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@,%@&zoom=13&size=480x320&scale=2&sensor=true&markers=color:red%@%@,%@", _lati, _long, @"%7c" , _lati, _long];
    [newMessage setUrlImage:url];
    
    [self.networkIns sendData:cmd];
    
    [self.recentIns.friendIns.friendMessage addObject:newMessage];
    
    [self autoScrollTbView];
    
    [self playSoundSendMessage];
    
}

- (void) btnPhotoLibraryTap{
    [storeIns playSoundPress];
    
    [scrollImageLibrary setHidden:NO];
    [cameraPreview setHidden:YES];
    [self.vCameraTool setHidden:YES];
    
    if (cameraPreview.session.isRunning) {
        [cameraPreview.session stopRunning];
    }
    
    [viewLibrary bringSubviewToFront:scrollImageLibrary];
//    [cameraPreview removeFromSuperview];
    
    [toolkitCamera setHidden:YES];
    [lblTapTakePhoto setHidden:YES];
    [lblChangeCamera setHidden:YES];
    
    [btnShowLibrary setHidden:NO];
    
//    [viewLibrary addSubview:scrollImageLibrary];
    
    [self showLibrary];
}

- (void) showLibrary{
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.view endEditing:YES];
        [self.viewSendMessage setFrame:CGRectMake(0, self.view.bounds.size.height - 200 - self.viewSendMessage.bounds.size.height, self.viewSendMessage.bounds.size.width, self.viewSendMessage.bounds.size.height)];
        [viewLibrary setFrame:CGRectMake(0, self.view.bounds.size.height - 200, self.view.bounds.size.width, 200)];
        [scrollImageLibrary setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
        
        [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.view.bounds.size.width, self.view.bounds.size.height - [self getHeaderHeight] - viewLibrary.bounds.size.height - heightTextField)];
        
        [self scrollToBottom];
        
    } completion:^(BOOL finished) {
        isShowPanel = YES;
        
    }];
}


//chat position uitableview chat when show keyboard or toolkit content
- (void) upChatView{
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.view.bounds.size.width, self.view.bounds.size.height - [self getHeaderHeight] - viewLibrary.bounds.size.height - heightTextField)];
        
        [self scrollToBottom];
        
    } completion:^(BOOL finished) {
        isShowPanel = YES;
        
    }];
}

//rest positon uitableview chat
- (void) downChatView{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.view.bounds.size.width, self.view.bounds.size.height - [self getHeaderHeight] - heightTextField)];
        
        [self scrollToBottom];
        
    } completion:^(BOOL finished) {
        isShowPanel = YES;
        
    }];
}

- (void) showToolkit{
    
    if (isShowPanel) {
        return;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        if (isShowKeyboar) {
            [self.viewToolKit setFrame:CGRectMake(0, 20, self.view.bounds.size.width, 100)];
//        }else{
            [self.viewToolKit setFrame:CGRectMake(0, 20, self.view.bounds.size.width, 100)];
        }
        
    } completion:^(BOOL finished) {
        isShowPanel = YES;
    }];
}

- (void) hiddenToolkit{
    
    [self enablePan:YES];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        if (isShowKeyboar) {
            [viewLibrary setFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200)];
            
            [self.viewToolKit setFrame:CGRectMake(0, 20, self.view.bounds.size.width, 0)];
            
        }else{
            [viewLibrary setFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200)];
            
            [self.viewToolKit setFrame:CGRectMake(0, 20, self.view.bounds.size.width, 0)];
        }
        
        [self.vCameraTool setHidden:YES];
        
//        [lblTapTakePhoto setHidden:YES];
//        [lblCancelSend setHidden:YES];
//        [lblSendPhoto setHidden:YES];
//        [lblChangeCamera setHidden:YES];
        
        [btnShowLibrary setHidden:YES];
        
        [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.view.bounds.size.width, self.view.bounds.size.height - [self getHeaderHeight] - heightTextField)];
        
        if (lastPhotoSelected > -1) {
            UIView *mainView = [scrollImageLibrary viewWithTag:lastPhotoSelected + 300];
            
            UIButton *btnSend = (UIButton*)[mainView viewWithTag:lastPhotoSelected + 100];
            UIImageView *imgView = (UIImageView*)[mainView viewWithTag:lastPhotoSelected];
            UIView *lastLayer = [mainView viewWithTag:lastPhotoSelected + 500];
            [lastLayer setHidden:YES];
            
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
        
    } completion:^(BOOL finished) {
        isShowPanel = NO;
    }];
}

//- (void) addFriendIns:(Friend *)_friendInstance{
//    self.friendIns = _friendInstance;
//    
//    self.tbView.friendIns = _friendInstance;
//    
//    [self.tbView reloadData];
//}

- (void) reloadFriend{
    [self.hpTextChat setText:@""];
    
    [self loadAssets];
    
    [self hiddenToolkit];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if (![self.chatToolKit.hpTextChat.text isEqualToString:@""]) {
        [self sendMessage:self.chatToolKit.hpTextChat.text];
    }
    
    return YES;
}

- (void) sendPhoto:(UIImage*)img{
    UIImage *newImage = [self.helperIns resizeImage:img resizeSize:CGSizeMake(640, 1136)];
    
    imgDataSend = [NSData new];
    imgDataSend = [self.helperIns compressionImage:newImage];
    
    if (self.recentIns.typeRecent == 0) {
        
        NSString *keyMessage = [self.storeIns randomKeyMessenger];
        
        NSString *cmd = [self.dataMapIns getUploadAmazonUrl:self.recentIns.recentID withMessageKye:keyMessage withIsNotify:1];
        [self.networkIns sendData:cmd];
        
        AmazonInfo *_amazonInfo = [[AmazonInfo alloc] init];
        [_amazonInfo setTypeAmazon:0];
        [_amazonInfo setKeyMessage:keyMessage];
        [_amazonInfo setImgDataSend:imgDataSend];
        
        [self.storeIns.sendAmazon addObject:_amazonInfo];
        
        Messenger *newMessage = [[Messenger alloc] init];
        [newMessage setTypeMessage:1];
        [newMessage setStatusMessage:0];
        [newMessage setTimeMessage:[self.helperIns getDateFormatMessage:[NSDate date]]];
        [newMessage setFriendID:self.recentIns.recentID];
        [newMessage setKeySendMessage:keyMessage];
        [newMessage setStrMessage: @""];
        [newMessage setUserID:self.storeIns.user.userID];
        
        UIImage *newImageSize = [self.helperIns resizeImage:newImage resizeSize:CGSizeMake(newImage.size.width / 2, newImage.size.height / 2)];
        newMessage.thumnail = newImageSize;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.helperIns saveImageToDocument:newImage withName:keyMessage];
        });
        
        [self.recentIns.friendIns.friendMessage addObject:newMessage];
        
    }else if (self.recentIns.typeRecent == 1){
        
        NSString *keyMessage = [self.storeIns randomKeyMessenger];
        
        NSString *cmd = [self.dataMapIns getGroupUploadAmazonUrl:self.recentIns.recentID withMessageKey:keyMessage withIsNotify:1];
        [self.networkIns sendData:cmd];
        
        AmazonInfo *_amazonInfo = [[AmazonInfo alloc] init];
        [_amazonInfo setTypeAmazon:1];
        [_amazonInfo setKeyMessage:keyMessage];
        [_amazonInfo setImgDataSend:imgDataSend];
        
        [self.storeIns.sendAmazon addObject:_amazonInfo];
        
        Messenger *newMessage = [[Messenger alloc] init];
        [newMessage setTypeMessage:1];
        [newMessage setStatusMessage:0];
        [newMessage setTimeMessage:[self.helperIns getDateFormatMessage:[NSDate date]]];
        [newMessage setFriendID:self.recentIns.recentID];
        [newMessage setKeySendMessage:keyMessage];
        [newMessage setStrMessage: @""];
        [newMessage setUserID:self.storeIns.user.userID];
        
        UIImage *newImageSize = [self.helperIns resizeImage:newImage resizeSize:CGSizeMake(newImage.size.width / 2, newImage.size.height / 2)];
        newMessage.thumnail = newImageSize;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.helperIns saveImageToDocument:newImage withName:keyMessage];
        });
        
        [self.recentIns.messengerRecent addObject:newMessage];
        
    }
    
    [self autoScrollTbView];
    
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
                             
                             imgView.transform=CGAffineTransformMakeScale(1.0, 1.0);
                         }
                         completion:^(BOOL finished){
                             
                         }];
        
        lastPhotoSelected = -1;
    }
    
    imgDataSend = nil;
    
    [self playSoundSendMessage];
}

- (void) sendMessage:(NSString*)_content{
    _content = [_content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![_content isEqualToString:@""]) {
        if (self.recentIns.typeRecent == 0) {
            NSString *_keyMessage = [self.storeIns randomKeyMessenger];
            NSString *cmd = [self.dataMapIns sendMessageCommand:self.recentIns.recentID withKeyMessage:_keyMessage withMessage:_content withTimeout:0];
            [self.networkIns sendData:cmd];
            
            Messenger *_newMessage = [[Messenger alloc] init];
            [_newMessage setStrMessage: _content];
            [_newMessage setTypeMessage:0];
            [_newMessage setStatusMessage:0];
            [_newMessage setKeySendMessage:_keyMessage];
            [_newMessage setTimeMessage:[self.helperIns getDateFormatMessage:[NSDate date]]];
            [_newMessage setDataImage:nil];
            [_newMessage setThumnail:nil];
            [_newMessage setFriendID:self.recentIns.recentID];
            [_newMessage setUserID:self.storeIns.user.userID];
            
            [self.recentIns.friendIns.friendMessage addObject:_newMessage];
            
            [self autoScrollTbView];
            
            self.chatToolKit.hpTextChat.text = @"";
            
            [self playSoundSendMessage];
        }
        
        if (self.recentIns.typeRecent == 1) {
            NSString *_keyMessage = [self.storeIns randomKeyMessenger];
            NSString *cmd = [self.dataMapIns commandSendMessageToGroup:self.recentIns.recentID withKeyMessage:_keyMessage withMessage:_content withTimeout:0];
            [self.networkIns sendData:cmd];
            
            Messenger *_newMessage = [[Messenger alloc] init];
            [_newMessage setStrMessage: _content];
            [_newMessage setTypeMessage:0];
            [_newMessage setStatusMessage:0];
            [_newMessage setKeySendMessage:_keyMessage];
            [_newMessage setTimeMessage:[self.helperIns getDateFormatMessage:[NSDate date]]];
            [_newMessage setDataImage:nil];
            [_newMessage setThumnail:nil];
            [_newMessage setFriendID:self.recentIns.recentID];
            [_newMessage setUserID:self.storeIns.user.userID];
            
            [self.recentIns.messengerRecent addObject:_newMessage];
            
            [self autoScrollTbView];
            
            self.chatToolKit.hpTextChat.text = @"";
            
            [self playSoundSendMessage];
        }
    }
}

#pragma -mark keyboardDelegate

- (void) keyboardWillShow:(NSNotification *)notification{
    isShowKeyboar = YES;
    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"height text chat: %f", self.chatToolKit.hpTextChat.bounds.size.height);
    
    CGFloat hTextChat = heightTextField < self.chatToolKit.hpTextChat.bounds.size.height ? self.chatToolKit.hpTextChat.bounds.size.height : heightTextField;
    [self.viewSendMessage setBackgroundColor:[UIColor clearColor]];
    
    [self hiddenToolkit];
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.viewSendMessage setFrame:CGRectMake(0, self.view.bounds.size.height - kbSize.height - hTextChat - 2, self.view.bounds.size.width, hTextChat)];
        
        [self.chatToolKit.hpTextChat setFrame:CGRectMake(0, 0, self.chatToolKit.hpTextChat.bounds.size.width, self.chatToolKit.hpTextChat.bounds.size.height)];
        
        [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.view.bounds.size.width, self.view.frame.size.height - kbSize.height - [self getHeaderHeight] - hTextChat - 2)];
        
        [self scrollToBottom];
        
    }];
}

- (void) keyboardWillBeHidden:(NSNotification*)aNotification{
    isShowKeyboar = NO;
    NSDictionary *userInfo = [aNotification userInfo];
    CGSize kbSize = [[userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect frameSendView = self.viewSendMessage.frame;
    frameSendView.origin.y += kbSize.height;
    
    [self hiddenToolkit];
    
    [UIView animateWithDuration:0.0 animations:^{
        
        [self.viewSendMessage setFrame:CGRectMake(0, self.view.bounds.size.height - heightTextField, self.viewSendMessage.bounds.size.width, heightTextField)];
        
        [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.view.bounds.size.width, self.view.bounds.size.height - [self getHeaderHeight] - heightTextField)];
        
        [self autoScrollTbView];
        
        [self.chatToolKit reset];
    }];
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
    [lblChangeCamera setHidden:NO];
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
    
    [self resetUI];
    
    isTouchTableView = YES;
    
    
}

- (void) touchEndTableView{
    isTouchTableView = NO;
}

- (void) showIsShowFullImage{
    
    [self enablePan:NO];
    
}

- (void) closeIsFullImage{
    
    [self enablePan:YES];
}

- (void) enablePan:(BOOL)isEnable{
    
    if (self.view.gestureRecognizers) {
        for (UIPanGestureRecognizer *pan in self.view.gestureRecognizers) {
            if ([pan isKindOfClass:[UIPanGestureRecognizer class]]) {
                pan.enabled = isEnable;
            }
        }
    }
    
}

- (void) resetUI{
    [self.view endEditing:YES];
  
    [self resetCamera];
    
    [self hiddenToolkit];
    
    [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.view.bounds.size.width, self.view.bounds.size.height - [self getHeaderHeight] - heightTextField)];
    
    [self.chatToolKit reset];
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.viewSendMessage setFrame:CGRectMake(0, self.view.bounds.size.height - heightTextField, self.view.bounds.size.width, heightTextField)];
        
        [self.vNewMessage setFrame:CGRectMake(self.vNewMessage.frame.origin.x, self.viewSendMessage.frame.origin.y - self.vNewMessage.bounds.size.height, self.vNewMessage.bounds.size.width, self.vNewMessage.bounds.size.height)];
        
    } completion:^(BOOL finished) {
        
    }];
    
    if (self.recentIns.friendIns.isFriendWithYour == 0) {
        [self.chatToolKit setHidden:NO];
        [self.vRequestChat setHidden:YES];
    }else{
        [self.vRequestChat setHidden:NO];
        [self.chatToolKit setHidden:YES];
    }
}

- (NSData*) getImgDataSend{
    return imgDataSend;
}

- (void) scrollToBottom{
    //scroll to bottom
    self.vNewMessage.hidden = YES;
    double y = self.tbView.contentSize.height - self.tbView.bounds.size.height;
    CGPoint bottomOffset = CGPointMake(0, y);
    if (y > -self.tbView.contentInset.top)
        [self.tbView setContentOffset:bottomOffset animated:YES];
}

/**
 *  Reset default camera
 */
- (void) resetCamera{
    
    [cameraPreview closeImage];
    
    [self.vCameraTool setHidden:YES];
    
    [lblCancelSend setHidden:YES];
    [lblSendPhoto setHidden:YES];
    [lblTapTakePhoto setHidden:YES];
    [lblChangeCamera setHidden:YES];
    
//    [cameraPreview switchCamera:NO];
    
//    [cameraPreview resetCamera];
    
}

- (void) notifyDeleteMessageGroup:(Messenger *)_messenger{
    
    NSString *cmd = @"";
    if (_messenger.typeMessage == 0) {
        cmd = [self.dataMapIns removeMessage:_messenger.friendID withKeyMessage:_messenger.keySendMessage];
    }else if (_messenger.typeMessage == 1){
        cmd = [self.dataMapIns removePhoto:_messenger.friendID withKeyMessage:_messenger.keySendMessage];
    }else{
        cmd = [self.dataMapIns removeLocation:_messenger.friendID withKeyMessage:_messenger.keySendMessage];
    }
    
    if (![cmd isEqualToString:@""]) {
        [self.networkIns sendData:cmd];
    }
}

#pragma -mark SCMessageTableView Delegate
- (void) sendIsReadMessageGroup:(int)_friendID withKeyMessage:(NSString*)_keyMessage withTypeMessage:(int)_typeMessage{
    
    NSString *cmd = nil;
    
    if (self.recentIns.typeRecent == 0) {
        if (_typeMessage == 0) {
            cmd = [self.dataMapIns sendIsReadMessage:_friendID withKeyMessage:_keyMessage];
            NSLog(@"notify is read message: %@", _keyMessage);
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
            NSLog(@"command isread notify: %@", cmd);
        }
    }else if (self.recentIns.typeRecent == 1){
        cmd = [NSString stringWithFormat:@"GROUPISREAD{%i}%@<EOF>", self.recentIns.recentID, _keyMessage];
        [self.networkIns sendData:cmd];
        
        Messenger *_messenger = [self.storeIns getMessageGroupID:self.recentIns.recentID withKeyMessage:_keyMessage];
        [_messenger setStatusMessage:2];
        
        //update core data
    }

}

- (void) showHiddenToolkit:(BOOL)_isShow{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (_isShow) {
            [self.viewSendMessage setFrame:CGRectMake(0, self.view.bounds.size.height - heightTextField, self.view.bounds.size.width, heightTextField)];
        }else{
            [self.viewSendMessage setFrame:CGRectMake(0, self.view.bounds.size.height - heightTextField, self.view.bounds.size.width, heightTextField)];
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.viewSendMessage.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    
    [UIView animateWithDuration:0.0 animations:^{
        self.viewSendMessage.frame = r;
        [self.tbView setFrame:CGRectMake(0, self.tbView.frame.origin.y, self.tbView.bounds.size.width, self.viewSendMessage.frame.origin.y - [self getHeaderHeight])];
    }];
    
}

- (CGFloat) getHeaderHeight{
    return hHeader;
}

- (void) textViewDidChange:(UITextView *)textView{
    if ([[textView.text substringWithRange:NSMakeRange(textView.text.length - 1, 1)] isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
}

- (BOOL) growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{
    if (![self.chatToolKit.hpTextChat.text isEqualToString:@""]) {
        [self sendMessage:self.chatToolKit.hpTextChat.text];
    }
    
    return NO;
}

- (void) tapNewMessenger:(UIGestureRecognizer*)recognizer{
    [self.vNewMessage setHidden:YES];
    [self scrollToBottom];
}

- (BOOL) getStatusIsShowPanel{
    return isShowPanel;
}

- (void) btnDenyChatClick{
    [storeIns playSoundPress];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationDenyRequestChat" object:nil];
}

- (void) btnAllowChatClick{
    [storeIns playSoundPress];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationAllowRequestChat" object:nil];
}

- (void) btnBackClick:(id)sender{
    [storeIns playSoundPress];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationChatBack" object:nil];
}

- (void) tapFriendHeader{
    [storeIns playSoundPress];
    NSString *key = @"tapFriend";
    NSNumber *headerUser = [NSNumber numberWithInt:self.recentIns.recentID];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:headerUser forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tapFriendProfile" object:nil userInfo:dictionary];
}

- (void) playSoundSendMessage{
    AudioServicesPlaySystemSound(1003);
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
