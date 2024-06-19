//
//  STEnum.h
//  Swim
//
//  Created by YY on 2022/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STEnum : NSObject

typedef NS_ENUM(NSUInteger,STPullState){
    STPullStateNO,
    STPullStateIdle,
    STPullStateNoMoreDate,
};

typedef NS_ENUM(NSUInteger,STCreateState){
    STCreateStateNO,        //从引导页进入
    STCreateStateUser,      //从个人中心进去
    STCreateStateDetail     //从账户详情进入
};

typedef NS_ENUM(NSUInteger,STWebState){
    STWebStateNO,
    STWebStateAPP
};

typedef NS_ENUM(NSUInteger,STEmailState){
    STEmailStateNO,
    STEmailStateCode,
    STEmailStateAuth,
    STEmailStateAuthed
};

typedef NS_ENUM(NSUInteger,STWalletState){
    STWalletStateNO,
    STWalletStateIng,
    STWalletStateSuccess,
    STWalletStateFail
};

typedef NS_ENUM(NSUInteger,STAuthState){
    STAuthStateNO,
    STAuthStateDelete,      //删除账号
    STAuthStateLook,        //查看私钥
    STAuthStateTransfer,    //转移CFX
};

typedef NS_ENUM(NSUInteger,STPWDState){
    STPWDStateNO,           //两者都可以
    STPWDStatePWD,          //密码输入
    STPWDStateFace,         //面容
};


@end

NS_ASSUME_NONNULL_END
