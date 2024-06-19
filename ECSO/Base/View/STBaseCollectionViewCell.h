//
//  STBaseCollectionViewCell.h
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface STBaseCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)NSIndexPath *indexPath;

- (void)setup;
@end

NS_ASSUME_NONNULL_END
