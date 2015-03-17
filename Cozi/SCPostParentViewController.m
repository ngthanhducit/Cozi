//
//  SCPostParentViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/13/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCPostParentViewController.h"

@interface SCPostParentViewController ()

@end

@implementation SCPostParentViewController

@synthesize lblTitle;
@synthesize btnClose;
@synthesize vHeader;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self initVariable];
        [self setup];
        
    }
    
    return self;
}


- (void) initVariable{
    hHeader = 40;
    hStatusBar = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
}

- (void) setup{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat hStatus = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, hStatus)];
    statusBarView.backgroundColor = [helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor2"]];
    [self.view addSubview:statusBarView];
    
    self.vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, hStatusBar, self.view.bounds.size.width, hHeader)];
    [self.vHeader setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor2"]]];
    [self.view addSubview:self.vHeader];
    
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.view.bounds.size.width - 80, hHeader)];
    [self.lblTitle setText:@"SELECT"];
    [self.lblTitle setFont:[helperIns getFontLight:18.0f]];
    [self.lblTitle setTextColor:[UIColor whiteColor]];
    [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self.vHeader addSubview:self.lblTitle];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnBack setFrame:CGRectMake(0, 0, hHeader, hHeader)];
    [self.btnBack setImage:[helperIns getImageFromSVGName:@"icon-backarrow-25px-V2.svg"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(btnBackTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.vHeader addSubview:self.btnBack];
    
    self.btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnClose setFrame:CGRectMake(self.view.bounds.size.width - hHeader, 0, hHeader, hHeader)];
    [self.btnClose setImage:[helperIns getImageFromSVGName:@"icon-cross-25px.svg"] forState:UIControlStateNormal];
    [self.btnClose addTarget:self action:@selector(btnCloseTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.vHeader addSubview:self.btnClose];
    
    [self.view addSubview:self.vHeader];
}

- (void) btnBackTap:(id)sender{
    [storeIns playSoundPress];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) btnCloseTap:(id)sender{
    [storeIns playSoundPress];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) showHiddenClose:(BOOL)_isShow{
    [self.btnClose setHidden:_isShow];
}

- (void) showHiddenBack:(BOOL)_isShow{
    [self.btnBack setHidden:_isShow];
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
