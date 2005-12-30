#import "bddcUpdateController.h"


@implementation bddcUpdateController

+(void)setupRunLoop
{
  [self processNewIP];
  [[NSRunLoop currentRunLoop] run];
  [[bddcSCInterface instance] release];
}

+(void)processNewIP
{
  NSString *newIP = [[bddcSCInterface instance] currentIP];
  if (!newIP)
    return;
  NSString *prevIP = [bddcStorageInterface previousIP];
  if (!prevIP)
    return;
  if ([newIP isEqual:prevIP])
    return;
  [bddcStorageInterface setCurrentIP:newIP];
  [bddcNSUpdater updateServer:newIP];
  NSLog(@"IP address updated.\n");
}

void updatedIPCallback(SCDynamicStoreRef store, CFArrayRef changedKeys, void * info)
{
#pragma unused (changedKeys)
#pragma unused (store)
#pragma unused (info)
  [bddcUpdateController processNewIP];
}

@end
