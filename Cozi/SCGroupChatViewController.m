//
//  SCGroupChatViewController.m
//  Cozi
//
//  Created by ChjpCoj on 3/4/15.
//  Copyright (c) 2015 ChjpCoj. All rights reserved.
//

#import "SCGroupChatViewController.h"

@interface SCGroupChatViewController ()

@end

@implementation SCGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupVariable];
    [self setupUI];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.lblTitle setText:@"NEW GROUP"];
    
    [netIns addListener:self];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [netIns removeListener:self];
}

- (void) setupVariable{
    borderColor = [UIColor colorWithRed:110.0f/255.0f green:110.0f/255.0f blue:110.0f/255.0f alpha:1];
    self.items = [NSMutableArray new];
    netIns = [NetworkController shareInstance];
}

- (void) setupUI{
    
    self.imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - (40), hHeader + hStatusBar + 10, 80, 80)];
    [self.imgAvatar setImage:[helperIns getDefaultAvatar]];
    [self.imgAvatar setClipsToBounds:YES];
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.bounds.size.width / 2;
    [self.imgAvatar setAutoresizingMask:UIViewAutoresizingNone];
    [self.imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:self.imgAvatar];
    
    self.txtGroupName = [[SCTextField alloc] initWithdata:20 withPaddingRight:20 withIcon:nil withFont:[helperIns getFontLight:14] withTextColor:borderColor withFrame:CGRectMake(10, self.imgAvatar.frame.origin.y + self.imgAvatar.bounds.size.height + 10, self.view.bounds.size.width - 20, 35)];
    [self.txtGroupName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.txtGroupName setTextColor:borderColor];
    [self.txtGroupName setPlaceholder:@"PLEASE ENTER GROUP NAME"];
    [self.txtGroupName setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.txtGroupName setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.txtGroupName setReturnKeyType:UIReturnKeyNext];
    [self.txtGroupName setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.txtGroupName setBackgroundColor:[UIColor clearColor]];
    self.txtGroupName.layer.borderColor = borderColor.CGColor;
    self.txtGroupName.layer.borderWidth = 0.5f;
    [self.view addSubview:self.txtGroupName];
    
    CGSize size = { self.view.bounds.size.width, self.view.bounds.size.height };
    TriangleView *triangleJoinNow = [[TriangleView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [triangleJoinNow setBackgroundColor:[UIColor whiteColor]];
    [triangleJoinNow drawTriangleSignIn];
    UIImage *imgJoinNow = [helperIns imageWithView:triangleJoinNow];
    
    self.btnCreateGroup = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnCreateGroup setFrame:CGRectMake(0, (self.view.bounds.size.height) - 50, self.view.bounds.size.width, 50)];
    [self.btnCreateGroup setBackgroundColor:[helperIns colorWithHex:[helperIns getHexIntColorWithKey:@"GreenColor2"]]];
    [self.btnCreateGroup setImage:imgJoinNow forState:UIControlStateNormal];
    [self.btnCreateGroup.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.btnCreateGroup setContentMode:UIViewContentModeCenter];
    [self.btnCreateGroup setTitle:@"START NEW GROUP CHAT" forState:UIControlStateNormal];
    [self.btnCreateGroup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCreateGroup addTarget:self action:@selector(btnCreateGroupClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCreateGroup.titleLabel setFont:[helperIns getFontLight:15.0f]];
    
    CGSize sizeTitleLable = [self.btnCreateGroup.titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[helperIns getFontLight:15.0f]} context:nil].size;
    
    [self.btnCreateGroup setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgJoinNow.size.width, 0, imgJoinNow.size.width)];
    self.btnCreateGroup.imageEdgeInsets = UIEdgeInsetsMake(0, (sizeTitleLable.width) + imgJoinNow.size.width, 0, -((sizeTitleLable.width) + imgJoinNow.size.width));
    [self.btnCreateGroup setEnabled:NO];
    [self.view addSubview:self.btnCreateGroup];
    
    self.tbFriend = [[SCGroupChatTableView alloc] initWithFrame:CGRectMake(0, self.txtGroupName.frame.origin.y + self.txtGroupName.bounds.size.height + 10, self.view.bounds.size.width, self.view.bounds.size.height - (self.txtGroupName.frame.origin.y + self.txtGroupName.bounds.size.height + 10 + self.btnCreateGroup.bounds.size.height)) style:UITableViewStylePlain];
    [self.tbFriend setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeInteractive];
    [self.view addSubview:self.tbFriend];
    
    self.waiting = [[SCActivityIndicatorView alloc] initWithFrame:CGRectMake(0, hHeader + hStatusBar, self.view.bounds.size.width, self.view.bounds.size.height - (hHeader + hStatusBar + self.btnCreateGroup.bounds.size.height))];
    [self.waiting setHidden:YES];
    [self.waiting setText:@"Please Waiting..."];
    [self.view addSubview:self.waiting];
}

