//
//  STPageViewController.h
//  Swim
//
//  Created by YY on 2022/3/23.
//

#import "WMPageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface STPageViewController : WMPageController
@property (nonatomic, assign,readonly) NSInteger currentPageIndex;
@property (nonatomic, strong) NSArray *subViewControllers;
@end

NS_ASSUME_NONNULL_END
