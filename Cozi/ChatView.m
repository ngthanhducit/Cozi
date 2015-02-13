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
@synthesize chatToolKit;

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
        [self registerNotification];
        
        [self setup];
    }
    
    return self;
}

- (void) registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesInTableView) name:@"touchTableView" object:nil];
    
    //endDeceleration
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchEndTableView) name:@"endDeceleration" object:nil];
}

- (void) setup{
    
    self.backgroundColor = [UIColor clearColor];
    hHeader = 40;
    
    lastPhotoSelected = -1;
    self.storeIns = [Store shareInstance];
    coziCoreData = [CoziCoreData shareInstance];
    self.helperIns = [Helper shareInstance];
    self.networkIns = [NetworkCommunication shareInstance];
    self.dataMapIns = [DataMap shareInstance];
    
    vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, hHeader)];
    [vHeader setBackgroundColor:[UIColor blackColor]];
    [self addSubview:vHeader];
    
    self.lblNickName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, vHeader.bounds.size.width, vHeader.bounds.size.height)];
    [self.lblNickName setText:@"NICK NAME"];
    [self.lblNickName setTextAlignment:NSTextAlignmentCenter];
    [self.lblNickName setTextColor:[UIColor whiteColor]];
    [self.lblNickName setFont:[self.helperIns getFontLight:16.0f]];
    [vHeader addSubview:self.lblNickName];
    
    self.tbView = [[SCMessageTableViewV2 alloc] initWithFrame:self.frame style:UITableViewStylePlain];
    [self.tbView setFrame:CGRectMake(0, hHeader, self.bounds.size.width, self.bounds.size.height - 40 - heightTextField - heightToolkitNormal)];
    
    [self.tbView setScMessageTableViewDelegate:self];
    [self.tbView setContentOffset:CGPointMake(20, 0) animated:NO];
    self.tbView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeInteractive;
    [self addSubview:self.tbView];
    
    self.viewSendMessage = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - heightTextField, self.bounds.size.width, heightTextField)];
    [self addSubview:self.viewSendMessage];
    
    self.chatToolKit = [[SCChatToolKitView alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 20, self.viewSendMessage.bounds.size.height)];
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
    
    viewLibrary = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 0)];
    [viewLibrary setBackgroundColor:[UIColor whiteColor]];
    [viewLibrary setContentMode:UIViewContentModeCenter];
    [viewLibrary setClipsToBounds:YES];
    [self addSubview:viewLibrary];
    
    [self setupCamera];
}

- (void) setupCamera{
    cameraPreview = [[CameraCaptureV6 alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
    
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
}

- (void) initLibraryImage{
    
    if (scrollImageLibrary == nil) {
        
        NSMutableArray *assets = [self.storeIns getAssetsThumbnail];
        
        scrollImageLibrary = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 250)];
//        [scrollImageLibrary setDelegate:self];
//        [scrollImageLibrary setDirectionalLockEnabled:YES];
        [viewLibrary addSubview:scrollImageLibrary];
        
        [scrollImageLibrary setBackgroundColor:[UIColor clearColor]];
//        [scrollImageLibrary setShowsHorizontalScrollIndicator:YES];
//        [scrollImageLibrary setShowsVerticalScrollIndicator:YES];
        [scrollImageLibrary setBounces:YES];
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
//        [btnShowLibrary setBackgroundColor:[UIColor orangeColor]];
//        [btnShowLibrary setTitle:@"Show" forState:UIControlStateNormal];
        [btnShowLibrary setImage:[self.helperIns getImageFromSVGName:@"icon-Chat-ViewAll-V3.svg"] forState:UIControlStateNormal];
        [btnShowLibrary setClipsToBounds:YES];
        [btnShowLibrary setContentMode:UIViewContentModeScaleAspectFill];
        btnShowLibrary.layer.cornerRadius = btnShowLibrary.bounds.size.width / 2;
        [btnShowLibrary addTarget:self action:@selector(showImageLibrary:) forControlEvents:UIControlEventTouchUpInside];
        [btnShowLibrary setHidden:YES];
        [self addSubview:btnShowLibrary];
        
        [self bringSubviewToFront:btnShowLibrary];
    }
}

