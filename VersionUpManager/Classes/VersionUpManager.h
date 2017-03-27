//
//  VersionUpManager.h
//  VersionUpManager
//
//  Created by ko on 13/05/27.
//  Copyright 2013 MinghuaHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionUpManager:NSObject


+ (VersionUpManager *)sharedManager;

- (void)runVersionUpdateProcessIfNeedsWith:(void (^)(NSString * oldVer, NSString *newVer))updateProcess;

//token毎に一回だけ実行する処理
- (void)runOnceWithToken:(NSString *)token onProcessBlock:(void (^)(NSString * oldVer, NSString *newVer))processBlock;
@end
