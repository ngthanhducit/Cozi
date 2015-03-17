//
//  SCFriendRequestViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/12/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCFriendRequestViewController.h"

@interface SCFriendRequestViewController ()

@end

@implementation SCFriendRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupVariable];
    [self setupUI];
}

- (void) setupVariable{
    netIns = [NetworkController shareInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnDenyAddFriendNotification:) name:@"notificationDenyAddFriend" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnAcceptAddFriendNotification:) name:@"notificationAcceptAddFriend" object:nil];
}

- (void) setupUI{
    tbFriendRequest = [[SCFriendRequestTableView alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - (hHeader)) style:UITableViewStylePlain];
    [tbFriendRequest setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive | UIScrollViewKeyboardDismissModeOnDrag];
    [tbFriendRequest initData:storeIns.friendsRequest];
    [self.view addSubview:tbFriendRequest];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.lblTitle setText:@"FRIEND REQUESTS"];
    
    [netIns addListener:self];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [netIns removeListener:self];
}

- (void) btnDenyAddFriendNotification:(NSNotification*)notification{
    NSDictionary *_userInfo = notification.userInfo;
    friendRequest = [_userInfo valueForKey:@"DenyAddFriend"];

    [netIns acceptOrDenyAddFriend:friendRequest.friendID withIsAllow:0];
}

- (void) btnAcceptAddFriendNotification:(NSNotification*)notification{
    NSDictionary *_userInfo = notification.userInfo;
    friendRequest = [_userInfo valueForKey:@"AcceptAddFriend"];
    
    [netIns acceptOrDenyAddFriend:friendRequest.friendID withIsAllow:1];
}

- (void) setResult:(NSString *)_strResult{
    _strResult = [_strResult stringByReplacingOccurrencesOfString:@"<EOF>" withString:@""];
    NSArray *subData = [_strResult componentsSeparatedByString:@"{"];
    
    if ([subData count] == 2) {
        if ([[subData objectAtIndex:0] isEqualToString:@"RECEIVEFRIENDREQUEST"]) {
            
            if ([[subData objectAtIndex:1] isEqualToString:@"0"]) {

                [netIns getUserProfile:friendRequest.friendID];
                
                [storeIns removeFriendRequest:friendRequest.friendID];
                
                [tbFriendRequest reloadData];

            }
            
        }
        
        if ([[subData objectAtIndex:0] isEqualToString:@"GETUSERPROFILE"]) {
            
            NSArray *subCommand = [[subData objectAtIndex:1] componentsSeparatedByString:@"}"];
            if ([subCommand count] > 1) {
                Friend *_friend = [Friend new];

                _friend.userID = storeIns.user.userID;
                _friend.friendID = [[subCommand objectAtIndex:4] intValue];

                _friend.userName = [helperIns decode:[subCommand objectAtIndex:5]];
                _friend.firstName = [helperIns decode:[subCommand objectAtIndex:6]];
                _friend.lastName = [helperIns decode:[subCommand objectAtIndex:7]];
                _friend.nickName = [NSString stringWithFormat:@"%@ %@",_friend.firstName, _friend.lastName];
                _friend.urlThumbnail = [helperIns decode:[subCommand objectAtIndex:8]];
                _friend.urlAvatar = [helperIns decode:[subCommand objectAtIndex:9]];
                _friend.birthDay = [subCommand objectAtIndex:10];
                _friend.gender = [helperIns decode:[subCommand objectAtIndex:11]];
                _friend.relationship = [helperIns decode:[subCommand objectAtIndex:12]];
                [_friend setStatusAddFriend:0];
                
                [storeIns.friends addObject:_friend];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationReloadListFriend" object:nil userInfo:nil];
                
                CoziCoreData *cz = [CoziCoreData shareInstance];
                
                [cz saveFriend:_friend];
            }
            
        }
    }
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
