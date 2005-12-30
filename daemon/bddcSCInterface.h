#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "bddcUpdateController.h"


@interface bddcSCInterface : NSObject {
  SCDynamicStoreRef myStore;
}

- (void)dealloc;
+ (id)instance;
- (void)openStore;
- (void)closeStore;
- (void)setNotifications;
- (NSString *)currentIP;
@end
