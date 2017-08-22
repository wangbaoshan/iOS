//
//  BSEmotionToolbar.m
//  CommentCell
//
//  Created by power on 2017/6/5.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "BSEmotionToolbar.h"

#import "BSEmotionModel.h"
#import "UIImage+Stretch.h"
#import "BSEmotionKeyboard.h"

static CGFloat const kButtonItemW = 50.0f;

@interface BSEmotionToolbar ()
@property (nonatomic, weak) UIButton *addBtn;
@property (nonatomic, weak) UIButton *settingBtn;
@property (nonatomic, weak) UIButton *sendBtn;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonItems;
@end

@implementation BSEmotionToolbar

- (NSMutableArray<UIButton *> *)buttonItems
{
    if (_buttonItems == nil) {
        _buttonItems = [NSMutableArray array];
    }
    return _buttonItems;
}

+ (BSEmotionToolbar *)toolbar
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [addBtn setTitle:@"添加" forState:UIControlStateHighlighted];
        [addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [addBtn addTarget:self action:@selector(addItem) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        self.addBtn = addBtn;
        
//        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        settingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
//        [settingBtn setTitle:@"设置" forState:UIControlStateHighlighted];
//        [settingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [settingBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//        [settingBtn addTarget:self action:@selector(settingItem) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:settingBtn];
//        self.settingBtn = settingBtn;
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn setTitle:@"发送" forState:UIControlStateHighlighted];
        [sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendBtn];
        self.sendBtn = sendBtn;
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.alwaysBounceHorizontal = YES;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
    }
    return self;
}

- (void)send
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kEmotionKeyboardDidClickSendButton object:nil];
}

- (void)addItem
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kEmotionKeyboardDidClickAddButton object:nil];
}

- (void)settingItem
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kEmotionKeyboardDidClickAddButton object:nil];
}

- (UIButton *)createButtonItem
{
    UIButton *buttonItem = [[UIButton alloc] init];
    buttonItem.titleLabel.font = [UIFont systemFontOfSize:13.5];
    [buttonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [buttonItem setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [buttonItem setBackgroundImage:[UIImage resizedImageWithImageStr:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
    [buttonItem setBackgroundImage:[UIImage resizedImageWithImageStr:@"compose_emotion_table_mid_selected"] forState:UIControlStateSelected];
    [buttonItem addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return buttonItem;
}

- (void)buttonClick:(UIButton *)buttonItem
{
    if (self.selectedButton == buttonItem) return;
    
    self.selectedButton.selected = NO;
    buttonItem.selected = YES;
    self.selectedButton = buttonItem;
    
    if ([self.delegate respondsToSelector:@selector(emotionToolbar:didSelectIndex:)]) {
        [self.delegate emotionToolbar:self didSelectIndex:[self.buttonItems indexOfObject:buttonItem]];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.addBtn.frame = CGRectMake(0, 0, kButtonItemW, self.bounds.size.height);
//    self.settingBtn.frame = CGRectMake(self.bounds.size.width - kButtonItemW, 0, kButtonItemW, self.bounds.size.height);
    self.sendBtn.frame = CGRectMake(self.bounds.size.width - kButtonItemW, 0, kButtonItemW, self.bounds.size.height);
    self.scrollView.frame = CGRectMake(CGRectGetMaxX(self.addBtn.frame), 0, self.bounds.size.width - self.addBtn.bounds.size.width - self.sendBtn.bounds.size.width, self.bounds.size.height);
    
    [self setupButtonItems];
}

- (void)removeAllToolbarItems
{
    [self.buttonItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttonItems removeAllObjects];
    [self setupButtonItems];
}

- (void)setupButtonItems
{
    for (NSInteger i = 0; i < self.buttonItems.count; i++) {
        UIButton *buttonItem = self.buttonItems[i];
        buttonItem.frame = CGRectMake(kButtonItemW * i, 0, kButtonItemW, self.bounds.size.height);
    }
    
    CGFloat totalW = self.buttonItems.count * kButtonItemW;
    self.scrollView.contentSize = CGSizeMake(totalW, 0);
}

- (void)selectToolbarItemAtIndex:(NSInteger)index
{
    UIButton *button = [self.buttonItems objectAtIndex:index];
    [self buttonClick:button];
}

- (void)addToolbarItem:(PTToolbarItem *)toolbarItem
{
    UIButton *buttonItem = [self createButtonItem];
    if (toolbarItem.indexImageString) {
        [buttonItem setImage:[UIImage imageNamed:toolbarItem.indexImageString] forState:UIControlStateNormal];
    } else if (toolbarItem.indexTextString) {
        [buttonItem setTitle:toolbarItem.indexTextString forState:UIControlStateNormal];
    } else {
        
    }
    [self.scrollView addSubview:buttonItem];
    [self.buttonItems addObject:buttonItem];
    
    [self setupButtonItems];
}

- (void)insertToolbarItem:(PTToolbarItem *)toolbarItem atIndex:(NSInteger)index
{
    UIButton *buttonItem = [self createButtonItem];
    if (toolbarItem.indexImageString) {
        [buttonItem setImage:[UIImage imageNamed:toolbarItem.indexImageString] forState:UIControlStateNormal];
    } else if (toolbarItem.indexTextString) {
        [buttonItem setTitle:toolbarItem.indexTextString forState:UIControlStateNormal];
    } else {
        
    }
    [self.scrollView insertSubview:buttonItem atIndex:index];
    [self.buttonItems insertObject:buttonItem atIndex:index];
    
    [self setupButtonItems];
}

- (void)removeToolbarItemAtIndex:(NSInteger)index
{
    [[self.buttonItems objectAtIndex:index] removeFromSuperview];
    [self.buttonItems removeObjectAtIndex:index];
    [self setupButtonItems];
}


@end
