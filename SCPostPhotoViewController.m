//
//  SCPostPhotoViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/8/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCPostPhotoViewController.h"

@interface SCPostPhotoViewController ()

@end

@implementation SCPostPhotoViewController

@synthesize vHeader;
@synthesize vLibrary;
@synthesize scPhotoCollectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.lblTitle setText:@"SELECT PHOTO"];
    
    if (self.scPhotoCollectionView) {
        [self.scPhotoCollectionView reloadData];
    }
}

- (void) initUI{
    assetsThumbnail = [NSMutableArray new];
    urlAssetsImage = [NSMutableArray new];
    
    self.itemInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    self.itemSize = CGSizeMake(100.0f, 100.0f);
    self.interItemSpacingY = 5.0f;
    self.numberOfColumns = 3;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPostPhoto:) name:@"POSTPHOTOSELECT" object:nil];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.lblTitle setText:@"SELECT PHOTO"];
    
    self.vLibrary = [[UIView alloc] initWithFrame:CGRectMake(0, hHeader , self.view.bounds.size.width, self.view.bounds.size.height - hHeader)];
    [self.vLibrary setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.vLibrary];
    
//    [self initLibraryImage];
    
    waiting = [[SCActivityIndicatorView alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - hHeader)];
    [waiting setText:@"Loading..."];
    [self.view addSubview:waiting];
    
    [self loadAssets];
    
}

-(void) loadAssets{
    
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
    
    SCPhotoCollectionViewLayout *layout = [[SCPhotoCollectionViewLayout alloc] initWithData:self.itemInsets withItemSize:self.itemSize withSpacingY:self.interItemSpacingY withColumns:3];
    
    self.scPhotoCollectionView = [[SCPhotoCollectionView alloc] initWithFrame: CGRectMake(0, 0, self.vLibrary.bounds.size.width, self.vLibrary.bounds.size.height) collectionViewLayout:layout];
    [self.scPhotoCollectionView initData:assetsThumbnail];
    [self.scPhotoCollectionView setShowsHorizontalScrollIndicator:NO];
    [self.scPhotoCollectionView setShowsVerticalScrollIndicator:NO];
    [self.scPhotoCollectionView setBackgroundColor:[UIColor clearColor]];
    [self.vLibrary addSubview:self.scPhotoCollectionView];
    
    [waiting removeFromSuperview];
}

- (void) getFullImageAssets:(int)index{
    
//    NSURL *assetURL = (NSURL*)[[storeIns getAssetsLibrary] objectAtIndex:index];
    NSURL *assetURL = (NSURL*)[urlAssetsImage objectAtIndex:index];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc(rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//this is NSData may be what you want
        UIImage *img = [UIImage imageWithData:data];
        
//        ALAssetRepresentation *representation = [asset defaultRepresentation];
//        
//        CGImageRef imgRef = [representation fullScreenImage];
//        
//        UIImage *img = [UIImage imageWithCGImage:imgRef];
        
        SCPreviewPhotoViewController *post = [[SCPreviewPhotoViewController alloc] initWithNibName:nil bundle:nil];
        [post showHiddenClose:YES];
        //set image to post
        [post setImagePreview:img];
        
        //call show
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController pushViewController:post animated:YES];
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) btnCloseTap:(id)sender{
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
