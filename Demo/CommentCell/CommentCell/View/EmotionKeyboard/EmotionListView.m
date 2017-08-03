//
//  EmotionListView.m
//  CommentCell
//
//  Created by power on 2017/5/26.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "EmotionListView.h"

#import "Emotion.h"
#import "EmotionContainerView.h"
#import "EmotionConst.h"

@interface EmotionListView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation EmotionListView

+ (EmotionListView *)listView
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
        pageControl.defersCurrentPageDisplay = YES;
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
    }
    return self;
}

- (void)setEmotions:(NSArray<Emotion *> *)emotions
{
    _emotions = emotions;
    
    NSInteger totalPages = (emotions.count + EmotionMaxCountPerPage - 1) / EmotionMaxCountPerPage;
    self.pageControl.numberOfPages = totalPages;
    self.pageControl.currentPage = 0;
    
    if (self.scrollView.subviews.count < totalPages) { // 不够
        for (int i = 0; i < totalPages; i++) {
            EmotionContainerView *containerView = nil;
            if (i < self.scrollView.subviews.count) {
                containerView = self.scrollView.subviews[i];
            } else {
                containerView = [[EmotionContainerView alloc] init];
                [self.scrollView addSubview:containerView];
            }
            containerView.hidden = NO;
            
            NSUInteger loc = i * EmotionMaxCountPerPage;
            NSUInteger len = EmotionMaxCountPerPage;
            if (loc + len > emotions.count) {
                len = emotions.count - loc;
            }
            NSRange range = NSMakeRange(loc, len);
            NSArray<Emotion *> *subEmotions = [emotions subarrayWithRange:range];
            containerView.subEmotions = subEmotions;
        }
    } else {
        for (int i = 0; i < self.scrollView.subviews.count; i++) {
            EmotionContainerView *containerView = self.scrollView.subviews[i];
            if (i < totalPages) {
                containerView.hidden = NO;
                NSUInteger loc = i * EmotionMaxCountPerPage;
                NSUInteger len = EmotionMaxCountPerPage;
                if (loc + len > emotions.count) {
                    len = emotions.count - loc;
                }
                NSRange range = NSMakeRange(loc, len);
                NSArray<Emotion *> *subEmotions = [emotions subarrayWithRange:range];
                containerView.subEmotions = subEmotions;
            } else {
                containerView.hidden = YES;
            }
        }
    }
    
    [self setNeedsLayout];
    
    [self.scrollView setContentOffset:CGPointZero];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat pageControlH = 30.0f;
    self.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - pageControlH);
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), self.bounds.size.width, pageControlH);
    
    self.scrollView.contentSize = CGSizeMake(self.pageControl.numberOfPages * self.bounds.size.width, 0);
    
    for (int i = 0; i < self.pageControl.numberOfPages; i++) {
        EmotionContainerView *containerView = self.scrollView.subviews[i];
        containerView.frame = CGRectMake(self.bounds.size.width * i, 0, self.bounds.size.width, self.bounds.size.height - 30);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5);
}


@end
