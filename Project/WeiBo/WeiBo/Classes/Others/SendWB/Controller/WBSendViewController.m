//
//  WBSendViewController.m
//  WeiBo
//
//  Created by wbs on 17/2/28.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBSendViewController.h"

#import "WBAccountTool.h"
#import "WBAccount.h"
#import "WBUser.h"
#import "WBTextView.h"
#import "WBSendToolBar.h"
#import "WBEmotionKeyboard.h"

#define kToolBarHeight 44.0
#define kDIYKeyboardHeight 216.0

@interface WBSendViewController () <UITextViewDelegate, WBSendToolBarDelegate>

@property (nonatomic, weak) WBTextView *textView;
@property (nonatomic, weak) WBSendToolBar *toolBar;

@property (nonatomic, strong) WBEmotionKeyboard *keyboardEmotion;
@property (nonatomic, strong) UIView *keyboardMore;

@property (nonatomic, assign, getter=isChangingKeyboardEmotion) BOOL changingKeyboardEmotion;
@property (nonatomic, assign, getter=isChangingKeyboardMore) BOOL changingKeyboardMore;

@end

@implementation WBSendViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIView *)keyboardEmotion
{
    if (_keyboardEmotion == nil) {
        _keyboardEmotion = [WBEmotionKeyboard emotionKeyboard];
        _keyboardEmotion.bounds = CGRectMake(0, 0, kScreenWidth, kDIYKeyboardHeight);
        _keyboardEmotion.backgroundColor = [UIColor redColor];
    }
    return _keyboardEmotion;
}

- (UIView *)keyboardMore
{
    if (_keyboardMore == nil) {
        _keyboardMore = [[UIView alloc] init];
        _keyboardMore.bounds = CGRectMake(0, 0, kScreenWidth, kDIYKeyboardHeight);
        _keyboardMore.backgroundColor = [UIColor blueColor];
    }
    return _keyboardMore;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // UI
    [self loadUI];
    
    // 监听
    [self addNotificationObserver];
    
    // 主动弹出键盘
    [self.textView becomeFirstResponder];
}

- (void)loadUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSend)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    NSString *titleStr1 = @"发微博";
    NSString *titleStr2 = [WBAccountTool account].user.name;
    NSString *titleCombine = [NSString stringWithFormat:@"%@\n%@", titleStr1, titleStr2];
    NSMutableAttributedString *artStr = [[NSMutableAttributedString alloc] initWithString:titleCombine];
    // 字体
    [artStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[titleCombine rangeOfString:titleStr1]];
    [artStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.5] range:[titleCombine rangeOfString:titleStr2]];
    // 颜色
    [artStr addAttribute:NSForegroundColorAttributeName value:kSystemNavigationTitleColor range:[titleCombine rangeOfString:titleStr1]];
    [artStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:[titleCombine rangeOfString:titleStr2]];
    titleLabel.attributedText = artStr;
    self.navigationItem.titleView = titleLabel;
    
    WBTextView *textView = [[WBTextView alloc] init];
    textView.frame = CGRectMake(7, 0, self.view.bounds.size.width - 7 * 2, self.view.bounds.size.height - kToolBarHeight);
    textView.alwaysBounceVertical = YES;
    textView.placehoder = @"分享新鲜事...";
    textView.font = [UIFont systemFontOfSize:15];
    textView.delegate = self;
    textView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:textView];
    self.textView = textView;
    
    WBSendToolBar *toolBar = [[WBSendToolBar alloc] init];
    toolBar.width = self.view.width;
    toolBar.delegate = self;
    toolBar.height = kToolBarHeight;
    toolBar.y = self.view.height - toolBar.height;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
}

- (void)addNotificationObserver
{
    // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    // 键盘弹出需要的时间
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    if (self.isChangingKeyboardEmotion || self.isChangingKeyboardMore) return;
    
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.toolBar.transform = CGAffineTransformIdentity;
    }];
}

- (void)cancelSend
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send
{
    
}

- (void)openEmotion
{
    self.changingKeyboardEmotion = YES;
    
    if (self.textView.inputView) { // 当前有自定义键盘
        if (self.textView.inputView == self.keyboardEmotion) {
            self.textView.inputView = nil;
            self.toolBar.showEmotionButton = YES;
        } else if (self.textView.inputView == self.keyboardMore) {
            self.textView.inputView = self.keyboardEmotion;
            self.toolBar.showEmotionButton = NO;
            self.toolBar.showMoreButton = YES;
        } else {
            
        }
    } else { // 当前为系统键盘，切换为自定义键盘
        self.textView.inputView = self.keyboardEmotion;
        self.toolBar.showEmotionButton = NO;
    }
    
    [self.textView resignFirstResponder]; // 关闭键盘
    
    self.changingKeyboardEmotion = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder]; // 打开键盘
    });
}

- (void)openMore
{
    self.changingKeyboardMore = YES;
    
    if (self.textView.inputView) {
        if (self.textView.inputView == self.keyboardMore) {
            self.textView.inputView = nil;
            self.toolBar.showMoreButton = YES;
        } else if (self.textView.inputView == self.keyboardEmotion) {
            self.textView.inputView = self.keyboardMore;
            self.toolBar.showMoreButton = NO;
            self.toolBar.showEmotionButton = YES;
        } else {
            
        }
    } else { // 当前为系统键盘，切换为自定义键盘
        self.textView.inputView = self.keyboardMore;
        self.toolBar.showMoreButton = NO;
    }
    
    [self.textView resignFirstResponder]; // 关闭键盘
    
    self.changingKeyboardMore = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder]; // 打开键盘
    });
}

#pragma mark - WBSendToolBarDelegate

- (void)sendToolBar:(WBSendToolBar *)toolBar didClickButtonType:(WBSendToolBarButtonType)buttonType
{
    switch (buttonType) {
        case WBSendToolBarButtonTypePicture:
            
            break;
        case WBSendToolBarButtonTypeMention:
            
            break;
        case WBSendToolBarButtonTypeTopic:
            
            break;
        case WBSendToolBarButtonTypeEmotion:
            [self openEmotion];
            break;
        case WBSendToolBarButtonTypeMore:
            [self openMore];
            break;
        default:
            break;
    }
}

#pragma mark - UITextViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
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
