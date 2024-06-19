//
//  STAPPInfo.h
//  ECSO
//
//  Created by YY on 2024/6/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STAPPInfo : NSObject

@property (nonatomic, assign)NSInteger appConfId;
@property (nonatomic, strong)NSString *appStartImage;
@property (nonatomic, strong)NSString *appStartUrl;
@property (nonatomic, strong)NSString *appImUrl;
@property (nonatomic, strong)NSString *appPrivacyPolicyUrl;
@property (nonatomic, strong)NSString *appUserAgreementUrl;
@property (nonatomic, strong)NSString *appDisclaimerUrl;
@property (nonatomic, strong)NSString *appIntroUrl;
@property (nonatomic, strong)NSString *language;
@property (nonatomic, assign)NSInteger scoreOp;
@property (nonatomic, strong)NSString *blackUrlRedir;
@property (nonatomic, assign)NSInteger verNo;
@property (nonatomic, strong)NSString *downloadUrl;

@end

NS_ASSUME_NONNULL_END
