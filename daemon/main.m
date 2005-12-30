#import <Cocoa/Cocoa.h>
#import "bddcUpdateController.h"

int main(int argc, const char *argv[])
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NS_DURING
    [bddcUpdateController setupRunLoop];
  NS_HANDLER
    fprintf(stderr, "Error: something bad happened: %s\n", [[localException reason] cString]);
    return 1;
  NS_ENDHANDLER
  [pool release];
  return 0;
}