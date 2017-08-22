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
    [self.toolbar removeAllToolbarItems];
    [self initialPageControl];
    
    for (BSEmotionModel *model in emotionModels) {
        BSEmotionGroup *group = [self groupWithEmotion:model];
        [self.groups addObject:group];
        [self.toolbar addToolbarItem:model.toolbarItem];
    }
    
    if (self.groups.count) {
        [self.toolbar selectToolbarItemAtIndex:0];
    }
    
    [self.collectionView reloadData];
}

- (void)initialPageControl
{
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 0;
}

- (void)pageChangeWithIndexPath:(NSIndexPath *)indexPath
{
    self.pageControl.numberOfPages = self.groups[indexPath.section].items.count;
    self.pageControl.currentPage = indexPath.item;
}

- (void)addEmotion:(BSEmotionModel *)emotionModel
{
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.emotionModels];
    [tempArr addObject:emotionModel];
    _emotionModels = tempArr;
    
    BSEmotionGroup *group = [self groupWithEmotion:emotionModel];
    [self.groups addObject:group];
    NSInteger index = self.groups.count - 1;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [self.collectionView insertSections:indexSet];
    [self.toolbar addToolbarItem:emotionModel.toolbarItem];
    
    [self.toolbar selectToolbarItemAtIndex:index];
}

- (void)insertEmotion:(BSEmotionModel *)emotionModel atIndex:(NSInteger)index
{
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.emotionModels];
    [tempArr insertObject:emotionModel atIndex:index];
    _emotionModels = tempArr;
    
    BSEmotionGroup *group = [self groupWithEmotion:emotionModel];
    [self.groups insertObject:group atIndex:index];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [self.collectionView insertSections:indexSet];
    [self.toolbar insertToolbarItem:emotionModel.toolbarItem atIndex:index];
}

- (void)removeEmotionAtIndex:(NSInteger)index
{
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.emotionModels];
    [tempArr removeObjectAtIndex:index];
    _emotionModels = tempArr;
    
    [self.groups removeObjectAtIndex:index];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [self.collectionView deleteSections:indexSet];
    [self.toolbar removeToolbarItemAtIndex:index];
    
    NSInteger count = self.groups.count;
    if (count) {
        if (self.lastIndexPath.section != index) { // 删除的不是选中的
            if (index == count) { // 删除的最后一个
                return;
            } else {
                self.lastIndexPath = [NSIndexPath indexPathForRow:self.lastIndexPath.row inSection:self.lastIndexPath.section - 1];
                for (NSInteger i = index; i < count; i++) {
                    BSEmotionGroup *group = self.groups[i];
                    NSIndexPath *lastIndexPath = group.lastIndexPath;
                    NSIndexPath *newLastIndexPath = [NSIndexPath indexPathForRow:lastIndexPath.row inSection:i];
                    group.lastIndexPath = newLastIndexPath;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView scrollToItemAtIndexPath:self.lastIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                });
            }
        } else { // 删除的是选中的
            if (index == count) { // 删除的最后一个
                [self.toolbar selectToolbarItemAtIndex:count - 1];
            } else {
                for (NSInteger i = index; i < count; i++) {
                    BSEmotionGroup *group = self.groups[i];
                    NSIndexPath *lastIndexPath = group.lastIndexPath;
                    NSIndexPath *newLastIndexPath = [NSIndexPath indexPathForRow:lastIndexPath.row inSection:i];
                    group.lastIndexPath = newLastIndexPath;
                }
                [self.toolbar selectToolbarItemAtIndex:index];
            }
        }
    } else {
        [self initialPageControl];
    }
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (BSEmotionGroup *)groupWithEmotion:(BSEmotionModel *)emotionModel
{
    BSEmotionGroup *group = [[BSEmotionGroup alloc] init];
    NSInteger section = [self.emotionModels indexOfObject:emotionModel];
    group.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    group.emotionType = emotionModel.emotionType;
    
    NSString *plist = [[NSBundle mainBundle] pathForResource:emotionModel.plistDirectory ofType:nil];
    NSArray<NSDictionary *> *dataArr = [NSArray arrayWithContentsOfFile:plist];
    
    NSMutableArray<BSEmotion *> *emotions = [NSMutableArray array];
    NSMutableArray<BSEmotionItem *> *items = [NSMutableArray array];
    NSInteger totalPages = 0;
    if (BSEmotionType_SmallPicture == emotionModel.emotionType) {
        for (NSDictionary *dicData in dataArr) {
            BSEmotionSmallPicture *smallPic = [BSEmotionSmallPicture emotionWithDic:dicData];
            smallPic.directory = [emotionModel.directory copy];
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
    } else if (BSEmotionType_Emoji == emotionModel.emotionType) {
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
    } else if (BSEmotionType_LargePicture == emotionModel.emotionType) {
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
    
    return group;
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
        [self.toolbar selectToolbarItemAtIndex:indexPath.section];
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    });
    
    self.lastIndexPath = lastIndexPath;
    
    [self pageChangeWithIndexPath:lastIndexPath];
}


@end
