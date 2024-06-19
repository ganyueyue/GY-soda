//
//  WMContentScrollView.m
//  lexiwed2
//
//  Created by Kyle on 2017/8/22.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "WMContentScrollView.h"

@implementation WMContentScrollView

-(instancetype)init{
    if (self = [super init]){
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

-(void)setup{

}


//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    if (self.contentOffset.y >= self.maxContentOffset && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
//        CGPoint velocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:self];
//        if(fabs(velocity.y) > fabs(velocity.x) && velocity.y<0){
//            return false;
//        }
//    }
//    return true;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
//
//        if (self.contentOffset.y >= self.maxContentOffset){
//            CGPoint velocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:gestureRecognizer.view];
//            for (UIView *view in self.subviews){
//                velocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:view];
//                if (velocity.x != 0 && velocity.y != 0){
//                    break;
//                }
//            }
//
//            if (fabs(velocity.y) > fabs(velocity.x)){
//                if (velocity.y<0){
//                    return false;
//                }
//                return true;
//            }
//
//        }else{
//            return true;
//        }
//
//
//    }
//    return false;
//}



//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//
//    if (self.contentOffset.y >= self.maxContentOffset){
//        if (([NSStringFromClass(otherGestureRecognizer.view.class) isEqualToString:@"UITableView"]||[NSStringFromClass(otherGestureRecognizer.view.class) isEqualToString:@"UITableViewWrapperView"] || [NSStringFromClass(otherGestureRecognizer.view.class) isEqualToString:@"UIScrollView"] ) && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//
//            UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)otherGestureRecognizer;
//            CGPoint velocity = [panGesture velocityInView:panGesture.view];
//            if (fabs(velocity.y) < fabs(velocity.x)){
//                return true;
//            }
//            return false;
//        }
//    }
//
//
//    return false;
//}


//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//
//
//    return NO;
//}


@end
