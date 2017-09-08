//
//  SDCUrlRouteCenter+VC.h
//  LaoBaiStore
//
//  Created by YYDD on 2016/12/29.
//  Copyright © 2016年 zyh. All rights reserved.
//

#import "SDCUrlRouteCenter.h"

@interface SDCUrlRouteCenter (VC)

-(void)getViewControllerWithUrlStr:(NSString *)urlStr WithParameters:(NSDictionary *)param WithBlock:(void (^)(UIViewController *vc))block;


- (void)addRoots:(NSArray <NSString *>*)urlArr WithParametersArr:(NSArray <NSDictionary *>*)paramArr WithBlock:(void (^)(NSArray <UIViewController *>*vcArr))block;

@end
