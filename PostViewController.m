//
//  PostViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/19/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "PostViewController.h"

@implementation PostViewController

- (void) setup{
    [self initVariable];
    [self initUI];
}

- (void) initVariable{
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    networkIns = [NetworkCommunication shareInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectImage:) name:@"dismissImageLibrary" object:nil];
}

-(void)initUI{
    waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    waitingView.center = CGPointMake(self.view.center.x, self.view.center.y);
    [self.view addSubview:waitingView];
    
    [self.view setBackgroundColor:[UIColor orangeColor]];
    [self.view setUserInteractionEnabled:YES];
    
    [self setTitle:@"POST TO WALL"];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], NSForegroundColorAttributeName,
      [helperIns getFontLight:20.0f], NSFontAttributeName,nil]];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelClick:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(onPostClick:)];
    self.navigationItem.rightBarButtonItem = right;
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[helperIns getFontLight:20.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 50)];
    [header setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:header];
    
    mainScroll  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 94, self.view.bounds.size.width, self.view.bounds.size.height - 94)];
    [mainScroll setBackgroundColor:[UIColor brownColor]];
    [mainScroll setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [mainScroll setUserInteractionEnabled:YES];
    [mainScroll setDelegate:self];
    [self.view addSubview:mainScroll];
    
    myAvatar = [[UIImageView alloc] initWithImage:storeIns.user.thumbnail];
    [myAvatar setFrame:CGRectMake(20, 20, 50, 50)];
    [mainScroll addSubview:myAvatar];
    
    txtStatus = [[UITextView alloc] initWithFrame:CGRectMake(80, 20, self.view.bounds.size.width - 100, 30)];
    [mainScroll addSubview:txtStatus];
    
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 50)];
    [bottom setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:bottom];
    
    btnAddPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAddPhoto setTitle:@"P" forState:UIControlStateNormal];
    [btnAddPhoto setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btnAddPhoto setBackgroundColor:[UIColor blackColor]];
    [btnAddPhoto setFrame:CGRectMake(10, 10, 50, 30)];
    [btnAddPhoto addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:btnAddPhoto];
    
    btnAddVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAddVideo setTitle:@"V" forState:UIControlStateNormal];
    [btnAddVideo setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btnAddVideo setBackgroundColor:[UIColor blackColor]];
    [btnAddVideo setFrame:CGRectMake(100, 10, 50, 30)];
    [bottom addSubview:btnAddVideo];
    
    btnAddLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAddLocation setTitle:@"L" forState:UIControlStateNormal];
    [btnAddLocation setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btnAddLocation setBackgroundColor:[UIColor blackColor]];
    [btnAddLocation setFrame:CGRectMake(160, 10, 50, 30)];
    [bottom addSubview:btnAddLocation];
}

-(void)onCancelClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) onPostClick:(id)sender{
    
    //Post Wall
    [self.view endEditing:YES];

    [waitingView startAnimating];
    
    [networkIns sendData:@"GETUPLOADPOSTURL{<EOF>"];
}

- (void) addPhoto{
    
    SCImageController *imgLibraryView = [[SCImageController alloc] init];
    [imgLibraryView initData:[storeIns getAssetsThumbnail]];
    UINavigationController  *naviController = [[UINavigationController alloc] initWithRootViewController:imgLibraryView];
    [naviController setModalPresentationStyle:UIModalPresentationFormSheet];
    [naviController setDelegate:self];
    
    [self presentViewController:naviController animated:YES completion:^{
        
    }];
    
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)selectImage:(NSNotification*)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSMutableArray *_imgSelected  = (NSMutableArray*)[userInfo objectForKey:@"ImagePost"];

    if (_imgSelected != nil) {
        int count = (int)[_imgSelected count];
        __block int index = 0;
        for (int i = 0; i < count; i++) {
            
            ImageSelected *img = [_imgSelected objectAtIndex:i];
            
            NSURL *assetURL = (NSURL*)[[storeIns getAssetsLibrary] objectAtIndex:img.index];
            
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                
                ALAssetRepresentation *representation = [asset defaultRepresentation];
                
                CGImageRef imgRef = [representation fullScreenImage];
                
                UIImage *img = [UIImage imageWithCGImage:imgRef];
                UIImage *imgResize = [helperIns resizeImage:img resizeSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width)];
                
                UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(10, 100 + (index * (self.view.bounds.size.width + 20)), self.view.bounds.size.width - 20, self.view.bounds.size.width)];
                [temp setBackgroundColor:[UIColor grayColor]];
                
                UIImageView *imgView = [[UIImageView alloc] initWithImage:imgResize];
                [imgView setContentMode:UIViewContentModeScaleAspectFill];
                [imgView setAutoresizingMask:UIViewAutoresizingNone];
                [imgView setClipsToBounds:YES];
                [imgView setFrame:CGRectMake(0, 0, self.view.bounds.size.width - 20, self.view.bounds.size.width)];
                [temp addSubview:imgView];
                
                [mainScroll addSubview:temp];

                [mainScroll setContentSize:CGSizeMake(mainScroll.contentSize.width, mainScroll.contentSize.height + self.view.bounds.size.width)];
                
                lastImage = imgResize;
                
                imgRef = nil;
                
                index++;
                
            } failureBlock:^(NSError *error) {
                
            }];
            
        }
    }
    
}

