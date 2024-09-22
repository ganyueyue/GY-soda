//
//  STMarco.h
//  Swim
//
//  Created by YY on 2022/6/28.
//

#ifndef STMarco_h
#define STMarco_h
#import "STStatus.h"

typedef void(^SXNetworkFail)(FAILCODE stateCode, NSString *error);
typedef void(^SXBoolSuccess)(BOOL value);
typedef void(^SXObjectSuccess)(id object);
typedef void(^SXArraySuccess)(NSArray *array);

const static NSNotificationName kHistoryChangeNotification = @"st.history.change.notification";

const static NSNotificationName kFavesChangeNotification = @"st.faves.change.notification";

#endif /* STMarco_h */
