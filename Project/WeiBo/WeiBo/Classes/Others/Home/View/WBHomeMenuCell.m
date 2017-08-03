//
//  WBHomeMenuCell.m
//  WeiBo
//
//  Created by wbs on 17/3/7.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBHomeMenuCell.h"

#import "WBHomeMenuItem.h"

@interface WBHomeMenuCell ()

@property (weak, nonatomic) IBOutlet UIButton *itemButton;
- (IBAction)buttonClick;

@end

@implementation WBHomeMenuCell

+ (WBHomeMenuCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"menuCell";
    WBHomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setItem:(WBHomeMenuItem *)item
{
    _item = item;
    
    if (item.itemName) {
        [self.itemButton setTitle:item.itemName forState:UIControlStateNormal];
    } else {
        
    }
    
    if (item.imageString) {
        [self.itemButton setImage:[UIImage imageNamed:item.imageString] forState:UIControlStateNormal];
    } else {
        
    }
    
    if (item.selectedImageString) {
        [self.itemButton setImage:[UIImage imageNamed:item.selectedImageString] forState:UIControlStateSelected];
    } else {
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.itemButton.selected = selected;
}

- (IBAction)buttonClick {
    if (self.delegate) {
        [self.delegate homeMenuCell:self didClickButtonWithIndexPath:self.indexPath];
    }
}

@end
