//
//  STBaseCollectionViewCell.m
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import "STBaseCollectionViewCell.h"

@implementation STBaseCollectionViewCell

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
}

-(NSIndexPath *)indexPath{

    UIView *superView = self.superview;
    UICollectionView *superTableView = nil;

    while (superView != nil) {
        if ([superView isKindOfClass:[UICollectionView class]]){
            superTableView = (UICollectionView *)superView;
            break;
        }
        superView = superView.superview;
    }

    if (superTableView ==nil){
        return nil;
    }
    return [superTableView indexPathForCell:self];

}

@end
