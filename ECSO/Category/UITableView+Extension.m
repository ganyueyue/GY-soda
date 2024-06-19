//
//  UITableView+Extension.m
//  lexiwed2
//
//  Created by Kyle on 2017/4/13.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView(Extension)

-(void)setAndLayoutTableHeaderView{

    UIView *headerView = self.tableHeaderView;
    if (headerView != nil){
   
        CGFloat height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        CGRect frame = headerView.frame;
        frame.size.height = height;
        headerView.frame = frame;
        self.tableHeaderView = headerView;
    }
    
}


@end
