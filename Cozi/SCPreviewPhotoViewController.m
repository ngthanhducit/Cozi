//
//  SCPreviewPhotoViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/9/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCPreviewPhotoViewController.h"

@interface SCPreviewPhotoViewController ()

@end

@implementation SCPreviewPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupVariable];
    [self setupUI];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.lblTitle.text = @"EDIT PHOTO";
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void) setupVariable{
    hHeader = 40;
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
}

- (void) setupUI{
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:YES];
    
//    self.vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, hHeader)];
//    [self.vHeader setBackgroundColor:[UIColor blackColor]];
//    [self.view addSubview:self.vHeader];
//    
//    UILabel *lblSelectPhoto = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.view.bounds.size.width - 80, hHeader)];
//    [lblSelectPhoto setText:@"EDIT PHOTO"];
//    [lblSelectPhoto setFont:[helperIns getFontLight:18.0f]];
//    [lblSelectPhoto setTextColor:[UIColor whiteColor]];
//    [lblSelectPhoto setTextAlignment:NSTextAlignmentCenter];
//    [self.vHeader addSubview:lblSelectPhoto];
//    
//    self.btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.btnClose setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
//    [self.btnClose setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//    [self.btnClose setFrame:CGRectMake(self.view.bounds.size.width - hHeader, 0, hHeader, hHeader)];
//    [self.btnClose setTitle:@"x" forState:UIControlStateNormal];
//    [self.btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.btnClose.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
//    //    [self.btnClose.titleLabel setFont:[helperIns getFontLight:20.0f]];
//    [self.btnClose addTarget:self action:@selector(btnCloseTap:) forControlEvents:UIControlEventTouchUpInside];
//    [self.vHeader addSubview:self.btnClose];
    
    [self initToolkit];
    
    self.vPreviewPhoto = [[SCPhotoPreview alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.width)];
    [self.vPreviewPhoto setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.vPreviewPhoto];
    
    self.vGridLine = [[SCGridView alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.width)];
    [self.vGridLine setBackgroundColor:[UIColor clearColor]];
    [self.vGridLine setUserInteractionEnabled:NO];
    [self.view addSubview:self.vGridLine];
}

- (void) initToolkit{
    CGFloat hLibrary = (self.view.bounds.size.height - self.view.bounds.size.width) - hHeader;
    self.vTool = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100 , self.view.bounds.size.width, 100)];
    [self.vTool setBackgroundColor:[UIColor purpleColor]];
    [self.view addSubview:self.vTool];
    
    CGSize size = { self.view.bounds.size.width, self.view.bounds.size.height };
    
    TriangleView *triangleJoinNow = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleJoinNow setBackgroundColor:[UIColor whiteColor]];
    [triangleJoinNow drawTriangleSignIn];
    UIImage *imgJoinNow = [helperIns imageWithView:triangleJoinNow];
    
    self.btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSelect setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor2"]]];
    [self.btnSelect setImage:imgJoinNow forState:UIControlStateNormal];
    [self.btnSelect.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnSelect setContentMode:UIViewContentModeCenter];
    [self.btnSelect setFrame:CGRectMake(0, 0, self.vTool.bounds.size.width, self.vTool.bounds.size.height)];
    [self.btnSelect setTitle:@"EDIT PHOTO" forState:UIControlStateNormal];
    [self.btnSelect addTarget:self action:@selector(btnSelectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSelect.titleLabel setFont:[helperIns getFontLight:15.0f]];
    
    CGSize sizeTitleLable = [self.btnSelect.titleLabel.text sizeWithFont:[helperIns getFontLight:15.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.btnSelect setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgJoinNow.size.width, 0, imgJoinNow.size.width)];
    self.btnSelect.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgJoinNow.size.width, 0, -((sizeTitleLable.width) + imgJoinNow.size.width));
    
    [self.btnSelect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    [self.btnSelect setAlpha:0.8];
    [self.vTool addSubview:self.btnSelect];
}

- (void) setImagePreview:(UIImage*)_imagePreview{
    imgSelect = _imagePreview;
    [self.vPreviewPhoto setImageCycle:imgSelect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) btnCloseTap:(id)sender{
//    imgSelect = nil;
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

- (void) btnSelectPhoto:(id)sender{
    [storeIns playSoundPress];
    
    CGRect visibleRect;
    float scale = (1.0f / self.vPreviewPhoto.scrollView.zoomScale);
    visibleRect.origin.x = (self.vPreviewPhoto.scrollView.contentOffset.x * scale);
    visibleRect.origin.y = (self.vPreviewPhoto.scrollView.contentOffset.y * scale);
    visibleRect.size.width = (self.vPreviewPhoto.scrollView.bounds.size.width * scale);
    visibleRect.size.height = (self.vPreviewPhoto.scrollView.bounds.size.height * scale);
    
    UIImage *imgCrop = self.vPreviewPhoto.imgViewCapture.image;

    visibleRect.origin.y = visibleRect.origin.y * [[UIScreen mainScreen] scale];
    visibleRect.origin.x = visibleRect.origin.x * [[UIScreen mainScreen] scale];
    visibleRect.size.width = visibleRect.size.width * [[UIScreen mainScreen] scale];
    visibleRect.size.height = visibleRect.size.height * [[UIScreen mainScreen] scale];
    UIImage *afterImage = [self imageFromView:imgCrop withRect:visibleRect];
    UIImage *imgResize = [helperIns resizeImage:afterImage resizeSize:CGSizeMake(self.view.bounds.size.width * [[UIScreen mainScreen] scale], self.view.bounds.size.width * [[UIScreen mainScreen] scale])];
    NSLog(@"Resize image width: %f - height: %f", imgResize.size.width, imgResize.size.height);
    
    SCPostDetailsViewController *post = [[SCPostDetailsViewController alloc] initWithNibName:nil bundle:nil];
    [post showHiddenClose:YES];
    //set image to post
    [post setImagePost:imgResize];
    
    //call show
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];
}

- (UIImage *)imageFromView:(UIImage *)_img withRect:(CGRect)_rect{
    CGImageRef cr = CGImageCreateWithImageInRect(_img.CGImage, _rect);
    UIImage *cropped = [UIImage imageWithCGImage:cr];
    
    CGImageRelease(cr);
    return cropped;
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
