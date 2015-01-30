//
//  SCFriendProfileViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/16/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCFriendProfileViewController.h"

@interface SCFriendProfileViewController ()

@end

@implementation SCFriendProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self initVariable];
        [self setup];
        [self setupUI];
    }
    
    return self;
}

- (void) initVariable{
    hHeader = 40;
    netIns = [NetworkController shareInstance];
    
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    dataMapIns = [DataMap shareInstance];
}

- (void) setup{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, hHeader)];
    [self.vHeader setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.vHeader];
    
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.view.bounds.size.width - 80, hHeader)];
    [self.lblTitle setText:@"SELECT"];
    [self.lblTitle setFont:[helperIns getFontLight:18.0f]];
    [self.lblTitle setTextColor:[UIColor whiteColor]];
    [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self.vHeader addSubview:self.lblTitle];
    
    self.btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnClose setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.btnClose setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.btnClose setFrame:CGRectMake(self.view.bounds.size.width - hHeader, 0, hHeader, hHeader)];
    [self.btnClose setTitle:@"x" forState:UIControlStateNormal];
    [self.btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnClose.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    //    [self.btnClose.titleLabel setFont:[helperIns getFontLight:20.0f]];
    [self.btnClose addTarget:self action:@selector(btnCloseTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.vHeader addSubview:self.btnClose];
    
    [self.view addSubview:self.vHeader];
}

- (void) setupUI{
    mainPage = [[MainPageV6 alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - hHeader)];
    [self.view addSubview:mainPage];
}

- (void) setFriendProfile:(Friend*)_friendProfile{
    friend = _friendProfile;
    [netIns getUserProfile:friend.friendID];
}

- (void) selectMyNoise:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    DataWall *_noise = [userInfo objectForKey:@"selectMyNoise"];
    
    NSMutableArray *items = [NSMutableArray new];
    [items addObject:_noise];
    SCSinglePostViewController *post = [[SCSinglePostViewController alloc] initWithNibName:nil bundle:nil];
    //set image to post
    [post setData:items];
    
    //call show
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:post animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectMyNoiseNotification" object:nil];
    [netIns removeListener:self];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.lblTitle setText:[friend.nickName uppercaseString]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMyNoise:) name:@"selectMyNoiseNotification" object:nil];
    [netIns addListener:self];
}

- (void) btnCloseTap:(id)sender{
    [netIns removeListener:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setResult:(NSString *)_strResult{
    NSLog(@"%@", _strResult);
    NSArray *subData = [_strResult componentsSeparatedByString:@"{"];
    if ([subData count] == 2) {
        if ([[subData objectAtIndex:0] isEqualToString: @"GETUSERPROFILE"]) {
            NSArray *subCommand = [[subData objectAtIndex:1] componentsSeparatedByString:@"}"];
            if ([subCommand count] > 1) {
                Profile *_profile = [Profile new];
                _profile.countFollower = [[subCommand objectAtIndex:1] intValue];
                _profile.countFollowing = [[subCommand objectAtIndex:2] intValue];
                _profile.countPost = [[subCommand objectAtIndex:3] intValue];
                _profile.userID = [[subCommand objectAtIndex:4] intValue];
                _profile.userName = [helperIns decode:[subCommand objectAtIndex:5]];
                _profile.firstName = [helperIns decode:[subCommand objectAtIndex:6]];
                _profile.lastName = [helperIns decode:[subCommand objectAtIndex:7]];
                _profile.thumbAvatar = [helperIns decode:[subCommand objectAtIndex:8]];
                _profile.avatar = [helperIns decode:[subCommand objectAtIndex:9]];
                _profile.birthDay = [subCommand objectAtIndex:10];
                _profile.gender = [helperIns decode:[subCommand objectAtIndex:11]];
                _profile.relationship = [helperIns decode:[subCommand objectAtIndex:12]];
                
                [mainPage initFriend:_profile];
                [mainPage.btnFollow addTarget:self action:@selector(btnFollowUserClick:) forControlEvents:UIControlEventTouchUpInside];
                
                UITapGestureRecognizer *tapFollowing = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFollowingUser)];
                [tapFollowing setNumberOfTapsRequired:1];
                [tapFollowing setNumberOfTouchesRequired:1];
                [mainPage.vFollowingUser addGestureRecognizer:tapFollowing];
                

                [netIns getUserPost:friend.friendID withCountPost:INT_MAX withClientKey:@"-1"];
                
            }
        }
        
        if ([[subData objectAtIndex:0] isEqualToString:@"GETUSERPOST"]) {
            
            NSMutableArray  *posts = [dataMapIns mapDataWall:[subData objectAtIndex:1] withType:-1];
            [mainPage setNoisesHistory:posts];
            
        }
        
    }
}

- (void) tapFollowingUser{
    NSLog(@"tap following");
}

- (void) btnFollowUserClick:(id)sender{
    NSLog(@"tap Button Follower User");
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
