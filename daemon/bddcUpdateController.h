#import <Foundation/Foundation.h>
#import "bddcSCInterface.h"
#import "bddcStorageInterface.h"
#import "bddcNSUpdater.h"


@interface bddcUpdateController : NSObject {

}

+(void)setupRunLoop;
+(void)processNewIP;
  void updatedIPCallback(SCDynamicStoreRef store, CFArrayRef changedKeys, void * info);

@end
