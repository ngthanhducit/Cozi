//
//  SCProfileViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/15/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCProfileViewController.h"

@interface SCProfileViewController ()

@end

@implementation SCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self setupVariable];
//        [self setup];
        [self setupUI];
    }
    
    return self;
}

- (void) setupVariable{
    hHeader = 40;
    netIns = [NetworkController shareInstance];
    [netIns addListener:self];
    
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
}

//- (void) setup{
//    [self.view setBackgroundColor:[UIColor whiteColor]];
//    [self.navigationController setNavigationBarHidden:YES];
//    
//    self.vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, hHeader)];
//    [self.vHeader setBackgroundColor:[UIColor blackColor]];
//    [self.view addSubview:self.vHeader];
//    
//    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.view.bounds.size.width - 80, hHeader)];
//    [self.lblTitle setText:@"SELECT"];
//    [self.lblTitle setFont:[helperIns getFontLight:18.0f]];
//    [self.lblTitle setTextColor:[UIColor whiteColor]];
//    [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
//    [self.vHeader addSubview:self.lblTitle];
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
//    
//    [self.view addSubview:self.vHeader];
//}

- (void) setupUI{
    mainPage = [[MainPageV6 alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - hHeader)];
    [self.view addSubview:mainPage];
}

- (void) setProfile:(User*)_myProfile{
    my = _myProfile;
    [mainPage initUser:my];
    [mainPage setNoisesHistory:storeIns.listHistoryPost];
}

- (void) selectMyNoise:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    DataWall *_noise = [userInfo objectForKey:@"selectMyNoise"];
    
    NSMutableArray *items = [NSMutableArray new];
    [items addObject:_noise];
    SCSinglePostViewController *post = [[SCSinglePostViewController alloc] initWithNibName:nil bundle:nil];
    [post showHiddenClose:YES];
    //set image to post
    [post setData:items];
    
    //call show
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];
    
    [self removeNotification];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.lblTitle setText:[my.nickName uppercaseString]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMyNoise:) name:@"selectMyNoiseNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapFollowers:) name:@"notificationTapFollowers" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapFollowing:) name:@"notificationTapFollowing" object:nil];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self removeNotification];
}

- (void) tapFollowers:(NSNotification*)notification{
    NSLog(@"tap Followers");
    SCFollowersViewController *post = [[SCFollowersViewController alloc] initWithNibName:nil bundle:nil];
    [post showHiddenClose:YES];
    [post setData:storeIns.listFollower];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];
}

- (void) tapFollowing:(NSNotification*)notification{
    NSLog(@"tap Following");
    SCFollowingViewController *post = [[SCFollowingViewController alloc] init];
    [post showHiddenClose:YES];
    [post setData:storeIns.listFollowing];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];
}

//- (void) btnCloseTap:(id)sender{
//    [self removeNotification];
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void) removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectMyNoiseNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationTapFollowers" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationTapFollowing" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setResult:(NSString *)_strResult{
    
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
