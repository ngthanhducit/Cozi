//
//  SCPhotoLibraryViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/3/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCPhotoLibraryViewController.h"

@interface SCPhotoLibraryViewController ()

@end

@implementation SCPhotoLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void) initUI{
    [self.view setBackgroundColor:[UIColor orangeColor]];
    
    storeIns = [Store shareInstance];
    
    [self setTitle:@"Camera Roll"];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], NSForegroundColorAttributeName,
      [helperIns getFontLight:20.0f], NSFontAttributeName,nil]];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelClick:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleDone target:self action:@selector(onSaveClick:)];
    self.navigationItem.rightBarButtonItem = right;
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[helperIns getFontLight:20.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.itemInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    self.itemSize = CGSizeMake(100.0f, 100.0f);
    self.interItemSpacingY = 5.0f;
    self.numberOfColumns = 3;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPostPhoto:) name:@"POSTPHOTOSELECT" object:nil];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.vLibrary = [[UIView alloc] initWithFrame:CGRectMake(0, 40 , self.view.bounds.size.width, self.view.bounds.size.height - 40)];
    [self.vLibrary setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.vLibrary];
    
    [self initLibraryImage];
    
}

- (void) initLibraryImage{
    
    SCPhotoCollectionViewLayout *layout = [[SCPhotoCollectionViewLayout alloc] initWithData:self.itemInsets withItemSize:self.itemSize withSpacingY:self.interItemSpacingY withColumns:3];
    
    self.scPhotoCollectionView = [[SCPhotoCollectionView alloc] initWithFrame: CGRectMake(0, 0, self.vLibrary.bounds.size.width, self.vLibrary.bounds.size.height) collectionViewLayout:layout];
    
    [self.scPhotoCollectionView setShowsHorizontalScrollIndicator:NO];
    [self.scPhotoCollectionView setShowsVerticalScrollIndicator:NO];
    [self.scPhotoCollectionView setBackgroundColor:[UIColor clearColor]];
    [self.vLibrary addSubview:self.scPhotoCollectionView];
}

- (void) getFullImageAssets:(int)index{
    
    NSURL *assetURL = (NSURL*)[[storeIns getAssetsLibrary] objectAtIndex:index];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc(rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//this is NSData may be what you want
        UIImage *img = [UIImage imageWithData:data];
        
        img = nil;
        //        imgRef = nil;
    } failureBlock:^(NSError *error) {
        
    }];
    
}

- (void) selectPostPhoto:(NSNotification*)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *numberSelect = (NSNumber*)[userInfo objectForKey:@"tapPhotoPost"];
    
    [self getFullImageAssets:[numberSelect intValue]];
    
}

-(void)onCancelClick:(id*)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)onSaveClick:(id*)sender{
    
    //    //Send image to server
//    NSMutableArray *imageSelected = [self.scCollection getItemSelected];
    //
    //    ImageSelected *imgSelected = [imageSelected lastObject];
    //    Store *storeIns = [Store shareInstance];
    //
    //    NSURL *assetURL = (NSURL*)[[storeIns getAssetsLibrary] objectAtIndex:imgSelected.index];
    //
    //    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    //    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
    //
    //        ALAssetRepresentation *representation = [asset defaultRepresentation];
    //
    //        CGImageRef imgRef = [representation fullScreenImage];
    //
    //        UIImage *img = [UIImage imageWithCGImage:imgRef];
    //
    //        [self sendPhoto:img];
    //
    //        imgRef = nil;
    //    } failureBlock:^(NSError *error) {
    //
    //    }];
    //
    //
    
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:imageSelected forKey:@"ImagePost"];
    
    [self dismissViewControllerAnimated:YES completion:^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissImageLibrary" object:nil userInfo:dic];
    }];
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
