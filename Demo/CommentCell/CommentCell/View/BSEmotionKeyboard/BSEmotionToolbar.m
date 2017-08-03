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

static CGFloat const kButtonItemW = 50.0f;

@interface BSEmotionToolbar ()
@property (nonatomic, weak) UIButton *addBtn;
@property (nonatomic, weak) UIButton *settingBtn;
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
        addBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        [addBtn setTitle:@"+" forState:UIControlStateNormal];
        [addBtn setTitle:@"+" forState:UIControlStateHighlighted];
        [addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [addBtn addTarget:self action:@selector(addItem) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        self.addBtn = addBtn;
        
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        settingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
        [settingBtn setTitle:@"设置" forState:UIControlStateHighlighted];
        [settingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [settingBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [settingBtn addTarget:self action:@selector(settingItem) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:settingBtn];
        self.settingBtn = settingBtn;
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.alwaysBounceHorizontal = YES;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
    }
    return self;
}

- (void)addItem
{
    if ([self.delegate respondsToSelector:@selector(emotionToolbarDidClickAddItem:)]) {
        [self.delegate emotionToolbarDidClickAddItem:self];
    }
}

- (void)settingItem
{
    if ([self.delegate respondsToSelector:@selector(emotionToolbarDidClickSettingItem:)]) {
        [self.delegate emotionToolbarDidClickSettingItem:self];
    }
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
    
    if (self.buttonItems.count == 1) {
        [self buttonClick:buttonItem];
    }
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
    self.settingBtn.frame = CGRectMake(self.bounds.size.width - kButtonItemW, 0, kButtonItemW, self.bounds.size.height);
    self.scrollView.frame = CGRectMake(CGRectGetMaxX(self.addBtn.frame), 0, self.bounds.size.width - self.addBtn.bounds.size.width - self.settingBtn.bounds.size.width, self.bounds.size.height);
    
    [self setupButtonItems];
}

- (void)removeAllItems
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

- (void)selectItemWithIndex:(NSInteger)index
{
    if (self.buttonItems.count - 1 < index) return;
    
    UIButton *button = [self.buttonItems objectAtIndex:index];
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}


@end
