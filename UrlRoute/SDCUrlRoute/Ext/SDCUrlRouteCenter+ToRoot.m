//
//  SDCUrlRouteCenter+ToRoot.m
//  UrlRouteSample
//
//  Created by YYDD on 2017/1/12.
//  Copyright © 2017年 com.shudong.urlRoute. All rights reserved.
//

#import "SDCUrlRouteCenter+ToRoot.h"
#import "SDCJLRouteData.h"
#import "UIApplication+SDCUrlRoute.h"
#import "UIViewController+SDCUrlRoute.h"

@implementation SDCUrlRouteCenter (ToRoot)

- (void)toRoot:(NSString *)urlStr WithParameters:(NSDictionary *)param {

    [[SDCJLRouteData sharedData]checkRouteWithUrl:urlStr WithExtraParameters:param WithBlock:^(NSString *routeUrlStr) {
       
        if (routeUrlStr) {
            
            [UIApplication sharedApplication].currentViewController = nil;
            SDCRoutePopToRoot(NO);
            
            id vc=[UIApplication sharedApplication].keyWindow.rootViewController;
            if ([vc isKindOfClass:[UITabBarController class]]) {
                UITabBarController *tab=(UITabBarController *)vc;
                for (UINavigationController *nav in tab.viewControllers) {
                    UIViewController *navRootVC = [nav.childViewControllers firstObject];
                    if (navRootVC.routeUrlStr && [nav.routeUrlStr isEqualToString:routeUrlStr]) {
                        NSInteger index = [tab.viewControllers indexOfObject:nav];
                        [tab setSelectedIndex:index];
                    }
                }
            }
        }
    }];
}






@end
