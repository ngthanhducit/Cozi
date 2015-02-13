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
//        [self setup];
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

//- (void) setup{
//    [self.view setBackgroundColor:[UIColor whiteColor]];
//    [self.navigationController setNavigationBarHidden:YES];
//    
//    self.vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, hHeader)];
//    [self.vHeader setBackgroundColor:[UIColor blackColor]];
//    [self.view addSubview:self.vHeader];
//    
//    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.view.bounds.size.width - 80, hHeader)];
//    [self.lblTitle setText:@"LIKES"];
//    [self.lblTitle setFont:[helperIns getFontLight:18.0f]];
//    [self.lblTitle setTextColor:[UIColor whiteColor]];
//    [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
//    [self.vHeader addSubview:self.lblTitle];
//    
//    self.btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.btnClose setAlpha:0.3];
//    [self.btnClose setImage:[helperIns getImageFromSVGName:@"icon-cross-25px.svg"] forState:UIControlStateNormal];
////    [self.btnClose setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
////    [self.btnClose setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//    [self.btnClose setFrame:CGRectMake(self.view.bounds.size.width - hHeader, 0, hHeader, hHeader)];
////    [self.btnClose setTitle:@"x" forState:UIControlStateNormal];
////    [self.btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////    [self.btnClose.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
//    [self.btnClose addTarget:self action:@selector(btnCloseTap:) forControlEvents:UIControlEventTouchUpInside];
//    [self.vHeader addSubview:self.btnClose];
//    
//    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
////    [self.btnBack setAlpha:0.3];
//    [self.btnBack setFrame:CGRectMake(0, 0, hHeader, hHeader)];
//    [self.btnBack setImage:[helperIns getImageFromSVGName:@"icon-backarrow-25px-V2.svg"] forState:UIControlStateNormal];
//    [self.btnBack addTarget:self action:@selector(btnBackTap:) forControlEvents:UIControlEventTouchUpInside];
//    [self.vHeader addSubview:self.btnBack];
//    
//    [self.view addSubview:self.vHeader];
//}

- (void) setupUI{
    wallItems = [DataWall new];

    self.tbLike = [[SCLikeTableView alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - hHeader) style:UITableViewStylePlain];
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
