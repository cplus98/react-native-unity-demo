/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTViewManager.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTViewManager.h>

int gArgc = 0;
char** gArgv = nil;
NSDictionary *appLaunchOpts = nil;
AppDelegate *mainDelegate = nil;

UnityFramework* UnityFrameworkLoad() {
    NSString* bundlePath = nil;
    bundlePath = [[NSBundle mainBundle] bundlePath];
    bundlePath = [bundlePath stringByAppendingString: @"/Frameworks/UnityFramework.framework"];

    NSBundle* bundle = [NSBundle bundleWithPath: bundlePath];
    if ([bundle isLoaded] == false) [bundle load];

    UnityFramework* ufw = [bundle.principalClass getInstance];
    if (![ufw appController]) {
        // unity is not initialized
        [ufw setExecuteHeader: &_mh_execute_header];
    }
    return ufw;
}

BOOL isInitializedUnity = false;

@interface RNUnityViewManager : RCTViewManager
//@property (nonatomic, strong) RNUnityView *currentView;
@end

@implementation RNUnityViewManager
RCT_EXPORT_MODULE(Unity3DView)

- (UIView *)view {
  if (isInitializedUnity) {
    UIView *view = [[[mainDelegate ufw] appController] rootView];
    [[mainDelegate ufw] showUnityWindow];
    return view;
  }
  isInitializedUnity = true;

  // Always keep RN window in top
  UIApplication* application = [UIApplication sharedApplication];
  application.keyWindow.windowLevel = UIWindowLevelNormal + 1;

  [mainDelegate initReactNativeAndUnity];

  UIView *view = [[[mainDelegate ufw] appController] rootView];
  view.userInteractionEnabled = YES;
  return view;
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

@end

//--------------------------------------------------
// React Native - Native Module method, called from RN bundle
@interface Unity3D: RCTEventEmitter <RCTBridgeModule>
@end
@implementation Unity3D
{
  bool hasListeners;
}
RCT_EXPORT_MODULE();
- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}
RCT_EXPORT_METHOD(sendMessage:(NSString*)msg) {
  [mainDelegate sendMessageToUnity3D:[msg UTF8String]];
}
RCT_EXPORT_METHOD(pause:(BOOL)pause) {
  [mainDelegate pauseUnity3D:pause];
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"onUnityMessage"];
}
- (void)sendMessageToReact:(NSString*)msg {
    [self sendEventWithName:@"onUnityMessage" body:@{@"data": msg}];
}
@end
//--------------------------------------------------

@implementation AppDelegate

- (void)initReactNativeAndUnity {
  // Init Unity3D
  self.ufw = UnityFrameworkLoad();
  [[self ufw] setDataBundleId:"com.unity3d.framework"];
  [[self ufw] registerFrameworkListener: self];
  [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self];
  [[self ufw] runEmbeddedWithArgc: gArgc argv: gArgv appLaunchOpts: appLaunchOpts];
}

// Send message from Unity to React
- (void)unityMessage:(NSString*)msg {
  [[[[self reactView] bridge] moduleForName:@"Unity3D"] sendMessageToReact:msg];
  NSLog(@"%@", msg);
}

// Base method to send message from Native to Unity, targets ReactEventReceiver GameObject
- (void)sendMessageToUnity3D:(const char*)msg {
  [[self ufw] sendMessageToGOWithName: "ReactEventReceiver" functionName: "OnReactMessage" message: msg];
}

- (void)pauseUnity3D:(bool)pause {
  [[self ufw] pause:pause];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  appLaunchOpts = launchOptions;
  mainDelegate = self;
  
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"ReactNativeUnityDemo"
                                            initialProperties:nil];

  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];

  self.reactView = rootView;
  
  return YES;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
