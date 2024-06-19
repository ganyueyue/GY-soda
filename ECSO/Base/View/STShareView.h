//
//  STShareView.h
//  Swim
//
//  Created by YY on 2022/3/14.
//

#import "STView.h"
@class STShare;
@class STSharePlatform;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, STShareType) {
    STShareTypeNO,
    STShareTypeWechat,
    STShareTypeQQ,
    STShareTypeWeiBo,
    STShareTypeCopy
};

typedef void(^STShareClick)(STSharePlatform *info);

@interface STShareView : STView

@property (nonatomic, strong)NSArray *dataArray;

@property (nonatomic, assign) CGFloat contentViewHeight;

@property (nonatomic, copy)STShareClick shareClick;

-(void)show;

@end

NS_ASSUME_NONNULL_END
