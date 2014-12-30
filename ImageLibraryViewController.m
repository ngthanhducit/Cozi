//
//  ImageLibraryViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/11/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "ImageLibraryViewController.h"

@interface ImageLibraryViewController ()

@end

@implementation ImageLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) initData:(NSMutableArray*)_itemData{
    itemData = _itemData;
    
    [self initVariable];
    [self initUI];
}

- (void) initVariable{
    helperIns = [Helper shareInstance];
    
    self.itemInsets = UIEdgeInsetsMake(2.0f, 4.0f, 2.0f, 4.0f);
    self.itemSize = CGSizeMake(100, 100);
    self.interItemSpacingY = 5.0f;
    self.numberOfColumns = 3;
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor orangeColor]];
    
    [self setTitle:@"Camera Roll"];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], NSForegroundColorAttributeName,
      [helperIns getFontLight:20.0f], NSFontAttributeName,nil]];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelClick:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSaveClick:)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(onSaveClick:)];
    self.navigationItem.rightBarButtonItem = right;
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[helperIns getFontLight:20.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    SCCollectionViewLayout *layout = [[SCCollectionViewLayout alloc] initWithData:self.itemInsets withItemSize:self.itemSize withSpacingY:self.interItemSpacingY withColumns:self.numberOfColumns];
    
    self.scCollection = [[SCCollectionViewController alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    [self.scCollection initWithData:itemData withType:1];
    [self.scCollection setShowsHorizontalScrollIndicator:NO];
    [self.scCollection setShowsVerticalScrollIndicator:NO];
    [self.scCollection setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.scCollection];
}

-(void)onCancelClick:(id*)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)onSaveClick:(id*)sender{

    //Send image to server
    NSMutableArray *imageSelected = [self.scCollection getItemSelected];
    
    ImageSelected *imgSelected = [imageSelected lastObject];
    Store *storeIns = [Store shareInstance];
    
    NSURL *assetURL = (NSURL*)[[storeIns getAssetsLibrary] objectAtIndex:imgSelected.index];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        
        CGImageRef imgRef = [representation fullScreenImage];
        
        UIImage *img = [UIImage imageWithCGImage:imgRef];
        
        [self sendPhoto:img];
        
        imgRef = nil;
    } failureBlock:^(NSError *error) {
        
    }];

    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss" object:self];
    }];
}

- (void) sendPhoto:(UIImage*)img{
//    UIImage *newImage = [[UIImage alloc] init];
//    newImage = [self.helperIns resizeImage:img resizeSize:CGSizeMake(640, 1136)];
//    
//    imgDataSend = [self.helperIns compressionImage:newImage];
//    
//    NSInteger keyMessage = [self.storeIns incrementKeyMessage:self.friendIns.friendID];
//    
//    NSString *cmd = [self.dataMapIns getUploadAmazonUrl:self.friendIns.friendID withMessageKye:keyMessage];
//    [self.networkIns sendData:cmd];
//    
//    AmazonInfo *_amazonInfo = [[AmazonInfo alloc] init];
//    [_amazonInfo setKeyMessage:(int)keyMessage];
//    [_amazonInfo setImgDataSend:imgDataSend];
//    
//    [self.storeIns.sendAmazon addObject:_amazonInfo];
//    
//    UIImage *imgThum = [[UIImage alloc] init];
//    imgThum = [self.helperIns resizeImage:newImage resizeSize:CGSizeMake(320, 568)];
//    
//    Messenger *newMessage = [[Messenger alloc] init];
//    [newMessage setTypeMessage:1];
//    [newMessage setStatusMessage:0];
//    [newMessage setTimeMessage:[self.helperIns getDateFormatMessage:[NSDate date]]];
//    [newMessage setFriendID:self.friendIns.friendID];
//    [newMessage setDataImage:imgDataSend];
//    [newMessage setThumnail:imgThum];
//    [newMessage setKeySendMessage:keyMessage];
//    
//    NSString *stringImage = [self.helperIns encodedBase64:imgDataSend];
//    
//    [newMessage setStrMessage: @""];
//    [newMessage setStrImage:stringImage];
//    [newMessage setUserID:self.storeIns.user.userID];
//    
//    [self.friendIns.friendMessage addObject:newMessage];
//    
//    [self autoScrollTbView];
//    
//    [self.tbView reloadData];
    
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
