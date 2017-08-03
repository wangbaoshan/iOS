//
//  ViewController.m
//  CommentCell
//
//  Created by power on 2017/5/22.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "ViewController.h"

#import "StatusFrameModel.h"
#import "StatusModel.h"
#import "StatusCell.h"
#import "StatusCommentsView.h"
#import "MJExtension.h"
#import "CommentToolBar.h"
#import "EmotionKeyboard.h"

#import "BSEmotionKeyboard.h"
#import "BSEmotionModel.h"

#define kDIYKeyboardHeight 216.0f
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, StatusCellDelegate, UITextFieldDelegate, CommentToolBarDelegate>

@property (nonatomic, strong) NSMutableArray<StatusFrameModel *> *frameModels;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) CommentToolBar *commentToolBar;
@property (nonatomic, assign, getter=isChangingKeyboardEmotion) BOOL changingKeyboardEmotion;
@property (nonatomic, strong) NSIndexPath *currentCommentIndexPath;
@property (nonatomic, strong) EmotionKeyboard *keyboardEmotion;
@property (nonatomic, strong) BSEmotionKeyboard *keyboardEmotion_new;

@end

@implementation ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"朋友圈";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    CommentToolBar *commentToolBar = [CommentToolBar toolBar];
    commentToolBar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44);
    commentToolBar.textFileld.delegate = self;
    commentToolBar.delegate = self;
    [self.view addSubview:commentToolBar];
    self.commentToolBar = commentToolBar;
    
    [self addNotificationObserver];
    
    [self creatData];
    [self.tableView reloadData];
}

- (void)addNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickSmallPicture:) name:kEmotionKeyboardDidClickSmallPicture object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickEmoji:) name:kEmotionKeyboardDidClickEmoji object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickLargePicture:) name:kEmotionKeyboardDidClickLargePicture object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickDeleteButton:) name:kEmotionKeyboardDidClickDeleteButton object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    // 键盘弹出需要的时间
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height + 44;
        self.commentToolBar.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
        
        // cell滚动到键盘上边
        CGRect toolBarRect = [self.view convertRect:self.commentToolBar.frame toView:[UIApplication sharedApplication].keyWindow];
        CGRect currentCellRect = [self.tableView convertRect:[self.tableView cellForRowAtIndexPath:self.currentCommentIndexPath].frame toView:[UIApplication sharedApplication].keyWindow];
        CGFloat padding = toolBarRect.origin.y - (currentCellRect.origin.y + currentCellRect.size.height);
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - padding)];
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    if (self.isChangingKeyboardEmotion) return;
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.commentToolBar.transform = CGAffineTransformIdentity;
    }];
}

- (void)clickSmallPicture:(NSNotification *)noti
{
    BSEmotionSmallPicture *smallPicture = noti.object;
    NSLog(@"smallPicture=====%@", smallPicture.chs);
}

- (void)clickEmoji:(NSNotification *)noti
{
    BSEmotionEmoji *emoji = noti.object;
    [self.commentToolBar.textFileld insertText:emoji.emojiString];
    NSLog(@"emoji=====%@", self.commentToolBar.textFileld.text);
}

- (void)clickLargePicture:(NSNotification *)noti
{
    BSEmotionLargePicture *largePicture = noti.object;
    NSLog(@"largePicture=====%@", largePicture.chs);
}

- (void)clickDeleteButton:(NSNotification *)noti
{
    NSLog(@"delete emotion----%@", self.commentToolBar.textFileld.text);
    [self.commentToolBar.textFileld deleteBackward];
}


- (void)creatData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Model" ofType:@"plist"];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:filePath];
    for (NSDictionary *dict in dataArr) {
        StatusModel *model = [StatusModel mj_objectWithKeyValues:dict];
        StatusFrameModel *frameModel = [[StatusFrameModel alloc] init];
        frameModel.model = model;
        [self.frameModels addObject:frameModel];
    }
}

#pragma mark - Getter

- (NSMutableArray<StatusFrameModel *> *)frameModels
{
    if (_frameModels == nil) {
        _frameModels = [NSMutableArray array];
    }
    return _frameModels;
}

- (EmotionKeyboard *)keyboardEmotion
{
    if (_keyboardEmotion == nil) {
        _keyboardEmotion = [EmotionKeyboard emotionKeyboard];
        _keyboardEmotion.bounds = CGRectMake(0, 0, kScreenWidth, kDIYKeyboardHeight);
    }
    return _keyboardEmotion;
}

- (BSEmotionKeyboard *)keyboardEmotion_new
{
    if (_keyboardEmotion_new == nil) {
        [BSEmotionKeyboard setKeyboardHeight:216.0];
        _keyboardEmotion_new = [BSEmotionKeyboard emotionKeyboard];
        _keyboardEmotion_new.emotionModels = [self createEmotionData];
    }
    return _keyboardEmotion_new;
}

