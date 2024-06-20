//
//  STPopoverView.m
//  Swim
//
//  Created by YY on 2022/3/14.
//

#import "STPopoverView.h"
#import "STCommonViewCell.h"
#import "STMenuInfo.h"
@interface STPopoverView () <UITableViewDelegate,UITableViewDataSource>
@end

@implementation STPopoverView

- (void)setup {
    [super setup];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self);
        make.top.equalTo(self).offset(10);
    }];
    
}

- (UITableView *)tableView {
    if (_tableView != nil){
        return _tableView;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.allowsSelection = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 75;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.layer.cornerRadius = 5;
    _tableView.clipsToBounds = true;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = false;
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView registerClass:[STCommonViewCell class] forCellReuseIdentifier:[STCommonViewCell className]];
    return _tableView;
}

- (void)setDataArray:(NSArray *)dataArray {
    if (_dataArray == dataArray) {
        return;
    }
    _dataArray = dataArray;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STCommonViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[STCommonViewCell className]];
    STMenuInfo *info = self.dataArray[indexPath.row];
    if (info.index == 4) {
        if (info.isSelected) {
            cell.iconView.contentMode = UIViewContentModeCenter;
            cell.iconView.image = [UIImage imageNamed:@"icon_menu_fav"];
            cell.titleLabel.text = @"已收藏".string;
            cell.titleLabel.textColor = HexRGB(0x292F48);
        } else {
            if ([info.icon containsString:@"http"]) {
                [cell.iconView sx_setImagePlaceholdWithURL:info.icon];
                cell.iconView.contentMode = UIViewContentModeScaleAspectFit;
            } else if ([info.icon containsString:@"res@"]) {
                NSString *iconString = [info.icon stringByReplacingOccurrencesOfString:@"res@" withString:@""];
                cell.iconView.image = [UIImage imageNamed:iconString];
                cell.iconView.contentMode = UIViewContentModeCenter;
            } else {
                cell.iconView.image = [UIImage imageNamed:info.icon];
                cell.iconView.contentMode = UIViewContentModeCenter;
            }
            cell.titleLabel.textColor = HexRGBA(0x292F48, 0.4);
            cell.titleLabel.text = info.menuName;
        }
    } else {
        if ([info.icon containsString:@"http"]) {
            [cell.iconView sx_setImagePlaceholdWithURL:info.icon];
            cell.iconView.contentMode = UIViewContentModeScaleAspectFit;
        } else if ([info.icon containsString:@"res@"]) {
            NSString *iconString = [info.icon stringByReplacingOccurrencesOfString:@"res@" withString:@""];
            cell.iconView.image = [UIImage imageNamed:iconString];
            cell.iconView.contentMode = UIViewContentModeCenter;
        } else {
            cell.iconView.image = [UIImage imageNamed:info.icon];
            cell.iconView.contentMode = UIViewContentModeCenter;
        }
        
        if (info.index == 0 && info.isSelected) {
            cell.iconView.image = [UIImage imageNamed:@"icon_menu_back_nor"];
            cell.titleLabel.textColor = HexRGBA(0x292F48, 0.4);
        } else if (info.index == 1 && info.isSelected) {
            cell.iconView.image = [UIImage imageNamed:@"icon_menu_forward_nor"];
            cell.titleLabel.textColor = HexRGBA(0x292F48, 0.4);
        } else {
            cell.titleLabel.textColor = HexRGB(0x292F48);
        }
        
        cell.titleLabel.text = info.menuName;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    STMenuInfo *info = self.dataArray[indexPath.row];
    if (self.clickBlock) {
        self.clickBlock(info);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

@end
