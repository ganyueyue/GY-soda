//
//  STCacheManager.h
//  ECSO
//
//  Created by YY on 2024/5/29.
//

#import <Foundation/Foundation.h>
#import "STAPPInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface STCacheManager : NSObject

+(instancetype) shareInstance;

- (NSString *)getUUID;

- (NSArray *)getHistory;

- (void)deleteHistory;

- (void)deleteCache:(NSString *)url;

- (void)saveCache:(NSString *)title withUrl:(NSString *)url withIcon:(NSString *)icon;

- (NSArray *)getFaves;

- (void)deleteFaves:(NSString *)url;

//保存删除后的收藏列表
- (void)saveCacheFaves:(NSArray *)list;

- (void)saveFavesCache:(NSString *)title withUrl:(NSString *)url withIcon:(NSString *)icon;

- (void)saveWallers:(NSArray *)list;

- (NSArray *)getWallers;

- (void)saveAPPInfo:(NSDictionary *)dict;

- (STAPPInfo *)getAPPInfo;


//存区块链网络
- (void)saveBlockChain:(NSArray *)list;
//取区块链网络
- (NSArray *)getBlockChains;

//保存用户图片
- (void)saveImageCache:(UIImage *)image;

- (UIImage *)getSodaImage;

- (void)saveRecommendCache:(NSArray *)recommend;

- (NSArray *)getRecommend;

@end

NS_ASSUME_NONNULL_END