- (NSArray<BSEmotionModel *> *)createEmotionData
{
    NSMutableArray<BSEmotionModel *> *models = [NSMutableArray array];
    BSEmotionModel *model0 = [[BSEmotionModel alloc] init];
    model0.emotionType = BSEmotionType_SmallPicture;
    model0.plistDirectory = @"EmotionIcons/default/info.plist";
    model0.directory = @"EmotionIcons/default";
    PTToolbarItem *item0 = [[PTToolbarItem alloc] init];
    item0.indexTextString = @"默认";
    model0.toolbarItem = item0;
    [models addObject:model0];
    
    BSEmotionModel *model1 = [[BSEmotionModel alloc] init];
    model1.emotionType = BSEmotionType_Emoji;
    model1.plistDirectory = @"EmotionIcons/emoji/info.plist";
    model1.directory = @"EmotionIcons/emoji";
    PTToolbarItem *item1 = [[PTToolbarItem alloc] init];
    item1.indexTextString = @"emoji";
    model1.toolbarItem = item1;
    [models addObject:model1];
    
    BSEmotionModel *model2 = [[BSEmotionModel alloc] init];
    model2.emotionType = BSEmotionType_SmallPicture;
    model2.plistDirectory = @"EmotionIcons/lxh/info.plist";
    model2.directory = @"EmotionIcons/lxh";
    PTToolbarItem *item2 = [[PTToolbarItem alloc] init];
    item2.indexTextString = @"浪小花";
    model2.toolbarItem = item2;
    [models addObject:model2];
    
    return models;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.frameModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusCell *cell = [StatusCell cellWithTableView:tableView];
    cell.currentIndexPath = indexPath;
    cell.delegate = self;
    cell.frameModel = self.frameModels[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frameModels[indexPath.row].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - CommentToolBarDelegate

- (void)commentToolBar:(CommentToolBar *)commentToolBar didClickKeyboardChangeButton:(UIButton *)keyboardChangeButton
{
    self.changingKeyboardEmotion = YES;
    
    if (commentToolBar.textFileld.inputView) { // 当前有自定义键盘
        if (commentToolBar.textFileld.inputView == self.keyboardEmotion_new) {
            commentToolBar.textFileld.inputView = nil;
            commentToolBar.showEmotionButton = YES;
        }
    } else { // 当前为系统键盘，切换为自定义键盘
        commentToolBar.textFileld.inputView = self.keyboardEmotion_new;
        commentToolBar.showEmotionButton = NO;
    }
    
    [commentToolBar.textFileld resignFirstResponder]; // 关闭键盘

    self.changingKeyboardEmotion = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [commentToolBar.textFileld becomeFirstResponder]; // 打开键盘
    });
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 发评论
    StatusFrameModel *frameModel = self.frameModels[self.currentCommentIndexPath.row];
    StatusModel *model = frameModel.model;
    
    StatusComment *newComment = [[StatusComment alloc] init];
    newComment.commentName = @"Bean";
    newComment.commentDetail = textField.text;
    NSMutableArray<StatusComment *> *comments = [NSMutableArray arrayWithArray:model.comments];
    [comments addObject:newComment];
    model.comments = comments;
    
    StatusFrameModel *newFrameModel = [[StatusFrameModel alloc] init];
    newFrameModel.model = model;
    
    [self.frameModels replaceObjectAtIndex:self.currentCommentIndexPath.row withObject:newFrameModel];
    [self.tableView reloadRowsAtIndexPaths:@[self.currentCommentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    textField.text = nil;
    [self.commentToolBar.textFileld resignFirstResponder];
    
    return YES;
}

#pragma mark - StatusCellDelegate

- (void)statusCell:(StatusCell *)statusCell didClickCommentButton:(UIButton *)commentButton tableViewIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentCommentIndexPath == indexPath) {
        if (self.commentToolBar.textFileld.isFirstResponder) return;
        [self.commentToolBar.textFileld becomeFirstResponder];
    } else {
        self.currentCommentIndexPath = indexPath;
        if (self.commentToolBar.textFileld.isFirstResponder) {
            [self.commentToolBar.textFileld resignFirstResponder];
        }
        [self.commentToolBar.textFileld becomeFirstResponder];
    }
}

- (void)statusCell:(StatusCell *)statusCell comments:(NSArray<StatusComment *> *)comments deleteComment:(StatusComment *)comment tableViewIndexPath:(NSIndexPath *)indexPath
{
    // 删评论
    StatusFrameModel *frameModel = self.frameModels[indexPath.row];
    StatusModel *model = frameModel.model;
    NSInteger index = [comments indexOfObject:comment];
    
    NSMutableArray<StatusComment *> *newComments = [NSMutableArray arrayWithArray:comments];
    [newComments removeObjectAtIndex:index];
    model.comments = newComments;
    
    StatusFrameModel *newFrameModel = [[StatusFrameModel alloc] init];
    newFrameModel.model = model;
    
    [self.frameModels replaceObjectAtIndex:indexPath.row withObject:newFrameModel];
    [self.tableView reloadData];
}

#pragma mark - UITextViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.commentToolBar.textFileld resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
