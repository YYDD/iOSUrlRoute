//
//  SDCUrlRouteConfig.h
//  newCampus
//
//  Created by YYDD on 16/3/10.
//  Copyright © 2016年 com.campus.cn. All rights reserved.
//

#ifndef SDCUrlRouteConfig_h
#define SDCUrlRouteConfig_h


typedef enum
{
    kUrlRedirectPush = 1,   /**< push操作 */
    kUrlRedirectPop = 2,    /**< pop操作 */
    kUrlRedirectPresent = 3,    /**< present 操作 */
    kUrlRedirectDismiss = 4,    /**< dismissViewController 操作 */
}UrlRedirectType;




#define SDCRoutePushToVC(ViewController,beAnimated)\
UINavigationController *nav = [UIApplication sharedApplication].currentViewController.navigationController;\
NSAssert(nav != nil,@"****just UINavigationController can use push and pop****");\
[nav pushViewController:ViewController animated:beAnimated];


#define SDCRoutePopVC(beAnimated)\
UINavigationController *nav = [UIApplication sharedApplication].currentViewController.navigationController;\
NSAssert(nav != nil,@"****just UINavigationController can use push and pop****");\
[nav popViewControllerAnimated:beAnimated]



#define SDCRoutePopToRoot(beAnimated)\
UINavigationController *nav = [UIApplication sharedApplication].currentViewController.navigationController;\
NSAssert(nav != nil,@"****just UINavigationController can use push and pop****");\
[nav popToRootViewControllerAnimated:beAnimated];



#define SDCRoutePopToVC(ViewController,beAnimated)\
UINavigationController *nav = [UIApplication sharedApplication].currentViewController.navigationController;\
NSAssert(nav != nil,@"****just UINavigationController can use push and pop****");\
[nav popToViewController:ViewController animated:beAnimated];


#define SDCRoutePresentToVC(ViewController,beAnimated)\
UINavigationController *nav = [UIApplication sharedApplication].currentViewController.navigationController;\
NSAssert(nav != nil,@"****just UINavigationController can use push and pop****");\
CATransition *transition = [CATransition animation];\
transition.duration = 0.35f;\
transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];\
transition.type = kCATransitionMoveIn;\
transition.subtype = kCATransitionFromTop;\
[nav.view.layer addAnimation:transition forKey:nil];\
[nav pushViewController:vc animated:NO];\


#define SDCRouteDismissToVC(beAnimated)\
UINavigationController *nav = [UIApplication sharedApplication].currentViewController.navigationController;\
NSAssert(nav != nil,@"****just UINavigationController can use push and pop****");\
CATransition *transition = [CATransition animation];\
transition.duration = 0.35f;\
transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];\
transition.type = kCATransitionReveal;\
transition.subtype = kCATransitionFromBottom;\
[nav.view.layer addAnimation:transition forKey:nil];\
[nav popViewControllerAnimated:NO];\


//webview的标题
static const NSString *sdcNavTitleKey = @"navTitle";



#endif /* SDCUrlRouteConfig_h */
