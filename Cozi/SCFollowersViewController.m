//
//  SCFollowersViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/31/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCFollowersViewController.h"

@interface SCFollowersViewController ()

@end

@implementation SCFollowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupVariable];
    
    [self setupUI];
    
}

- (void) setupVariable{
    hHeader = 40;
    netIns = [NetworkController shareInstance];
    [netIns addListener:self];
    
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
}

- (void) registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAddRemoveFollowing:) name:@"notificationAddRemoveFollowing" object:nil];
}

- (void) setupUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.waiting = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.waiting setFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - hHeader)];
    [self.view addSubview:self.waiting];
    [self.waiting startAnimating];
    
    self.tbView = [[SCFollowersTableView alloc] initWithFrame:CGRectMake(0, hHeader + hStatusBar, self.view.bounds.size.width, self.view.bounds.size.height - hHeader - hStatusBar) style:UITableViewStylePlain];
}

- (void) setFriendID:(int)_friendID{
    friendID = _friendID;
    
    [netIns getUserFollower:friendID];
}

- (void) setData:(NSMutableArray *)_dataItems{
    items = _dataItems;
    [self.view addSubview:self.tbView];
    [self.tbView setData:items];
    [self.tbView reloadData];
    [self.waiting stopAnimating];
}

- (void) setResult:(NSString *)_strResult{
    
    NSArray *subData = [_strResult componentsSeparatedByString:@"{"];
    if ([subData count] == 2) {
        
        if ([[subData objectAtIndex:0] isEqualToString:@"GETUSERFOLLOWER"]) {
            NSMutableArray *listFollowers = [NSMutableArray new];
            
            NSArray *subParameter = [[subData objectAtIndex:1] componentsSeparatedByString:@"$"];
            if ([subParameter count] > 0) {
                int count = (int)[subParameter count];
                for (int i = 0; i < count; i++) {
                    NSArray *subCommand = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                    if ([subCommand count] > 1) {
                        FollowerUser *_followerUser = [FollowerUser new];
                        _followerUser.userID = [[subCommand objectAtIndex:0] intValue];
                        _followerUser.firstName = [helperIns decode:[subCommand objectAtIndex:1]];
                        _followerUser.lastName = [helperIns decode:[subCommand objectAtIndex:2]];
                        _followerUser.urlAvatar = [helperIns decode:[subCommand objectAtIndex:3]];
                        _followerUser.urlAvatarFull = [helperIns decode:[subCommand objectAtIndex:4]];
                        
                        [listFollowers addObject:_followerUser];
                    }
                }
            }
            
            [self.view addSubview:self.tbView];
            [self.tbView setData:listFollowers];
            [self.tbView reloadData];
            [self.waiting stopAnimating];

            
            //set data
//            [self setData:listFollowers];
        }
        
        if ([[subData objectAtIndex:0] isEqualToString:@"USERADDFOLLOW"]) {
            
            inFollowing = NO;
            
            if ([[subData objectAtIndex:1] intValue] == 0) {
                [storeIns.listFollowing addObject:inFollowerUser];
                
                if (!items || [items count] == 0) {
                    [netIns getUserFollower:friendID];
                }else{
                    [self setData:storeIns.listFollower];
                }

            }
            
        }
        
        if ([[subData objectAtIndex:0] isEqualToString:@"USERREMOVEFOLLOW"]) {
            
            inFollowing = NO;
            
            if ([[subData objectAtIndex:1] intValue] == 0) {
                if (storeIns.listFollowing) {
                    int count = (int)[storeIns.listFollowing count];
                    for (int i = 0; i < count; i++) {
                        if ([[storeIns.listFollowing objectAtIndex:i] userID] == inFollowerUser.userID) {
                            [storeIns.listFollowing removeObjectAtIndex:i];
                            break;
                        }
                    }
                }
                
                if (!items || [items count] == 0) {
                    [netIns getUserFollower:friendID];
                }else{
                    [self setData:storeIns.listFollower];
                }

            }
        }
        
    }
    
}

- (void) notificationAddRemoveFollowing:(NSNotification*)notification{
    
    if (!inFollowing) {
        inFollowing = YES;
        
        NSDictionary *_infoUser = notification.userInfo;
        FollowerUser *_follower = [_infoUser valueForKey:@"followingUser"];
        inFollowerUser = _follower;
        
        BOOL isFollowing = [storeIns isFollowing:_follower.userID];
        if (isFollowing) {
            [netIns removeFollow:_follower.userID];
        }else{
            [netIns addFollow:_follower.userID];
        }
    }
    
}

- (void) removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationAddRemoveFollowing" object:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self registerNotification];
    [self.lblTitle setText:@"FOLLOWERS"];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotification];
    [netIns removeListener:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) btnCloseTap:(id)sender{
//    [self.navigationController popViewControllerAnimated:YES];
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
