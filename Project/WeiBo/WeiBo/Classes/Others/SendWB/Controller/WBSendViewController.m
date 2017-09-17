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
#import "BSEmotionKeyboard.h"
#import "BSEmotionModel.h"

#import <objc/runtime.h>

#define kToolBarHeight 44.0
#define kDIYKeyboardHeight 216.0

static const char kNSTextAttachmentChs;

@interface WBSendViewController () <UITextViewDelegate, WBSendToolBarDelegate>

@property (nonatomic, weak) WBTextView *textView;
@property (nonatomic, weak) WBSendToolBar *toolBar;

@property (nonatomic, strong) BSEmotionKeyboard *keyboardEmotion;
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
        
        [BSEmotionKeyboard setKeyboardHeight:kDIYKeyboardHeight];
        _keyboardEmotion = [BSEmotionKeyboard emotionKeyboard];
        
        BSEmotionModel *model0 = [[BSEmotionModel alloc] init];
        model0.emotionType = BSEmotionType_SmallPicture;
        model0.plistDirectory = @"EmotionIcons/default/info.plist";
        model0.directory = @"EmotionIcons/default";
        PTToolbarItem *item0 = [[PTToolbarItem alloc] init];
        item0.indexTextString = @"默认";
        model0.toolbarItem = item0;
        
        
        BSEmotionModel *model1 = [[BSEmotionModel alloc] init];
        model1.emotionType = BSEmotionType_Emoji;
        model1.plistDirectory = @"EmotionIcons/emoji/info.plist";
        model1.directory = @"EmotionIcons/emoji";
        PTToolbarItem *item1 = [[PTToolbarItem alloc] init];
        item1.indexTextString = @"emoji";
        model1.toolbarItem = item1;
        
        BSEmotionModel *model2 = [[BSEmotionModel alloc] init];
        model2.emotionType = BSEmotionType_SmallPicture;
        model2.plistDirectory = @"EmotionIcons/lxh/info.plist";
        model2.directory = @"EmotionIcons/lxh";
        PTToolbarItem *item2 = [[PTToolbarItem alloc] init];
        item2.indexTextString = @"浪小花";
        model2.toolbarItem = item2;
        
        NSArray<BSEmotionModel *> *emotionModels = @[model0, model1, model2];
        _keyboardEmotion.emotionModels = emotionModels;
        
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
    
    // 添加键盘操作的相关通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickSmallPicture:) name:kEmotionKeyboardDidClickSmallPicture object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickEmoji:) name:kEmotionKeyboardDidClickEmoji object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickLargePicture:) name:kEmotionKeyboardDidClickLargePicture object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickDeleteButton:) name:kEmotionKeyboardDidClickDeleteButton object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickAddButton:) name:kEmotionKeyboardDidClickAddButton object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickSendButton:) name:kEmotionKeyboardDidClickSendButton object:nil];
}

- (void)clickSmallPicture:(NSNotification *)noti
{
    BSEmotionSmallPicture *smallPicture = noti.object;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = smallPicture.smallImage;
    attachment.bounds = CGRectMake(0, -3, self.textView.font.lineHeight, self.textView.font.lineHeight);
    objc_setAssociatedObject(attachment, &kNSTextAttachmentChs, smallPicture.chs, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSRange range = self.textView.selectedRange;
    NSInteger location = range.location;
    NSInteger length = range.length;
    if (length > 0) { // replace
        [attributedText replaceCharactersInRange:range withAttributedString:attachString];
    } else { // insert
        [attributedText insertAttributedString:attachString atIndex:location];
    }
    [attributedText addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, attributedText.length)];
    
    self.textView.attributedText = attributedText;
    self.textView.selectedRange = NSMakeRange(location + 1, 0);
}

- (void)clickEmoji:(NSNotification *)noti
{
    BSEmotionEmoji *emoji = noti.object;
    [self.textView insertText:emoji.emojiString];
}

- (void)clickLargePicture:(NSNotification *)noti
{
    BSEmotionLargePicture *largePicture = noti.object;
    NSLog(@"largePicture=====%@", largePicture.chs);
}

- (void)clickDeleteButton:(NSNotification *)noti
{
    [self.textView deleteBackward];
}

- (void)clickAddButton:(NSNotification *)noti
{
    NSLog(@"add emotion");
    
}

- (void)clickSendButton:(NSNotification *)noti
{
    NSAttributedString *attString = self.textView.attributedText;
    if (!attString.length) return;
    
    NSMutableString *string = [NSMutableString string];
    
    [attString enumerateAttributesInRange:NSMakeRange(0, attString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        NSTextAttachment *attachment = attrs[@"NSAttachment"];
        if (attachment) { // 富文本
            NSString *str = objc_getAssociatedObject(attachment, &kNSTextAttachmentChs);
            [string appendString:str];
        } else { // 普通文本
            NSString *substr = [attString attributedSubstringFromRange:range].string;
            [string appendString:substr];
        }
    }];
    
    self.textView.text = nil;
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

@end
