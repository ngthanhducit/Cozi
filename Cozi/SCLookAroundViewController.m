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
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.lblTitle setText:@"FRIEND REQUESTS IN RANGER"];
    
    [netIns addListener:self];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [netIns removeListener:self];
}

- (void) setResult:(NSString *)_strResult{
    _strResult = [_strResult stringByReplacingOccurrencesOfString:@"<EOF>" withString:@""];
    NSArray *subData = [_strResult componentsSeparatedByString:@"{"];
    if ([subData count] == 2) {
        if ([[subData objectAtIndex:0] isEqualToString:@"FINDUSERINRANGE"]) {
            
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
