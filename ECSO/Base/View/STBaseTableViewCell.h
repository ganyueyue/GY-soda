//
//  STBaseTableViewCell.h
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface STBaseTableViewCell : UITableViewCell
@property (nonatomic, readonly) NSIndexPath *indexPath;
@property (nonatomic, readonly) UIView *lineView;
@property (nonatomic, assign) CGFloat lineHeight; // <= 0 隐藏 line

@property (nonatomic, assign) UIEdgeInsets lineEdge;

-(void)setup;
@end

NS_ASSUME_NONNULL_END
