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
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self initVariable];
        [self setupNotification];
        [self setup];
        [self setupUI];
    }
    
    return self;
}

- (void) initVariable{
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

- (void) setup{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, hHeader)];
    [self.vHeader setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.vHeader];
    
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.view.bounds.size.width - 80, hHeader)];
    [self.lblTitle setText:@"COMMENTS"];
    [self.lblTitle setFont:[helperIns getFontLight:18.0f]];
    [self.lblTitle setTextColor:[UIColor whiteColor]];
    [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self.vHeader addSubview:self.lblTitle];
    
    self.btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnClose setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.btnClose setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.btnClose setFrame:CGRectMake(self.view.bounds.size.width - hHeader, 0, hHeader, hHeader)];
    [self.btnClose setTitle:@"x" forState:UIControlStateNormal];
    [self.btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnClose.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [self.btnClose addTarget:self action:@selector(btnCloseTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.vHeader addSubview:self.btnClose];
    
    [self.view addSubview:self.vHeader];
    
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
    [self.vAddComment addSubview:self.txtComment];
    
    self.btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSend setBackgroundColor:[UIColor greenColor]];
    [self.btnSend setFrame:CGRectMake(self.view.bounds.size.width - 50, 0, 50, hViewAddComment)];
    [self.btnSend setTitle:@"SEND" forState:UIControlStateNormal];
    [self.btnSend.titleLabel setFont:[helperIns getFontLight:14.0f]];
    [self.btnSend addTarget:self action:@selector(btnSendComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.vAddComment addSubview:self.btnSend];
    
}


- (void) setupUI{
    wallItems = [DataWall new];
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

- (void) btnCloseTap:(id)sender{
    [netControllerIns removeListener:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

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
        
        NSArray *subCommand = [[subData objectAtIndex:1] componentsSeparatedByString:@"}"];
        if ([subCommand count] > 1) {
            
            PostComment *_newComment = [[PostComment alloc] init];
            _newComment.dateComment = [helperIns convertStringToDate:[subCommand objectAtIndex:0]];
            _newComment.userCommentId = [[subCommand objectAtIndex:1] integerValue];
            _newComment.firstName = [helperIns decode:[subCommand objectAtIndex:2]];
            _newComment.lastName = [helperIns decode:[subCommand objectAtIndex:3]];
            _newComment.contentComment = self.txtComment.text;
            _newComment.urlImageComment = storeIns.user.urlThumbnail;
            _newComment.commentLikes = [NSMutableArray new];
            
            //Map list like comment
            [wallItems.comments addObject:_newComment];
            
            self.txtComment.text = @"";
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [self.tbComment reloadData];
        }
        
    }
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.lblTitle setText:@"COMMENTS"];

    [netControllerIns addListener:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
