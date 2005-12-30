#import "bddcNSUpdater.h"
#import <unistd.h>
#import <sys/param.h>

@implementation bddcNSUpdater

static NSString *pathToNSUpdate = @"/usr/bin/nsupdate";

+(void)updateServer:(NSString *)withIP
{
  char *sysname = malloc(MAXHOSTNAMELEN);
  gethostname(sysname, MAXHOSTNAMELEN);
  [prefs registerDefaults:
    [NSDictionary dictionaryWithObjectsAndKeys:
      [NSString stringWithCString:sysname], @"hostName",
      @"None set", @"keyPath",
      @"86401", @"ttl",
      [NSNumber numberWithBool:YES], @"useKey",
      nil]];
  free(sysname);
  NSString *hostName = [prefs stringForKey:@"hostName"];
  NSString *keyFile = [prefs stringForKey:@"keyPath"];
  NSString *ttl = [prefs stringForKey:@"ttl"];
  NSString *commands = [NSString stringWithFormat:@"update delete %@ A\nupdate add %@ %@ A %@\n\n", hostName, hostName, ttl, withIP];
  NSData *commandStream = [commands dataUsingEncoding:NSASCIIStringEncoding];
  NSPipe *input = [[NSPipe alloc] init];
  NSTask *nsUpdateTask = [[NSTask alloc] init];
  [nsUpdateTask setStandardInput:input];
  if ([prefs boolForKey:@"useKey"])
  {
    NSArray *pathComponents = [keyFile pathComponents];
    if ([pathComponents count] > 1) {
      NSRange pathRange;
      pathRange.location = 0;
      pathRange.length = [pathComponents count] - 1;
      NSArray *keyPrefix = [pathComponents subarrayWithRange:pathRange];
      NSString *rawKey = [pathComponents objectAtIndex:([pathComponents count] -1)];
      if ([rawKey characterAtIndex:0] != (char)'K') {
        NSLog(@"Invalid keyFile: %@", keyFile);
        return;
      }
      NSRange keyPlusRange = [rawKey rangeOfString:@"+"];
      NSRange keyNameRange;
      keyNameRange.location = 1;
      keyNameRange.length = keyPlusRange.location - 1;
      NSString *keyPath = [NSString stringWithFormat:@"%@:%@", [NSString pathWithComponents:keyPrefix], [rawKey substringWithRange:keyNameRange]];
      [nsUpdateTask setArguments:[NSArray arrayWithObjects:@"-k", keyPath, nil]];
    }
  }
  [nsUpdateTask setLaunchPath:pathToNSUpdate];
  if ([[NSFileManager defaultManager] fileExistsAtPath:pathToNSUpdate])
  {
    [nsUpdateTask launch];
    if ([nsUpdateTask isRunning])
      [[input fileHandleForWriting] writeData:commandStream];
    else
      NSLog(@"%@: error: nsupdate didn't run.\n", self);
  }
  else
  {
    NSLog(@"%@: error: can't find nsupdate command at %@\n", self, pathToNSUpdate);
  }
  [nsUpdateTask release];
  [input release];
}

@end
