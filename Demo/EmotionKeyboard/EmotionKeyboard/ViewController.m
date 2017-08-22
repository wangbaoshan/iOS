//
//  ViewController.m
//  EmotionKeyboard
//
//  Created by power on 2017/8/2.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "ViewController.h"

#import "BSEmotionKeyboard.h"
#import "BSEmotionModel.h"

#import <objc/runtime.h>

#define kDIYKeyboardHeight 216.0f
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

static const char kNSTextAttachmentChs;

@interface ViewController () <UITableViewDataSource, UIScrollViewDelegate, UITableViewDelegate>

@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) BSEmotionKeyboard *emotionKeyboard;
@property (nonatomic, strong) NSMutableArray<BSEmotionModel *> *models;
@property (nonatomic, strong) NSMutableArray<NSString *> *texts;

@end

@implementation ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray<NSString *> *)texts
{
    if (!_texts) {
        _texts = [NSMutableArray arrayWithCapacity:0];
    }
    return _texts;
}

- (NSMutableArray<BSEmotionModel *> *)models
{
    if (!_models) {
        _models = [NSMutableArray arrayWithCapacity:0];
        
        BSEmotionModel *model0 = [[BSEmotionModel alloc] init];
        model0.emotionType = BSEmotionType_SmallPicture;
        model0.plistDirectory = @"EmotionIcons/default/info.plist";
        model0.directory = @"EmotionIcons/default";
        PTToolbarItem *item0 = [[PTToolbarItem alloc] init];
        item0.indexTextString = @"默认";
        model0.toolbarItem = item0;
        [_models addObject:model0];
        
        BSEmotionModel *model1 = [[BSEmotionModel alloc] init];
        model1.emotionType = BSEmotionType_Emoji;
        model1.plistDirectory = @"EmotionIcons/emoji/info.plist";
        model1.directory = @"EmotionIcons/emoji";
        PTToolbarItem *item1 = [[PTToolbarItem alloc] init];
        item1.indexTextString = @"emoji";
        model1.toolbarItem = item1;
        [_models addObject:model1];
        
        BSEmotionModel *model2 = [[BSEmotionModel alloc] init];
        model2.emotionType = BSEmotionType_SmallPicture;
        model2.plistDirectory = @"EmotionIcons/lxh/info.plist";
        model2.directory = @"EmotionIcons/lxh";
        PTToolbarItem *item2 = [[PTToolbarItem alloc] init];
        item2.indexTextString = @"浪小花";
        model2.toolbarItem = item2;
        [_models addObject:model2];

    }
    return _models;
}

- (BSEmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        // 初始化键盘
        [BSEmotionKeyboard setKeyboardHeight:kDIYKeyboardHeight];
        _emotionKeyboard = [BSEmotionKeyboard emotionKeyboard];
        _emotionKeyboard.emotionModels = self.models;
    }
    return _emotionKeyboard;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 35)];
    textView.backgroundColor = [UIColor lightGrayColor];
    textView.font = [UIFont systemFontOfSize:15];
    self.navigationItem.titleView = textView;
    self.textView = textView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kDIYKeyboardHeight) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.textView.text = @"点击这里哦!";
    self.textView.inputView = self.emotionKeyboard;
    
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
    
    /// 创建BSEmotionKeyboard数据的方法
//    BSEmotionModel *model1 = [[BSEmotionModel alloc] init];
//    model1.emotionType = BSEmotionType_Emoji;
//    model1.plistDirectory = @"EmotionIcons/emoji/info.plist";
//    model1.directory = @"EmotionIcons/emoji";
//    PTToolbarItem *item1 = [[PTToolbarItem alloc] init];
//    item1.indexTextString = @"emoji";
//    model1.toolbarItem = item1;
//    [self.emotionKeyboard addEmotion:model1];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//    });
    
//    [self.emotionKeyboard removeEmotionAtIndex:self.emotionKeyboard.emotionModels.count - 1];
    [self.emotionKeyboard removeEmotionAtIndex:0];
    

//    BSEmotionModel *model2 = [[BSEmotionModel alloc] init];
//    model2.emotionType = BSEmotionType_SmallPicture;
//    model2.plistDirectory = @"EmotionIcons/lxh/info.plist";
//    model2.directory = @"EmotionIcons/lxh";
//    PTToolbarItem *item2 = [[PTToolbarItem alloc] init];
//    item2.indexTextString = @"浪小花";
//    model2.toolbarItem = item2;
//    [models addObject:model2];
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
    
    [self.texts addObject:string];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.texts.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    self.textView.text = nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.textView resignFirstResponder];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.texts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 2;
    }
    cell.textLabel.text = self.texts[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"发送给服务器的文本样式";
}

@end
