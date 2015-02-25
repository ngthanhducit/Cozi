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
    [self setupVariable];
    [self setupUI];
}

- (void) setupVariable{
    hHeader = 40;
    netIns = [NetworkController shareInstance];

    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    dataMapIns = [DataMap shareInstance];
}

- (void) setupUI{
    mainPage = [[MainPageV6 alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - hHeader)];
    [self.view addSubview:mainPage];
}

- (void) setFriendProfile:(Friend*)_friendProfile{
//    friend = _friendProfile;
//    [netIns getUserProfile:friend.friendID];
}

- (void) setFriendId:(int)_friendID{
    friendID = _friendID;
    [netIns getUserProfile:friendID];
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
    
    [netIns removeListener:self];
}

- (void) tapFollowers:(NSNotification*)notification{
    NSLog(@"tap Followers");
    followers = [[SCFollowersViewController alloc] initWithNibName:nil bundle:nil];
    [followers showHiddenClose:YES];
    [followers setFriendID:friendID];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:followers animated:YES];
}

- (void) tapFollowing:(NSNotification*)notification{
    NSLog(@"tap Following");
    following = [[SCFollowingViewController alloc] initWithNibName:nil bundle:nil];
    [following showHiddenClose:YES];
    [following setFriendID:friendID];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:following animated:YES];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self.lblTitle setText:[friend.nickName uppercaseString]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMyNoise:) name:@"selectMyNoiseNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapFollowers:) name:@"notificationTapFollowers" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapFollowing:) name:@"notificationTapFollowing" object:nil];
    [netIns addListener:self];
}

- (void) removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectMyNoiseNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationTapFollowers" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationTapFollowing" object:nil];
}

//- (void) btnCloseTap:(id)sender{
//    [netIns removeListener:self];
//    [self removeNotification];
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//}

- (void) setResult:(NSString *)_strResult{
    
    NSArray *subData = [_strResult componentsSeparatedByString:@"{"];
    if ([subData count] == 2) {
        if ([[subData objectAtIndex:0] isEqualToString: @"GETUSERPROFILE"]) {
            NSArray *subCommand = [[subData objectAtIndex:1] componentsSeparatedByString:@"}"];
            if ([subCommand count] > 1) {
                Profile *_profile = [Profile new];
                _profile.isPublic = [[subCommand objectAtIndex:0] boolValue];
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
                
                profile = _profile;
                
                [mainPage initFriend:_profile];
                [mainPage.btnFollow addTarget:self action:@selector(btnFollowUserClick:) forControlEvents:UIControlEventTouchUpInside];
                
                UITapGestureRecognizer *tapFollowing = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFollowingUser)];
                [tapFollowing setNumberOfTapsRequired:1];
                [tapFollowing setNumberOfTouchesRequired:1];
                [mainPage.vFollowingUser addGestureRecognizer:tapFollowing];
                
                [self.lblTitle setText:[[NSString stringWithFormat:@"%@ %@", _profile.firstName, _profile.lastName] uppercaseString]];
                
                [netIns getUserPost:friendID withCountPost:INT_MAX withClientKey:@"-1"];
                
            }
        }
        
        if ([[subData objectAtIndex:0] isEqualToString:@"GETUSERPOST"]) {
            
            NSMutableArray  *posts = [dataMapIns mapDataWall:[subData objectAtIndex:1] withType:-1];
            NSMutableArray *_listHistory = [NSMutableArray new];
            if (posts) {
                int count = (int)[posts count];
                for (int i = 0; i < count; i++) {
                    if ([[posts objectAtIndex:i] codeType] != 0) {
                        [_listHistory addObject:[posts objectAtIndex:i]];
                    }
                }
            }
            
            [mainPage setNoisesHistory:_listHistory];
            
        }
        
        if ([[subData objectAtIndex:0] isEqualToString:@"USERADDFOLLOW"]) {
            inFollowing = NO;
            if ([[subData objectAtIndex:1] intValue] == 0) {
                [mainPage.waitingFollow stopAnimating];
                FollowerUser *follower = [FollowerUser new];
                [follower setUserID:profile.userID];
                [follower setParentUserID:storeIns.user.userID];
                [follower setFirstName:profile.firstName];
                [follower setLastName:profile.lastName];
                [follower setUrlAvatar:profile.thumbAvatar];
                [follower setUrlAvatarFull:profile.avatar];
                
                [storeIns.listFollowing addObject:follower];
                
                [mainPage initViewFollowing];
                
                UITapGestureRecognizer *tapFollowing = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFollowingUser)];
                [tapFollowing setNumberOfTapsRequired:1];
                [tapFollowing setNumberOfTouchesRequired:1];
                [mainPage.vFollowingUser addGestureRecognizer:tapFollowing];

            }else{
                [mainPage.waitingFollow stopAnimating];
                [mainPage.btnFollow setHidden:NO];
            }
            
        }
        
        if ([[subData objectAtIndex:0] isEqualToString:@"USERREMOVEFOLLOW"]) {
            inFollowing = NO;
            if ([[subData objectAtIndex:1] intValue] == 0) {
                [mainPage.waitingFollow stopAnimating];
                if (storeIns.listFollowing) {
                    int count = (int)[storeIns.listFollowing count];
                    for (int i = 0; i < count; i++) {
                        if ([[storeIns.listFollowing objectAtIndex:i] userID] == profile.userID) {
                            [storeIns.listFollowing removeObjectAtIndex:i];
                            break;
                        }
                    }
                }
               
                [mainPage initButtonFollowUser];
                
                [mainPage.btnFollow addTarget:self action:@selector(btnFollowUserClick:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [mainPage.waitingFollow stopAnimating];
                [mainPage.vFollowingUser setHidden:NO];
            }
        }
        
    }
}

- (void) tapFollowingUser{
    [mainPage.vFollowingUser setHidden:YES];
    [mainPage.waitingFollow startAnimating];
    [netIns removeFollow:profile.userID];
    
//    BOOL isFollowing = [storeIns isFollowing:profile.userID];
//    if (isFollowing) {
//
//    }else{
//        [netIns addFollow:profile.userID];
//    }
    
}

- (void) btnFollowUserClick:(id)sender{

    [mainPage.btnFollow setHidden:YES];
    [mainPage.waitingFollow startAnimating];
    [netIns addFollow:profile.userID];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [netIns removeListener:self];
    [self removeNotification];
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
