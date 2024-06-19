//
//  STCall.h
//  ECSO
//
//  Created by YY on 2024/5/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STCall : NSObject

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *attach;
@property (nonatomic, strong)NSDictionary *args;

@end

NS_ASSUME_NONNULL_END
