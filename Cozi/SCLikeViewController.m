//
//  SCLikeViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 2/1/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCLikeViewController.h"

@interface SCLikeViewController ()

@end

@implementation SCLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self setupVariable];
        [self registerNotification];
        [self setupUI];
    }
    
    return self;
}

- (void) setupVariable{
    hHeader = 40;
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    netControllerIns = [NetworkController shareInstance];
    
    [netControllerIns addListener:self];
}

- (void) registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAddRemoveFollowing:) name:@"notificationAddRemoveFollowing" object:nil];
}

- (void) setupUI{
    wallItems = [DataWall new];

    self.tbLike = [[SCLikeTableView alloc] initWithFrame:CGRectMake(0, hHeader + hStatusBar, self.view.bounds.size.width, self.view.bounds.size.height - hHeader - hStatusBar) style:UITableViewStylePlain];
    [self.tbLike setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.view addSubview:self.tbLike];

}

- (void) setData:(DataWall*)data{
    wallItems = data;
    
    [self.tbLike setData:data];
    [self.tbLike reloadData];
}

- (void) notificationAddRemoveFollowing:(NSNotification*)notification{
    NSLog(@"tap following");
    NSDictionary *_infoUser = notification.userInfo;
    PostLike *_like = [_infoUser valueForKey:@"followingUser"];
    [netControllerIns addFollow:_like.userLikeId];
}

- (void) setResult:(NSString *)_strResult{
    NSLog(@"result");
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.lblTitle setText:@"LIKES"];
    
    [netControllerIns addListener:self];
}

- (void) removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationAddRemoveFollowing" object:nil];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotification];
    [netControllerIns removeListener:self];
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
