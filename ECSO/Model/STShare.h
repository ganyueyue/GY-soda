//
//  STShare.h
//  Swim
//
//  Created by YY on 2022/3/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 分享平台//分享到何处
 */
@interface STSharePlatform : NSObject
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *icon;
@property (nonatomic, strong)NSString *scheme;

+ (STSharePlatform *)createShareName:(NSString *)name withShareIcon:(NSString *)icon withScheme:(NSString *)scheme;

@end
/*
 分享信息
    url:"实际访问地址"
    img:"当type为image时或mode=sdk时，图片URL"
    title:"当是code模式时，这是口令明文部分"
    desc:"mode=sdk时，图文中的描述部分"
 */
@interface STShareInfo : NSObject
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSString *image;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSString *data;
@property (nonatomic, strong)NSString *icon;
@end


@interface STShare : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) STShareInfo *info;
@property (nonatomic, strong) NSArray <STSharePlatform *>*list;
@end

NS_ASSUME_NONNULL_END
