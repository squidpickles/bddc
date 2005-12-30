#import "bddcSCInterface.h"

@implementation bddcSCInterface

- (id)init
{
  [self openStore];
  [self setNotifications];
  return self;
}

- (void)dealloc
{
  [self closeStore];
  [super dealloc];
}

- (void)openStore
{
  myStore = SCDynamicStoreCreate(NULL, (CFStringRef)@"BDDSC", updatedIPCallback, NULL);
  if (! myStore)
    [[NSException exceptionWithName:@"bddcSCAccessException" reason:@"unable to connect to configd" userInfo:nil] raise];
  return;
}

- (void)closeStore
{
  CFRelease(myStore);
}

- (void)setNotifications
{
  NSMutableArray *tmpKeysToMonitor;
  NSArray *keysToMonitor, *ifHolder;
  NSDictionary *scHolder;

  tmpKeysToMonitor = [NSMutableArray arrayWithCapacity:2];
  [tmpKeysToMonitor addObject:@"State:/Network/Global/IPv4"];

  // Gets list of configured services
  scHolder = (NSDictionary *)SCDynamicStoreCopyValue(myStore, (CFStringRef)@"Setup:/Network/Global/IPv4");
  if (!scHolder) {
    [[NSException exceptionWithName:@"bddcSCAccessException" reason:@"Unable to get list of configured services" userInfo:nil] raise];
    return;
  }
  ifHolder = [NSArray arrayWithArray:[scHolder objectForKey:@"ServiceOrder"]];
  int i;
  for (i=0; i<[ifHolder count]; i++) {
    scHolder = (NSDictionary *)SCDynamicStoreCopyValue(myStore, (CFStringRef)[NSString stringWithFormat:@"State:/Network/Service/%@/IPv4",[ifHolder objectAtIndex:i]]);
    if (scHolder)
      [tmpKeysToMonitor addObject:[NSString stringWithFormat:@"State:/Network/Service/%@/IPv4",[ifHolder objectAtIndex:i]]];
  }
  [scHolder release];
  [ifHolder release];
  keysToMonitor = [[NSArray alloc] initWithArray:tmpKeysToMonitor];
  if (! SCDynamicStoreSetNotificationKeys(myStore, (CFArrayRef)keysToMonitor, NULL)) {
    [[NSException exceptionWithName:@"bddcSCAccessException" reason:@"Unable to set list of keys to monitor" userInfo:nil] raise];
    return;
  }
  CFRunLoopSourceRef loopRef = SCDynamicStoreCreateRunLoopSource(NULL, myStore, 0);
  CFRunLoopRef currLoop = CFRunLoopGetCurrent();
  CFRunLoopAddSource(currLoop, loopRef, kCFRunLoopDefaultMode);
  CFRelease(loopRef);
}

+ (id)instance
{
  static bddcSCInterface *inst = nil;
  if (!inst)
    inst = [[self alloc] init];
  return inst;
}

- (NSString *)currentIP
{
  NSDictionary *scHolder;
  NSString *currIP;
  NSArray *addrHolder;

  scHolder = (NSDictionary *)SCDynamicStoreCopyValue(myStore, (CFStringRef)@"State:/Network/Global/IPv4");
  if (!scHolder)
    return nil;

  scHolder = (NSDictionary *)SCDynamicStoreCopyValue(myStore, (CFStringRef)[NSString stringWithFormat:@"State:/Network/Service/%@/IPv4", [NSString stringWithString:[scHolder objectForKey:@"PrimaryService"]]]);
  if (!scHolder)
    return nil;

  addrHolder = [[scHolder objectForKey:@"Addresses"] copy];
  [scHolder release];
  if (! addrHolder) {
    [[NSException exceptionWithName:@"bddcSCAccessException" reason:@"unable to get address list" userInfo:nil] raise];
    return nil;
  }

  currIP = [[NSString alloc] initWithString:[addrHolder objectAtIndex:0]];
  [addrHolder release];
  if (! currIP) {
    [[NSException exceptionWithName:@"bddcSCAccessException" reason:@"unable to get primary IP address" userInfo:nil] raise];
    return nil;
  }
  return [currIP autorelease];
}

@end
