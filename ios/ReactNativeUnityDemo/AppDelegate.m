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

int gArgc = 0;
char** gArgv = nil;
NSDictionary *appLaunchOpts = nil;
AppDelegate *mainDelegate = nil;

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

//--------------------------------------------------
@interface RootViewController : UIViewController
@end

@implementation RootViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  [mainDelegate initReactNativeAndUnity];
}
@end
//--------------------------------------------------

@implementation AppDelegate

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

- (void)initReactNativeAndUnity {
  // Init Unity3D
  self.ufw = UnityFrameworkLoad();
  [[self ufw] setDataBundleId:"com.unity3d.framework"];
  [[self ufw] registerFrameworkListener: self];
  [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self];
  [[self ufw] runEmbeddedWithArgc: gArgc argv: gArgv appLaunchOpts: appLaunchOpts];
  CGRect rcUnityView = [[[self ufw] appController] rootView].frame;

  // Init React Native
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:appLaunchOpts];
  self.reactView = [[RCTRootView alloc] initWithBridge:bridge moduleName:@"ReactNativeUnityDemo" initialProperties:nil];
  self.reactView.frame = rcUnityView;
  self.reactView.backgroundColor = UIColor.clearColor; // transparent view on ios, only items set in react can be seen

  UIView *unityView = [[[self ufw] appController] rootView];
  [unityView addSubview:self.reactView];
}

// Send message from Unity to React
- (void)unityMessage:(NSString*)msg {
  [[[[self reactView] bridge] moduleForName:@"Unity3D"] sendMessageToReact:msg];
}

// Base method to send message from Native to Unity, targets NativeEventReciver GameObject
- (void)sendMessageToUnity3D:(const char*)msg {
  [[self ufw] sendMessageToGOWithName: "ReactEventReciver" functionName: "OnReactMessage" message: msg];
}

- (void)pauseUnity3D:(bool)pause {
  [[self ufw] pause:pause];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  appLaunchOpts = launchOptions;
  mainDelegate = self;
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.rootViewController = [RootViewController new];
  [self.window makeKeyAndVisible];
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
