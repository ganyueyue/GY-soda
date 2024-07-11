//
//  STConfigure.h
//  ECSO
//
//  Created by YY on 2024/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STConfigure : NSObject
@property (nonatomic, strong)NSDictionary *appConf;
@property (nonatomic, strong)NSArray *blockchainConfList;
@property (nonatomic, strong)NSDictionary *appVerConf;
@property (nonatomic, strong)NSArray *tokenConfList;
@property (nonatomic, strong)NSArray *recommend;
@end

NS_ASSUME_NONNULL_END
