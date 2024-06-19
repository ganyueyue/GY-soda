//
//  STNavtionItem.h
//  Swim
//
//  Created by GanYue on 2022/3/13.
//

#import "STView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^STNavgationBlock)(NSInteger);

@interface STNavtionItem : STView
@property (nonatomic, copy)STNavgationBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
