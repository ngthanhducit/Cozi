//
//  SCSearchFriendViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/11/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCSearchFriendViewController.h"

@interface SCSearchFriendViewController ()

@end

@implementation SCSearchFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupVariable];
    [self setupUI];
}

- (void) setupVariable{
    netIns = [NetworkController shareInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnAddFriendNotification:) name:@"notificationAddFriend" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) setupUI{
    scSearchFriend = [[SCSearchBar alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, 39)];
    [scSearchFriend setPlaceholder:@"SEARCH NAME / NUMBER / EMAIL"];
    [scSearchFriend setBackgroundColor:[UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f]];
    [scSearchFriend setTintColor:[UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f]];
    [scSearchFriend setKeyboardAppearance:UIKeyboardAppearanceDark];
    [scSearchFriend setReturnKeyType:UIReturnKeySearch];
    [scSearchFriend setDelegate:self];
    [self.view addSubview:scSearchFriend];
    
    CALayer *bottomSearch = [CALayer layer];
    [bottomSearch setFrame:CGRectMake(0.0f, 39.5, self.view.bounds.size.width, 0.5f)];
    [bottomSearch setBackgroundColor:[UIColor whiteColor].CGColor];
    [self.view.layer addSublayer:bottomSearch];
    
    tbSearchFriend = [[SCSearchFriendTableView alloc] initWithFrame:CGRectMake(0, hHeader + scSearchFriend.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - (hHeader + scSearchFriend.bounds.size.height)) style:UITableViewStylePlain];
    [tbSearchFriend setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeInteractive];
    [self.view addSubview:tbSearchFriend];
    
    vBlur = [[UIView alloc] initWithFrame:CGRectMake(0, hHeader + scSearchFriend.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - (hHeader + scSearchFriend.bounds.size.height))];
    [vBlur setUserInteractionEnabled:YES];
    [vBlur setBackgroundColor:[UIColor blackColor]];
    [vBlur setAlpha:0.6];
    [vBlur setHidden:YES];
    [self.view addSubview:vBlur];
    
    waiting = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [waiting setFrame:CGRectMake(0, hHeader + scSearchFriend.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - (hHeader + scSearchFriend.bounds.size.height))];
    [waiting setBackgroundColor:[UIColor blackColor]];
    [waiting setAlpha:0.6];
    [self.view addSubview:waiting];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.lblTitle setText:@"SEARCH FOR FRIENDS"];
    
    [netIns addListener:self];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [netIns removeListener:self];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.view == vBlur) {
        [self.view endEditing:YES];
    }
}

#pragma -mark keyboardDelegate

- (void) keyboardWillShow:(NSNotification *)notification{
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [vBlur setHidden:NO];
    } completion:^(BOOL finished) {
        
    }];
}

- (void) keyboardWillBeHidden:(NSNotification*)aNotification{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [vBlur setHidden:YES];
    } completion:^(BOOL finished) {
        
    }];
}

- (void) btnAddFriendNotification:(NSNotification*)notification{
    NSDictionary *_userInfo = notification.userInfo;
    userSearch = [_userInfo valueForKey:@"addFriend"];
    
    NSString *digit = [userSearch.phoneNumber substringWithRange:NSMakeRange(userSearch.phoneNumber.length - 3, 3)];
    [netIns addFriend:userSearch.friendID withDigit:digit];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [waiting startAnimating];
    
    [netIns getUserByString:scSearchFriend.text];
    scSearchFriend.text = @"";
    [self.view endEditing:YES];
    
}

- (void) setResult:(NSString *)_strResult{
    NSArray *subData = [_strResult componentsSeparatedByString:@"{"];
    if ([subData count] == 2) {
        if ([[subData objectAtIndex:0] isEqualToString:@"GETUSERBYSTRING"]) {
            items = [NSMutableArray new];
            NSArray *subParameter = [[subData objectAtIndex:1] componentsSeparatedByString:@"$"];
            if ([subParameter count] > 0) {
                int count = (int)[subParameter count];
                for (int i = 0; i < count; i++) {
                    NSArray *subSearchFriend = [[subParameter objectAtIndex:i] componentsSeparatedByString:@"}"];
                    if ([subSearchFriend count] > 1) {
                        UserSearch *_userSearch = [UserSearch new];
                        [_userSearch setFriendID:[[subSearchFriend objectAtIndex:0] intValue]];
                        [_userSearch setFirstName:[helperIns decode:[subSearchFriend objectAtIndex:1]]];
                        [_userSearch setLastName:[helperIns decode:[subSearchFriend objectAtIndex:2]]];
                        [_userSearch setUrlAvatar:[helperIns decode:[subSearchFriend objectAtIndex:3]]];
                        [_userSearch setUrlAvatarFull:[helperIns decode:[subSearchFriend objectAtIndex:4]]];
                        [_userSearch setPhoneNumber:[helperIns decode:[subSearchFriend objectAtIndex:5]]];
                        [_userSearch setUserName:[helperIns decode:[subSearchFriend objectAtIndex:6]]];
                        
                        [items addObject:_userSearch];
                    }
                }
            }
            
            [waiting stopAnimating];
            
            [tbSearchFriend initData:items];
            [tbSearchFriend reloadData];
        }
        
        if ([[subData objectAtIndex:0] isEqualToString:@"SENDFRIENDREQUEST"]) {
            NSString *result = [[subData objectAtIndex:1] stringByReplacingOccurrencesOfString:@"<EOF>" withString:@""];
            if ([result isEqualToString:@"0"]) {
                
                [netIns getUserProfile:userSearch.friendID];
                
            }else{
                
            }
        }
        
        if ([[subData objectAtIndex:0] isEqualToString:@"GETUSERPROFILE"]) {
            NSArray *subCommand = [[subData objectAtIndex:1] componentsSeparatedByString:@"}"];
            if ([subCommand count] > 1) {
                Friend *_friend = [Friend new];
                
//                _friend.isPublic = [[subCommand objectAtIndex:0] boolValue];
//                _friend.countFollower = [[subCommand objectAtIndex:1] intValue];
//                _friend.countFollowing = [[subCommand objectAtIndex:2] intValue];
//                _friend.countPost = [[subCommand objectAtIndex:3] intValue];
                _friend.friendID = [[subCommand objectAtIndex:4] intValue];
                _friend.userName = [helperIns decode:[subCommand objectAtIndex:5]];
                _friend.firstName = [helperIns decode:[subCommand objectAtIndex:6]];
                _friend.lastName = [helperIns decode:[subCommand objectAtIndex:7]];
                _friend.nickName = [NSString stringWithFormat:@"%@ %@", _friend.firstName, _friend.lastName];
                _friend.urlThumbnail = [helperIns decode:[subCommand objectAtIndex:8]];
                _friend.urlAvatar = [helperIns decode:[subCommand objectAtIndex:9]];
//                _friend.birthDay = [subCommand objectAtIndex:10];
                _friend.gender = [helperIns decode:[subCommand objectAtIndex:11]];
//                _friend.relationship = [helperIns decode:[subCommand objectAtIndex:12]];
                _friend.statusAddFriend = 1;
                _friend.userID = storeIns.user.userID;

                [storeIns.friends addObject:_friend];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationReloadListFriend" object:nil userInfo:nil];
                
                CoziCoreData *cz = [CoziCoreData shareInstance];
                [cz saveFriend:_friend];
                
                [tbSearchFriend reloadData];
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
