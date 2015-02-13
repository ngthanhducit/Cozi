//
//  SCCommentViewController.m
//  Cozi
//
//  Created by Nguyen Thanh Duc on 1/29/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCCommentViewController.h"

@interface SCCommentViewController ()

@end

@implementation SCCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupVariable];
    [self setupNotification];
    [self setupUI];
}

- (void) setupVariable{
    hHeader = 40;
    hViewAddComment = 40;
    helperIns = [Helper shareInstance];
    storeIns = [Store shareInstance];
    netControllerIns = [NetworkController shareInstance];
}

- (void) setupNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) setupUI{
    wallItems = [DataWall new];
    
    self.tbComment = [[SCCommentTableView alloc] initWithFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - hHeader - hViewAddComment) style:UITableViewStylePlain];
    [self.tbComment setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.view addSubview:self.tbComment];
    
    self.vAddComment = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - hViewAddComment, self.view.bounds.size.width, hViewAddComment)];
    [self.vAddComment setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.vAddComment];
    
    self.txtComment = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width - 60, hViewAddComment)];
    [self.txtComment setDelegate:self];
    self.txtComment.isScrollable = NO;
    self.txtComment.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.txtComment.minNumberOfLines = 1;
    self.txtComment.maxNumberOfLines = 3;
    self.txtComment.font = [helperIns getFontLight:17.0f];
    self.txtComment.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.txtComment.placeholder = @"ADD A COMMENT...";
    [self.txtComment setTextColor:[UIColor darkGrayColor]];
    [self.vAddComment addSubview:self.txtComment];
    
    UIImage *imgSend = [helperIns getImageFromSVGName:@"icon-Chat-Send.svg"];
    self.btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.btnSend setBackgroundColor:[UIColor greenColor]];
    [self.btnSend setFrame:CGRectMake(self.view.bounds.size.width - 50, 0, 50, hViewAddComment)];
    [self.btnSend setImage:imgSend forState:UIControlStateNormal];
//    [self.btnSend setTitle:@"SEND" forState:UIControlStateNormal];
    [self.btnSend.titleLabel setFont:[helperIns getFontLight:14.0f]];
    [self.btnSend addTarget:self action:@selector(btnSendComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.vAddComment addSubview:self.btnSend];
}

- (void) setData:(DataWall*)data withType:(int)_typeDisplay{
    wallItems = data;
    typeDisplay = _typeDisplay;
    [self.tbComment setData:data];
    [self.tbComment reloadData];
    
    if (typeDisplay == 0) {
        [self.txtComment becomeFirstResponder];
    }
    
    [self scrollToBottom];
}

//- (void) btnCloseTap:(id)sender{
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void) btnSendComment:(id)sender{
    
    if (![self.txtComment.text isEqualToString:@""]) {
        NSString *_clientKey = wallItems.clientKey;
        NSString *_commentKey = [storeIns randomKeyMessenger];
        [netControllerIns addComment:self.txtComment.text withImageName:@"" withPostClientKey:_clientKey withCommentClientKey:_commentKey withUserPostID:wallItems.userPostID];
    }
}

#pragma -mark keyboardDelegate

- (void) keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //    CGRect frameSendVIew = self.viewSendMessage.frame;
    
    //    frameSendVIew.origin.y = kbSize.height;
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.vAddComment setFrame:CGRectMake(0, self.view.bounds.size.height - kbSize.height - self.txtComment.bounds.size.height, self.view.bounds.size.width, self.txtComment.bounds.size.height)];
        
        [self.tbComment setFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - kbSize.height - hHeader - self.txtComment.bounds.size.height)];
        
        [self scrollToBottom];
        
    }];
}

- (void) keyboardWillBeHidden:(NSNotification*)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    CGSize kbSize = [[userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect frameSendView = self.vAddComment.frame;
    frameSendView.origin.y += kbSize.height;
    
    NSLog(@"%f", self.txtComment.bounds.size.height);
    
    [UIView animateWithDuration:0.0 animations:^{
        
        [self.vAddComment setFrame:CGRectMake(0, self.view.bounds.size.height - self.txtComment.bounds.size.height, self.view.bounds.size.width, self.txtComment.bounds.size.height)];
        
        [self.tbComment setFrame:CGRectMake(0, hHeader, self.view.bounds.size.width, self.view.bounds.size.height - hHeader - self.txtComment.bounds.size.height)];
    }];
}

- (void) scrollToBottom{
    //scroll to bottom
    double y = self.tbComment.contentSize.height - self.tbComment.bounds.size.height;
    CGPoint bottomOffset = CGPointMake(0, y);
    if (y > -self.tbComment.contentInset.top)
        [self.tbComment setContentOffset:bottomOffset animated:YES];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.vAddComment.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    
    [UIView animateWithDuration:0.0 animations:^{
        self.vAddComment.frame = r;
        [self.tbComment setFrame:CGRectMake(0, self.tbComment.frame.origin.y, self.tbComment.bounds.size.width, self.vAddComment.frame.origin.y - hHeader)];
    }];
    
}

- (void) setResult:(NSString *)_strResult{
    
    NSArray *subData = [_strResult componentsSeparatedByString:@"{"];
    if ([subData count] == 2) {
        
        if ([[subData objectAtIndex:0] isEqualToString:@"ADDCOMMENT"]) {
            NSArray *subCommand = [[subData objectAtIndex:1] componentsSeparatedByString:@"}"];
            if ([subCommand count] > 1) {
                
                PostComment *_newComment = [[PostComment alloc] init];
                _newComment.dateComment = [helperIns convertStringToDate:[subCommand objectAtIndex:0]];
                
                _newComment.userCommentId = storeIns.user.userID;
                
                _newComment.firstName = storeIns.user.firstname;
                _newComment.lastName = storeIns.user.lastName;
                _newComment.contentComment = self.txtComment.text;
                _newComment.urlImageComment = @"";
                
                //object at index 6
                _newComment.commentLikes = [NSMutableArray new];
                //object at index 7
                //_newComment.isLikeComment
                _newComment.postClientKey = [helperIns decode:[subCommand objectAtIndex:1]];
                _newComment.commentClientKey = [helperIns decode:[subCommand objectAtIndex:2]];
                _newComment.commentLikes = [NSMutableArray new];
                
                //Map list like comment
                [wallItems.comments addObject:_newComment];
                
                self.txtComment.text = @"";
//                [self.navigationController popViewControllerAnimated:YES];
                
                [self.tbComment reloadData];
            }
    
        }
        
    }
    
}

- (void) removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationAddRemoveFollowing" object:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.tbComment reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.lblTitle setText:@"COMMENTS"];

    [netControllerIns addListener:self];
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

@end