- (void) showImageLibrary:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowListImage" object:nil];
    
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
    
    [self hiddenToolkit];
    
    [self upChatView];
    
    [self.chatToolKit.hpTextChat becomeFirstResponder];
    
    [self.chatToolKit showTextField];
}

- (void) btnSendMessageTap:(id)sender{
    if (![self.chatToolKit.hpTextChat.text isEqualToString:@""]) {
        [self sendMessage:self.chatToolKit.hpTextChat.text];
    }
}

- (void) btnPingTap:(id)sender{
    
    //check last message if have ping and time < 5s then not send
    Messenger *_messenger = [self.friendIns.friendMessage lastObject];
    if (_messenger.userID == storeIns.user.userID) {

        NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:self.storeIns.timeServer];
//        NSDate *timeMessage = [self.helperIns convertStringToDate:[subValue objectAtIndex:3]];
        NSDate *_dateTimeMessage = [_messenger.timeServerMessage dateByAddingTimeInterval:deltaTime];
        NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:_dateTimeMessage];
        if (delta > 5) {
            [self sendMessage:@"(Ping)"];
        }
    }else{
        [self sendMessage:@"(Ping)"];
    }
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
    
    NSString *_keyMessage = [self.storeIns randomKeyMessenger];
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
        [self.viewSendMessage setFrame:CGRectMake(0, self.bounds.size.height - 200 - self.viewSendMessage.bounds.size.height, self.viewSendMessage.bounds.size.width, self.viewSendMessage.bounds.size.height)];
        [viewLibrary setFrame:CGRectMake(0, self.bounds.size.height - 200, self.bounds.size.width, 200)];
        [scrollImageLibrary setFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
        
        [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.bounds.size.width, self.bounds.size.height - [self getHeaderHeight] - viewLibrary.bounds.size.height - heightTextField)];
        
        [self scrollToBottom];
        
    } completion:^(BOOL finished) {
        isShowPanel = YES;
        
    }];
}


//chat position uitableview chat when show keyboard or toolkit content
- (void) upChatView{
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.bounds.size.width, self.bounds.size.height - [self getHeaderHeight] - viewLibrary.bounds.size.height - heightTextField)];
        
        [self scrollToBottom];
        
    } completion:^(BOOL finished) {
        isShowPanel = YES;
        
    }];
}

//rest positon uitableview chat
- (void) downChatView{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.bounds.size.width, self.bounds.size.height - [self getHeaderHeight] - heightTextField)];
        
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
            [self.viewToolKit setFrame:CGRectMake(0, 20, self.bounds.size.width, 100)];
        }else{
            [self.viewToolKit setFrame:CGRectMake(0, 20, self.bounds.size.width, 100)];
        }
        
    } completion:^(BOOL finished) {
        isShowPanel = YES;
    }];
}

- (void) hiddenToolkit{

    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        if (isShowKeyboar) {
            [viewLibrary setFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 200)];
            
            [self.viewToolKit setFrame:CGRectMake(0, 20, self.bounds.size.width, 0)];

        }else{
            [viewLibrary setFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 200)];
            
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
    
    [self.tbView reloadData];
}

- (void) reloadFriend{
    [self.hpTextChat setText:@""];
    
    [self hiddenToolkit];
}


/**1
 *  touches send message
 */
