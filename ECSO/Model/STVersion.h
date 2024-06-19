//
//  STVersion.h
//  ECSO
//
//  Created by YY on 2024/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STVersion : NSObject
@property (nonatomic, strong)NSString *verStr;
@property (nonatomic, strong)NSString *verDesc;
@property (nonatomic, strong)NSString *verUrl;
@property (nonatomic, assign)NSInteger verId;
@property (nonatomic, assign)NSInteger verPlat;
@property (nonatomic, assign)NSInteger verForceUpgrade;
@property (nonatomic, assign)NSInteger verPublishTime;
@property (nonatomic, assign)NSInteger verNo;
@end

NS_ASSUME_NONNULL_END