- (void) initData:(NSMutableArray *)_itemsData{
    if (_itemsData) {
        int count = (int)[_itemsData count];
        for (int i = 0; i < count; i++) {
            [self.items addObject:[_itemsData objectAtIndex:i]];
        }
    }
    
    [self.tbFriend initItems:self.items];
    [self.tbFriend reloadData];
    
    UIImage *img = [self drawAvatar];
    [self.imgAvatar setImage:img];
}

- (UIImage*) drawAvatar{
//    [storeIns renderGroupImageWithFriend:self.items];
    CGSize newSize = { 160, 160 };
    
    UIImage *img1 = [[self.items objectAtIndex:0] thumbnail];
    UIImage *img2 = [[self.items objectAtIndex:1] thumbnail];
    UIImage *img3 = [[self.items objectAtIndex:2] thumbnail];
    
    UIImage *img1Crop = [helperIns cropImage:img1 withFrame:CGRectMake(img1.size.width / 4, 0, img1.size.width / 2, img1.size.height)];
    
    UIGraphicsBeginImageContext(newSize);
    
    [img1Crop drawInRect:CGRectMake(0, 0, img1Crop.size.width, img1Crop.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [img2 drawInRect:CGRectMake(81, 0, 79, 79) blendMode:kCGBlendModeNormal alpha:1.0f];
    [img3 drawInRect:CGRectMake(81, 80, 79, 80) blendMode:kCGBlendModeNormal alpha:1.0f];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return newImage;
}

- (void) textFieldDidChange:(UITextField*)textField{
    if ([textField.text isEqualToString:@""]) {
        [self.btnCreateGroup setEnabled:NO];
    }else{
        [self.btnCreateGroup setEnabled:YES];
    }
}

- (void) btnCreateGroupClick:(id)sender{
    [self.waiting setHidden:NO];
    [netIns createGroupChat:self.txtGroupName.text withFriend:self.items];
    NSLog(@"create group");
    [self.btnCreateGroup setEnabled:NO];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void) setResult:(NSString *)_strResult{
    _strResult = [_strResult stringByReplacingOccurrencesOfString:@"<EOF>" withString:@""];
    NSArray *subData = [_strResult componentsSeparatedByString:@"{"];
    if ([subData count] == 2) {
        
        if ([[subData objectAtIndex:0] isEqualToString:@"ADDGROUP"]) {
            NSArray *subParameter = [[subData objectAtIndex:1] componentsSeparatedByString:@"}"];
            
            if ([subParameter count] > 1) {
                Recent *_newGroupChat = [Recent new];
                [_newGroupChat setUserID:storeIns.user.userID];
                [_newGroupChat setRecentID:[[subParameter objectAtIndex:0] intValue]];
                [_newGroupChat setNameRecent:[helperIns decode:[subParameter objectAtIndex:1]]];
                [_newGroupChat setTypeRecent:1];
                [_newGroupChat setThumbnail:self.imgAvatar.image];
                [_newGroupChat setFriendIns:nil];
                _newGroupChat.friendRecent = [NSMutableArray new];
                
                int count = (int)[self.items count];
                for (int i = 0; i < count; i++) {
                    Friend *_friend = [storeIns getFriendByID:[[self.items objectAtIndex:i] friendID]];
                    [_newGroupChat.friendRecent addObject:_friend];
                }
                
                _newGroupChat.messengerRecent = [NSMutableArray new];
                //Add Default Messenger
                NSString *_keyMessage = [storeIns randomKeyMessenger];
                Messenger *_newMessage = [[Messenger alloc] init];
                [_newMessage setStrMessage: [NSString stringWithFormat:@"%@ %@", storeIns.user.nickName, @"start new group chat"]];
                [_newMessage setTypeMessage:0];
                [_newMessage setStatusMessage:1];
                [_newMessage setKeySendMessage:_keyMessage];
                [_newMessage setTimeMessage:[helperIns getDateFormatMessage:[NSDate date]]];
                [_newMessage setDataImage:nil];
                [_newMessage setThumnail:nil];
                [_newMessage setFriendID:_newGroupChat.recentID];
                [_newMessage setUserID:storeIns.user.userID];
                
                [_newGroupChat.messengerRecent addObject:_newMessage];

                [self.waiting setHidden:YES];
                
                [self.waiting setHidden:YES];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:^{
                    NSString *key = @"groupChatKey";
                    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_newGroupChat forKey:key];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationCreateGroupChat" object:nil userInfo:dictionary];
                    [self.btnCreateGroup setEnabled:YES];
                }];
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
