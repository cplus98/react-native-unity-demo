/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <UnityFramework/UnityFramework.h>
#include <UnityFramework/NativeCallProxy.h>
#import <React/RCTBridgeDelegate.h>
#import <React/RCTRootView.h>
#import <React/RCTComponent.h>
#import <UIKit/UIKit.h>

extern int gArgc;
extern char** gArgv;
extern NSDictionary* appLaunchOpts;


@interface AppDelegate : UIResponder <UIApplicationDelegate, RCTBridgeDelegate, UnityFrameworkListener, NativeCallsProtocol>

@property (nonatomic, strong) UIWindow *window;
@property UnityFramework *ufw;
@property RCTRootView *reactView;

- (void)initReactNativeAndUnity;
- (void)sendMessageToUnity3D:(const char*)msg;
- (void)pauseUnity3D:(bool)pause;

@end
