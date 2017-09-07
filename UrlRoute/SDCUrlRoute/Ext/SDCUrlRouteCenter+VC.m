//
//  SDCUrlRouteCenter+VC.m
//  LaoBaiStore
//
//  Created by YYDD on 2016/12/29.
//  Copyright © 2016年 zyh. All rights reserved.
//

#import "SDCUrlRouteCenter+VC.h"
#import "SDCWebManager.h"

#import "SDCJLRouteData.h"

#import "UIApplication+SDCUrlRoute.h"

@implementation SDCUrlRouteCenter (VC)

- (void)getViewControllerWithUrlStr:(NSString *)urlStr WithParameters:(NSDictionary *)param WithBlock:(void (^)(UIViewController *))block {

    [SDCJLRouteData sharedData].routeCallBackBlock = ^(BOOL isWeb, NSString *urlStr, UIViewController *vc) {

        if (block) {

            block(vc);
        }
    };
   [[SDCJLRouteData sharedData]goRouteWithUrl:urlStr WithExtraParameters:param];
}


@end
