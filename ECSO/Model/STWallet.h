//
//  STWallet.h
//  ECSO
//
//  Created by YY on 2024/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STWallet : NSObject

@property (nonatomic, strong)NSString *tokenName;
@property (nonatomic, strong)NSString *contractAddress;
@property (nonatomic, strong)NSString *tokenIcon;
@property (nonatomic, assign)NSInteger blockchain;
@property (nonatomic, assign)NSInteger tokenConfId;
@property (nonatomic, assign)NSInteger status;

@property (nonatomic, assign)BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