- (void) btnSendMessage{

//    if (![self.hpTextChat.text isEqualToString:@""]) {
//        [self sendMessage];
//    }
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
    
    NSString *keyMessage = [self.storeIns randomKeyMessenger];
    
    NSString *cmd = [self.dataMapIns getUploadAmazonUrl:self.friendIns.friendID withMessageKye:keyMessage withIsNotify:1];
    [self.networkIns sendData:cmd];
    
    AmazonInfo *_amazonInfo = [[AmazonInfo alloc] init];
    [_amazonInfo setKeyMessage:keyMessage];
    [_amazonInfo setImgDataSend:imgDataSend];
    
    [self.storeIns.sendAmazon addObject:_amazonInfo];
    
    Messenger *newMessage = [[Messenger alloc] init];
    [newMessage setTypeMessage:1];
    [newMessage setStatusMessage:0];
    [newMessage setTimeMessage:[self.helperIns getDateFormatMessage:[NSDate date]]];
    [newMessage setFriendID:self.friendIns.friendID];
//    [newMessage setDataImage:imgDataSend];
    [newMessage setKeySendMessage:keyMessage];
    [newMessage setStrMessage: @""];
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
    
    imgDataSend = nil;
}

- (void) sendMessage:(NSString*)_content{
    NSString *_keyMessage = [self.storeIns randomKeyMessenger];
    NSString *cmd = [self.dataMapIns sendMessageCommand:self.friendIns.friendID withKeyMessage:_keyMessage withMessage:_content withTimeout:0];
    [self.networkIns sendData:cmd];
    
    Messenger *_newMessage = [[Messenger alloc] init];
    [_newMessage setStrMessage: _content];
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
    
    self.chatToolKit.hpTextChat.text = @"";
}

#pragma -mark keyboardDelegate

- (void) keyboardWillShow:(NSNotification *)notification{
    isShowKeyboar = YES;
    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"height text chat: %f", self.chatToolKit.hpTextChat.bounds.size.height);

    CGFloat hTextChat = heightTextField < self.chatToolKit.hpTextChat.bounds.size.height ? self.chatToolKit.hpTextChat.bounds.size.height : heightTextField;
    [self.viewSendMessage setBackgroundColor:[UIColor clearColor]];
    [UIView animateWithDuration:0.1 animations:^{
        [self.viewSendMessage setFrame:CGRectMake(0, self.bounds.size.height - kbSize.height - hTextChat - 2, self.bounds.size.width, hTextChat)];
        
        [self.chatToolKit.hpTextChat setFrame:CGRectMake(0, 0, self.chatToolKit.hpTextChat.bounds.size.width, self.chatToolKit.hpTextChat.bounds.size.height)];
        
        [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.bounds.size.width, self.frame.size.height - kbSize.height - [self getHeaderHeight] - hTextChat - 2)];
        
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
        
        [self.viewSendMessage setFrame:CGRectMake(0, self.bounds.size.height - heightTextField, self.viewSendMessage.bounds.size.width, heightTextField)];
        
        [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.bounds.size.width, self.bounds.size.height - [self getHeaderHeight] - heightTextField)];
        
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

- (void) resetUI{
    [self endEditing:YES];
    [self hiddenToolkit];
    
    [self.tbView setFrame:CGRectMake(0, [self getHeaderHeight], self.bounds.size.width, self.bounds.size.height - [self getHeaderHeight] - heightTextField)];
    
    [self.chatToolKit reset];
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.viewSendMessage setFrame:CGRectMake(0, self.bounds.size.height - heightTextField, self.bounds.size.width, heightTextField)];
    
    } completion:^(BOOL finished) {
        
    }];
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

/**
 *  Reset default camera
 */
- (void) resetCamera{

    [cameraPreview closeImage];
    [lblCancelSend setHidden:YES];
    [lblSendPhoto setHidden:YES];
    
    [lblTapTakePhoto setHidden:YES];
    [lblChangeCamera setHidden:YES];
    
    [cameraPreview switchCamera:NO];
    
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

#pragma -mark SCMessageTableView Delegate
- (void) sendIsReadMessage:(int)_friendID withKeyMessage:(NSString*)_keyMessage withTypeMessage:(int)_typeMessage{
    
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

- (void) showHiddenToolkit:(BOOL)_isShow{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (_isShow) {
            [self.viewSendMessage setFrame:CGRectMake(0, self.bounds.size.height - heightTextField, self.bounds.size.width, heightTextField)];
        }else{
            [self.viewSendMessage setFrame:CGRectMake(0, self.bounds.size.height - heightTextField, self.bounds.size.width, heightTextField)];
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
@end
