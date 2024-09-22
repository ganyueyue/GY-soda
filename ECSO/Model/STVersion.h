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
@property (nonatomic, strong)NSString *iosUrl;
@property (nonatomic, assign)NSInteger verForceUpgrade;
@property (nonatomic, assign)NSInteger verNo;
@end

NS_ASSUME_NONNULL_END