- (void) setAmazoneUpload:(AmazonInfo *)_amazon{
    
    amazonInfomation = _amazon;
    int code = [self uploadAvatarAmazon:_amazon withImage:UIImageJPEGRepresentation(lastImage, 1)];
    
    //SEND CODE UPload PHOTO
    [networkIns sendData:[NSString stringWithFormat:@"RESULTUPLOADPOSTIMAGE{%i<EOF>", code]];
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

- (void) setResultUpload:(int)_result{
    
    //check code
    if (_result == 0) {
        //add to wall
        NSString *contentEncode = [helperIns encodedBase64:[txtStatus.text dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *imageEncode = [helperIns encodedBase64:[amazonInfomation.key dataUsingEncoding:NSUTF8StringEncoding]];
        _clientKeyID = [storeIns incrementKeyMessage:0];
        NSString *tempClientKey = [helperIns encodedBase64:[[NSString stringWithFormat:@"%i", (int)_clientKeyID] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *cmd = [NSString stringWithFormat:@"ADDPOST{%@}%@}%@}%@}%@<EOF>", contentEncode, imageEncode, @"", @"", tempClientKey];
        
        [networkIns sendData:cmd];
        
    }else{
        
        //Error upload phot try again and up wall
        
    }
    
}

- (void) setResultAddWall:(NSString*)_strResult{
    
    [waitingView stopAnimating];
    
    NSArray *subCommand = [_strResult componentsSeparatedByString:@"}"];
    if ([subCommand count] == 2) {
        NSInteger key = [[subCommand objectAtIndex:1] integerValue];
        if (key > 0) {
//            [networkIns sendData:@"GETWALL{<EOF>"];
            
//            [networkIns sendData:@"GETNOISE{<EOF>"];
//            DataWall *_newWall = [DataWall new];
//            _newWall.userPostID = storeIns.user.userID;
//            _newWall.content = txtStatus.text;
//            _newWall.images = [NSMutableArray new];
//            [_newWall.images addObject:lastImage];
//            _newWall.video = @"";
//            _newWall.longitude = @"";
//            _newWall.latitude = @"";
//            _newWall.time = @"";
//            _newWall.clientKey = [NSString stringWithFormat:@"%i", (int)_clientKeyID];
//            
//            [storeIns addWallData:_newWall];
//            
//            Wall *_wall = [Wall new];
//            
//            NSData *dataImg = UIImageJPEGRepresentation(lastImage, 1);
//            NSData *wallData = UIImageJPEGRepresentation(storeIns.user.thumbnail, 1);
//            
//            [_wall insertWallItem:dataImg avatar:wallData withFullName:storeIns.user.nickName itemId:key];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (DataWall*) getWall{
    
    DataWall *_newWall = [DataWall new];
    _newWall.userPostID = storeIns.user.userID;
    _newWall.content = txtStatus.text;
    _newWall.images = [NSMutableArray new];
    [_newWall.images addObject:lastImage];
    _newWall.video = @"";
    _newWall.longitude = @"";
    _newWall.latitude = @"";
    _newWall.time = @"";
    _newWall.clientKey = [NSString stringWithFormat:@"%i", (int)_clientKeyID];

    return _newWall;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
