//
//  STBlockChain.h
//  ECSO
//
//  Created by YY on 2024/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STBlockChain : NSObject

@property (nonatomic, assign)NSInteger blockchainConfId;
@property (nonatomic, assign)NSInteger blockchain;
@property (nonatomic, assign)NSInteger chainId;
@property (nonatomic, assign)NSInteger status;
@property (nonatomic, strong)NSString *rpcUrl;
@property (nonatomic, strong)NSString *scanUrl;
@property (nonatomic, strong)NSString *token;
@property (nonatomic, strong)NSString *icon;
@property (nonatomic, strong)NSString *blockchainName;


@end

NS_ASSUME_NONNULL_END
