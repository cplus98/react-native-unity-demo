#import <Foundation/Foundation.h>
#import "NativeCallProxy.h"


@implementation FrameworkLibAPI

id<NativeCallsProtocol> api = NULL;
+ (void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) aApi {
    api = aApi;
}

@end


extern "C" {
    void unityMessage(const char* msg) {
		return [api unityMessage:[NSString stringWithUTF8String:msg]];
	}
}
