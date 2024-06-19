//
//  STMenuInfo.h
//  ECSO
//
//  Created by YY on 2024/5/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STMenuInfo : NSObject
@property (nonatomic, strong)NSString *icon;
@property (nonatomic, strong)NSString *menuName;
@property (nonatomic, strong)NSString *click;
@property (nonatomic, assign)NSInteger index;
//是否已经选中
@property (nonatomic, assign)BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
