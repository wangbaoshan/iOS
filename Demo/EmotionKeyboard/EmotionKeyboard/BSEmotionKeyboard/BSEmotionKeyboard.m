//
//  BSEmotionKeyboard.m
//  CommentCell
//
//  Created by power on 2017/6/2.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "BSEmotionKeyboard.h"

#import "BSEmotionKeyboardCell.h"
#import "BSEmotionModel.h"
#import "BSEmotionConst.h"
#import "BSEmotionToolbar.h"

static CGFloat _keyboardHeight = 216.0f;

static NSString *const emotionCellID = @"emotionCellID";
static NSString *const smallEmotionCellID = @"smallEmotionCellID";
static NSString *const emojiEmotionCellID = @"emojiEmotionCellID";
static NSString *const largeEmotionCellID = @"largeEmotionCellID";

NSString *const kEmotionKeyboardDidClickSmallPicture = @"kEmotionKeyboardDidClickSmallPicture";
NSString *const kEmotionKeyboardDidClickEmoji = @"kEmotionKeyboardDidClickEmoji";
NSString *const kEmotionKeyboardDidClickLargePicture = @"kEmotionKeyboardDidClickLargePicture";
NSString *const kEmotionKeyboardDidClickDeleteButton = @"kEmotionKeyboardDidClickDeleteButton";
NSString *const kEmotionKeyboardDidClickSendButton = @"kEmotionKeyboardDidClickSendButton";
NSString *const kEmotionKeyboardDidClickAddButton = @"kEmotionKeyboardDidClickAddButton";

@interface BSEmotionKeyboard () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, BSEmotionToolbarDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) BSEmotionToolbar *toolbar;

@property (nonatomic, strong) NSMutableArray<BSEmotionGroup *> *groups;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end

@implementation BSEmotionKeyboard

+ (BSEmotionKeyboard *)emotionKeyboard
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background"]];
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _keyboardHeight);
        
        CGFloat pageControlH = 20.0f;
        CGFloat toolbarH = 35.0f;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height - pageControlH - toolbarH);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - pageControlH - toolbarH) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        [collectionView registerClass:[BSEmotionKeyboardCell class] forCellWithReuseIdentifier:emotionCellID];
        [collectionView registerClass:[PTSmallEmotionKeyboardCell class] forCellWithReuseIdentifier:smallEmotionCellID];
        [collectionView registerClass:[BSEmojiEmotionKeyboardCell class] forCellWithReuseIdentifier:emojiEmotionCellID];
        [collectionView registerClass:[PTLargeEmotionKeyboardCell class] forCellWithReuseIdentifier:largeEmotionCellID];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
        pageControl.defersCurrentPageDisplay = YES;
        pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), self.bounds.size.width, pageControlH);
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        BSEmotionToolbar *toolbar = [BSEmotionToolbar toolbar];
        toolbar.frame = CGRectMake(0, CGRectGetMaxY(self.pageControl.frame), self.bounds.size.width, toolbarH);
        toolbar.delegate = self;
        [self addSubview:toolbar];
        self.toolbar = toolbar;
        
    }
    return self;
}

+ (void)setKeyboardHeight:(CGFloat)keyboardHeight
{
    _keyboardHeight = keyboardHeight;
}

+ (CGFloat)keyboardHeight
{
    return _keyboardHeight;
}

