//
//  SCSinglePostViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/16/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCSinglePostViewController.h"

@interface SCSinglePostViewController ()

@end

@implementation SCSinglePostViewController

@synthesize singleWall;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupVariable];
    [self setupUI];
}


- (void) setupVariable{
    hHeader = 40;
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    netControllerIns = [NetworkController shareInstance];
}

- (void) setupUI{
    items = [NSMutableArray new];
    
    self.singleWall = [[SCWallTableViewV2 alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - hHeader) style:UITableViewStylePlain];
    self.singleWall.tableFooterView = nil;
    [self.view addSubview:self.singleWall];
}

- (void) setData:(NSMutableArray *)data{
    items = data;
    
    [self.singleWall initWithData:items withType:1];
    [self.singleWall reloadData];
}

- (void) setResult:(NSString *)_strResult{
    
    NSArray *subData = [_strResult componentsSeparatedByString:@"{"];
    if ([subData count] == 2) {
        
        if ([[subData objectAtIndex:0] isEqualToString:@"ADDPOSTLIKE"]) {
            
            [self.singleWall reloadData];
            
        }
        
        if ([[subData objectAtIndex:0] isEqualToString:@"REMOVEPOSTLIKE"]) {
            
            [self.singleWall reloadData];
            
        }
        
    }
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.singleWall reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.lblTitle setText:@"PHOTO"];
    [netControllerIns addListener:self];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
