//
//  WBStatusCell.m
//  WeiBo
//
//  Created by wbs on 17/2/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBStatusCell.h"

#import "WBStatusDetailView.h"
#import "WBStatusFrame.h"
#import "WBStatusToolBar.h"

@interface WBStatusCell ()

@property (nonatomic, weak) WBStatusDetailView *detailView;
@property (nonatomic, weak) WBStatusToolBar *toolBar;
@property (nonatomic, weak) UIView *line;

@end

@implementation WBStatusCell

+ (WBStatusCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"statusCell";
    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = kStatusToTalBackgroundViewColor;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
        
    }
    return self;
}

- (void)createView
{
    WBStatusDetailView *detailView = [[WBStatusDetailView alloc] init];
    [self.contentView addSubview:detailView];
    self.detailView = detailView;
    
    WBStatusToolBar *toolBar = [WBStatusToolBar statusToolBar];
    toolBar.backgroundColor = kCSSHexColor(@"#FFFFFF");
    toolBar.layer.borderWidth = 0.5;
    toolBar.layer.borderColor = kCSSHexColor(@"#DDDDDD").CGColor;
    [self.contentView addSubview:toolBar];
    self.toolBar = toolBar;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBaseViewControllerBackgroundColor;
    [self addSubview:line];
    self.line = line;
}

- (void)setStatusFrame:(WBStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    self.detailView.detailFrame = statusFrame.detailFrame;
    self.toolBar.frame = statusFrame.toolBarFrame;
    self.line.frame = statusFrame.lineFrame;
    
    self.toolBar.status = statusFrame.status;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
