//
//  STCacheManager.m
//  ECSO
//
//  Created by YY on 2024/5/29.
//

#import "STCacheManager.h"
#import "STWebInfo.h"
#import "STWallet.h"
@implementation STCacheManager

static STCacheManager* _instance = nil;
static FMDatabase *_db;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    return _instance ;
}

-(id)init{
    if(self = [super init]){
        NSString *path_document = NSHomeDirectory();
        NSString *filePath = [path_document stringByAppendingString:@"/Documents/ecso.sqlite"];
        _db = [FMDatabase databaseWithPath:filePath];
        if ([_db open]) {
            NSLog(@"打开数据库成功");
            // 自增主键、userID、二进制数据流
            NSString *sql = @"create table if not exists t_news (id integer primary key autoincrement,userID text,dict blob,url text);";
            BOOL success = [_db executeUpdate:sql];
            if (success) {
                NSLog(@"创建表成功");
            }else{
                NSLog(@"创建表失败");
            }
        }else{
            NSLog(@"打开数据库失败");
        }
    }
    return self;
}

- (NSString *)getUUID {
//    [SAMKeychain deletePasswordForService:@"web3" account:@"clientId"];
    //缓存UUID到本地
    NSString *uuid = [SAMKeychain passwordForService:@"web3" account:@"clientId1"];
    if (uuid.length <= 0) {
        uuid = [[[UIDevice currentDevice].identifierForVendor UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if (uuid.length >= 32) {
            uuid = [uuid substringToIndex:32];
        } else {
            NSInteger index = 32 - uuid.length;
            NSInteger num = powf(10, index);
            NSInteger hh = arc4random() % num;
            uuid = [NSString stringWithFormat:@"%@%ld",uuid,hh];
        }
        [SAMKeychain setPassword:uuid forService:@"web3" account:@"clientId1"];
    }
    return [NSString stringWithFormat:@"%@%@",uuid,[NSString md5:uuid]];
}

- (void)saveCache:(NSString *)title withUrl:(NSString *)url withIcon:(NSString *)icon {
    //判断数据库是否有
    BOOL success = [_db executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_news WHERE userID = '001' AND url = '%@';",url]];
    if (success) {
        NSLog(@"删除成功");
    }
    
    NSDictionary * newsDic = @{
        @"title":title,
        @"url":url,
        @"icon":icon
    };
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:newsDic requiringSecureCoding:YES error:nil];
    if (data == nil) {
        return;
    }
    if ([_db executeUpdate:@"insert into t_news (userID,dict,url) values(?,?,?)",@"001",data,url]) {
        NSLog(@"插入成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:kHistoryChangeNotification object:nil userInfo:nil];
    }else{
        NSLog(@"插入失败");
    }
}

- (NSArray *)getHistory {
    FMResultSet *set = [_db executeQuery:@"select * from t_news where userID = '001' order by id desc;"];
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(dic){
            STWebInfo *info = [STWebInfo mj_objectWithKeyValues:dic];
            [array addObject:info];
        }
    }
    return array;
}

- (void)deleteCache:(NSString *)url {
    //判断数据库是否有
    BOOL success = [_db executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_news WHERE userID = '001' AND url = '%@';",url]];
    if (success) {
        NSLog(@"删除成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:kHistoryChangeNotification object:nil userInfo:nil];
    }
}

- (void)deleteHistory {
    BOOL success = [_db executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_news WHERE userID = '001';"]];
    if (success) {
        NSLog(@"删除成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:kHistoryChangeNotification object:nil userInfo:nil];
    }
}
//存钱包地址
- (void)saveWallers:(NSArray *)list {
    NSData *d = [NSKeyedArchiver archivedDataWithRootObject:list requiringSecureCoding:YES error:nil];
    BOOL result = [SAMKeychain setPasswordData:d forService:@"web3" account:@"account"];
    NSLog(@"%d",result);
}
//取钱包地址
- (NSArray *)getWallers {
    NSData *data = [SAMKeychain passwordDataForService:@"web3" account:@"account"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSArray *infos = [STWallet mj_objectArrayWithKeyValuesArray:arr];
    return infos;
}
//存区块链网络
- (void)saveBlockChain:(NSArray *)list {
    NSData *d = [NSKeyedArchiver archivedDataWithRootObject:list requiringSecureCoding:YES error:nil];
    BOOL result = [SAMKeychain setPasswordData:d forService:@"web3" account:@"blockchain"];
    NSLog(@"%d",result);
}
//取区块链网络
- (NSArray *)getBlockChains {
    NSData *data = [SAMKeychain passwordDataForService:@"web3" account:@"blockchain"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSArray *infos = [STBlockChain mj_objectArrayWithKeyValuesArray:arr];
    return infos;
}


- (void)saveAPPInfo:(NSDictionary *)dict {
    NSData *d = [NSKeyedArchiver archivedDataWithRootObject:dict requiringSecureCoding:YES error:nil];
    BOOL result = [SAMKeychain setPasswordData:d forService:@"web3" account:@"appInfo"];
    NSLog(@"%d",result);
}

- (STAPPInfo *)getAPPInfo {
    NSData *data = [SAMKeychain passwordDataForService:@"web3" account:@"appInfo"];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    STAPPInfo *info = [STAPPInfo mj_objectWithKeyValues:dict];
    return info;
}

- (void)saveFavesCache:(NSString *)title withUrl:(NSString *)url withIcon:(NSString *)icon {
    //判断数据库是否有
    BOOL success = [_db executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_news WHERE userID = '003' AND url = '%@';",url]];
    if (success) {
        NSLog(@"删除成功");
    }
    
    NSDictionary * newsDic = @{
        @"title":title,
        @"url":url,
        @"icon":icon
    };
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:newsDic requiringSecureCoding:YES error:nil];
    if (data == nil) {
        return;
    }
    if ([_db executeUpdate:@"insert into t_news (userID,dict,url) values(?,?,?)",@"003",data,url]) {
        NSLog(@"插入成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:kFavesChangeNotification object:nil userInfo:nil];
    }else{
        NSLog(@"插入失败");
    }
}


//保存删除后的收藏列表
- (void)saveCacheFaves:(NSArray *)list {
    BOOL success = [_db executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_news WHERE userID = '003';"]];
    if (success) {
        NSLog(@"删除成功");
    }
    if (list.count <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFavesChangeNotification object:nil userInfo:nil];
        return;
    }
    for (STWebInfo *info in list) {
        NSDictionary * newsDic = [info mj_keyValues];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:newsDic requiringSecureCoding:YES error:nil];
        if (data == nil) {
            return;
        }
        BOOL success = [_db executeUpdate:@"insert into t_news (userID,dict,url) values(?,?,?)",@"003",data,info.url];
        if (success) {
            NSLog(@"插入成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:kFavesChangeNotification object:nil userInfo:nil];
        }else{
            NSLog(@"插入失败");
        }
    }
}

- (void)deleteFaves:(NSString *)url {
    //判断数据库是否有
    BOOL success = [_db executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_news WHERE userID = '003' AND url = '%@';",url]];
    if (success) {
        NSLog(@"删除成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:kFavesChangeNotification object:nil userInfo:nil];
    }
}

- (NSArray *)getFaves {
    FMResultSet *set = [_db executeQuery:@"select * from t_news where userID = '003' order by id desc;"];
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(dic){
            STWebInfo *info = [STWebInfo mj_objectWithKeyValues:dic];
            [array addObject:info];
        }
    }
    return array;
}

- (void)saveRecommendCache:(NSArray *)recommend {
    BOOL success = [_db executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_news WHERE userID = '002';"]];
    if (success) {
        NSLog(@"删除成功");
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:recommend requiringSecureCoding:YES error:nil];
    if (data == nil) {
        return;
    }
    if ([_db executeUpdate:@"insert into t_news (userID,dict) values(?,?)",@"002",data]) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
}

- (NSArray *)getRecommend {
    FMResultSet *set = [_db executeQuery:@"select * from t_news where userID = '002' order by id desc;"];
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSArray *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(dic){
            array = [STWebInfo mj_objectArrayWithKeyValuesArray:dic];
        }
    }
    return array;
}

//保存用户图片
- (void)saveImageCache:(UIImage *)image {
    NSString *path_document = NSHomeDirectory();
    NSString *imagePath = [path_document stringByAppendingString:@"/Documents/pic.png"];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImageJPEGRepresentation(image, 0.2) writeToFile:imagePath atomically:YES];
}

- (UIImage *)getSodaImage {
    NSString *path_document = NSHomeDirectory();
    NSString *imagePath = [path_document stringByAppendingString:@"/Documents/pic.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

@end
