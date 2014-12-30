//
//  SCImageController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 12/21/14.
//  Copyright (c) 2014 ChjpCoj. All rights reserved.
//

#import "SCImageController.h"

@implementation SCImageController

@synthesize itemInsets;
@synthesize itemSize;
@synthesize interItemSpacingY;
@synthesize numberOfColumns;

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
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(onSaveClick:)];
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
    
//    //Send image to server
    NSMutableArray *imageSelected = [self.scCollection getItemSelected];
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

    NSDictionary *dic = [NSDictionary dictionaryWithObject:imageSelected forKey:@"ImagePost"];
    
    [self dismissViewControllerAnimated:YES completion:^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissImageLibrary" object:nil userInfo:dic];
    }];
}

@end
