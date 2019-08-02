//
//  iFly.h
//  Runner
//
//  Created by sunxy on 2019/6/26.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoePlugin.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^completionHandler)(NSString* result);
@interface iFly : NSObject
- (void)onRecord:(NSString*)text :(NSString*)appId :(NSString*)secretId :(NSString*)secretKey;
- (void)stopRecord;
-(void) addRecognizeResultHandler:(completionHandler)handler;
@end

NS_ASSUME_NONNULL_END
