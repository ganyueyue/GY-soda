//
//  STVersionManager.h
//  Swim
//
//  Created by YY on 2022/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STVersionManager : NSObject

//审核字段，如果为true，表示审核中，反之为已审核通过

+ (instancetype)shareManager;
- (void)appVersionUpdate;
@end

NS_ASSUME_NONNULL_END