- (NSMutableArray<BSEmotionGroup *> *)groups
{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (void)setEmotionModels:(NSArray<BSEmotionModel *> *)emotionModels
{
    _emotionModels = emotionModels;
    
    [self.groups removeAllObjects];
    [self.toolbar removeAllItems];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 0;
    
    for (BSEmotionModel *model in emotionModels) {
        
        BSEmotionGroup *group = [[BSEmotionGroup alloc] init];
        group.emotionType = model.emotionType;
        
        NSString *plist = [[NSBundle mainBundle] pathForResource:model.plistDirectory ofType:nil];
        NSArray<NSDictionary *> *dataArr = [NSArray arrayWithContentsOfFile:plist];
        
        NSMutableArray<BSEmotion *> *emotions = [NSMutableArray array];
        NSMutableArray<BSEmotionItem *> *items = [NSMutableArray array];
        NSInteger totalPages = 0;
        if (BSEmotionType_SmallPicture == model.emotionType) {
            for (NSDictionary *dicData in dataArr) {
                BSEmotionSmallPicture *smallPic = [BSEmotionSmallPicture emotionWithDic:dicData];
                smallPic.directory = [model.directory copy];
                smallPic.smallImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@", smallPic.directory, smallPic.png]];
                [emotions addObject:smallPic];
            }
            totalPages = (emotions.count + kEmotionMaxCountPerPage - 1) / kEmotionMaxCountPerPage;
            
            for (NSInteger i = 0; i < totalPages; i++) {
                NSUInteger loc = i * kEmotionMaxCountPerPage;
                NSUInteger len = kEmotionMaxCountPerPage;
                if (loc + len > emotions.count) {
                    len = emotions.count - loc;
                }
                NSRange range = NSMakeRange(loc, len);
                NSArray<BSEmotion *> *subEmotions = [emotions subarrayWithRange:range];
                BSEmotionItem *item = [[BSEmotionItem alloc] init];
                item.emotions = subEmotions;
                [items addObject:item];
            }
        } else if (BSEmotionType_Emoji == model.emotionType) {
            for (NSDictionary *dicData in dataArr) {
                BSEmotionEmoji *emoji = [BSEmotionEmoji emotionWithDic:dicData];
                [emotions addObject:emoji];
            }
            totalPages = (emotions.count + kEmotionMaxCountPerPage - 1) / kEmotionMaxCountPerPage;
            for (NSInteger i = 0; i < totalPages; i++) {
                NSUInteger loc = i * kEmotionMaxCountPerPage;
                NSUInteger len = kEmotionMaxCountPerPage;
                if (loc + len > emotions.count) {
                    len = emotions.count - loc;
                }
                NSRange range = NSMakeRange(loc, len);
                NSArray<BSEmotion *> *subEmotions = [emotions subarrayWithRange:range];
                BSEmotionItem *item = [[BSEmotionItem alloc] init];
                item.emotions = subEmotions;
                [items addObject:item];
            }
        } else if (BSEmotionType_LargePicture == model.emotionType) {
            for (NSDictionary *dicData in dataArr) {
                BSEmotionLargePicture *largePic = [BSEmotionLargePicture emotionWithDic:dicData];
                [emotions addObject:largePic];
            }
            totalPages = (emotions.count + kLargeEmotionMaxCountPerPage - 1) / kLargeEmotionMaxCountPerPage;
            for (NSInteger i = 0; i < totalPages; i++) {
                NSUInteger loc = i * kLargeEmotionMaxCountPerPage;
                NSUInteger len = kLargeEmotionMaxCountPerPage;
                if (loc + len > emotions.count) {
                    len = emotions.count - loc;
                }
                NSRange range = NSMakeRange(loc, len);
                NSArray<BSEmotion *> *subEmotions = [emotions subarrayWithRange:range];
                BSEmotionItem *item = [[BSEmotionItem alloc] init];
                item.emotions = subEmotions;
                [items addObject:item];
            }
        } else {
            NSAssert(NO, @"需要指定BSEmotionType的枚举类型");
        }
        
        group.items = items;
        [self.groups addObject:group];
        
        [self.toolbar addToolbarItem:model.toolbarItem];
    }
    
    [self.collectionView reloadData];
}

- (void)pageChangeWithIndexPath:(NSIndexPath *)indexPath
{
    self.pageControl.numberOfPages = self.groups[indexPath.section].items.count;
    self.pageControl.currentPage = indexPath.item;
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.groups.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.groups[section].items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BSEmotionKeyboardCell *cell = nil;
    BSEmotionGroup *group = self.groups[indexPath.section];
    if (BSEmotionType_SmallPicture == group.emotionType) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:smallEmotionCellID forIndexPath:indexPath];
    } else if (BSEmotionType_Emoji == group.emotionType) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:emojiEmotionCellID forIndexPath:indexPath];
    } else if (BSEmotionType_LargePicture == group.emotionType) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:largeEmotionCellID forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:emotionCellID forIndexPath:indexPath];
    }
    cell.item = self.groups[indexPath.section].items[indexPath.item];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // targetContentOffset为contentOffset的目标位置
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:*targetContentOffset];
    
    // 改变pageControl
    [self pageChangeWithIndexPath:indexPath];
    
    // 改变item
    if (self.lastIndexPath.section != indexPath.section) {
        [self.toolbar selectItemWithIndex:indexPath.section];
    }
    
    BSEmotionGroup *group = self.groups[indexPath.section];
    group.lastIndexPath = indexPath;
    
    self.lastIndexPath = indexPath;
}

#pragma mark - BSEmotionToolbarDelegate

- (void)emotionToolbar:(BSEmotionToolbar *)toolbar didSelectIndex:(NSInteger)index
{
    // 跳转到上次记忆的位置
    NSIndexPath *lastIndexPath = self.groups[index].lastIndexPath;
    
    if (!lastIndexPath) {
        lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:index];
    }
    
    [self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    [self pageChangeWithIndexPath:lastIndexPath];
}


@end
