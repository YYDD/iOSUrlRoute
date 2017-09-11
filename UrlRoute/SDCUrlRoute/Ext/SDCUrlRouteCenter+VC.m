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



- (void)addRoots:(NSArray <NSString *>*)urlArr WithParametersArr:(NSArray <NSDictionary *>*)paramArr WithBlock:(void (^)(NSArray <UIViewController *>*vcArr))block {

    NSMutableArray *mutVCArr = [[NSMutableArray alloc]init];
    __block NSInteger actionCount = 0;
    for (int i = 0; i < urlArr.count; i ++) {
        [mutVCArr addObject:[NSString stringWithFormat:@"%d",i]];
        NSString *urlStr = urlArr[i];
        NSDictionary *param = nil;
        if (paramArr.count > i) {
            param = paramArr[i];
        }
        
        [self getViewControllerWithUrlStr:urlStr WithParameters:param WithBlock:^(UIViewController *vc) {
            [mutVCArr replaceObjectAtIndex:i withObject:vc];
            actionCount ++;
            if (actionCount == mutVCArr.count) {
                //说明完成了
                if (block) {
                    block([mutVCArr copy]);
                }
            }
        }];
    }
}


@end
