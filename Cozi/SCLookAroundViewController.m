//
//  SCLookAroundViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/14/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCLookAroundViewController.h"

@interface SCLookAroundViewController ()

@end

@implementation SCLookAroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupVariable];
    [self setupUI];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.lblTitle setText:@"FRIEND IN RANGER"];
    
    [netIns addListener:self];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [netIns removeListener:self];
}

- (void) setupVariable{
    storeIns = [Store shareInstance];
    helperIns = [Helper shareInstance];
    
    netIns = [NetworkController shareInstance];
}

- (void) setupUI{
    
    self.tbSearchRanger = [[SCSearchFriendTableView alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - (hHeader)) style:UITableViewStylePlain];
    [self.tbSearchRanger setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeInteractive];
    [self.view addSubview:self.tbSearchRanger];
    
//    waiting = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [waiting setFrame:CGRectMake(0, hHeader + hStatusBar, self.view.bounds.size.width, self.view.bounds.size.height - (hHeader + hStatusBar))];
//    [waiting setBackgroundColor:[UIColor blackColor]];
//    [waiting setAlpha:0.6];
//    [waiting startAnimating];
//    [self.view addSubview:waiting];
    
    loading = [[SCActivityIndicatorView alloc] initWithFrame:CGRectMake(0, hHeader + hStatusBar, self.view.bounds.size.width, self.view.bounds.size.height - (hHeader + hStatusBar))];
    [loading setText:@"Updating your location..."];
    [self.view addSubview:loading];

    [storeIns updateLocationcomplete:^(BOOL finish) {
        if (finish) {
            [netIns findUserInRanger:500.0f];
            dispatch_async(dispatch_get_main_queue(), ^{
                [loading setText:@"Loading..."];
            });
        }
    }];
}

- (void) setResult:(NSString *)_strResult{
    _strResult = [_strResult stringByReplacingOccurrencesOfString:@"<EOF>" withString:@""];
    NSArray *subData = [_strResult componentsSeparatedByString:@"{"];
    if ([subData count] == 2) {
        if ([[subData objectAtIndex:0] isEqualToString:@"FINDUSERINRANGE"]) {
            
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
                        
//                        [_userSearch setPhoneNumber:[helperIns decode:[subSearchFriend objectAtIndex:5]]];
//                        [_userSearch setUserName:[helperIns decode:[subSearchFriend objectAtIndex:6]]];
                        
                        [items addObject:_userSearch];

                    }
                }
            }
            
            [loading setHidden:YES];
            
            [waiting stopAnimating];
            [self.tbSearchRanger initData:items];
            [self.tbSearchRanger reloadData];
            
            //progress data
            
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
