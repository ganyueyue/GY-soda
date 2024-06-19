//
//  STUser.h
//  ECSO
//
//  Created by YY on 2024/5/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STUser : NSObject

@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSString *token;
@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSString *displayName;
@property (nonatomic, strong)NSString *portrait;
@property (nonatomic, strong)NSString *resetCode;
@property (nonatomic, assign)NSInteger balance;

@property (nonatomic, strong)NSArray *wallets;

@end

NS_ASSUME_NONNULL_END
