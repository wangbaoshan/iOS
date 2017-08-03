//
//  DemoViewController10.m
//  Sharp Time
//
//  Created by power on 2017/7/23.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "DemoViewController10.h"

#import "AVSpeechCotroller.h"

@interface DemoViewController10 () <UITableViewDataSource, AVSpeechSynthesizerDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) AVSpeechCotroller *speechCotroller;
@property (nonatomic, strong) NSMutableArray<AVSpeechUtterance *> *utterances;

@end

@implementation DemoViewController10

- (void)dealloc
{
    STLogMothodFunc;
}

- (NSMutableArray<AVSpeechUtterance *> *)utterances
{
    if (!_utterances) {
        _utterances = [NSMutableArray arrayWithCapacity:0];
    }
    return _utterances;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // UI
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStylePlain];
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.speechCotroller = [[AVSpeechCotroller alloc] init];
    self.speechCotroller.synthesizer.delegate = self;
    [self.speechCotroller beginConversation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.speechCotroller.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.utterances.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.numberOfLines = 0;
    }
    cell.textLabel.text = self.utterances[indexPath.row].speechString;
    return cell;
}

#pragma mark - AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    [self.utterances addObject:utterance];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.utterances indexOfObject:utterance] inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance
{
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance
{
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(nonnull AVSpeechUtterance *)utterance
{
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"willSpeak---%@---%@", utterance.speechString, NSStringFromRange(characterRange));
}


@end
