#import "bddcPrefPane.h"
#import <unistd.h>
#import <sys/param.h>

@implementation bddcPrefPane

- (id)initWithBundle:(NSBundle *)bundle
{
  if ((self = [super initWithBundle:bundle]) != nil)
    appID = CFSTR("net.tentacle.sweetpea.bddc");
  return self;
}

- (void)mainViewDidLoad
{
  CFPropertyListRef value;
  value = CFPreferencesCopyAppValue(CFSTR("hostName"), appID);
  if (value)
  {
    [hostName setStringValue:(NSString *)value];
    CFRelease(value);
  }
  else
  {
    char *sysname = malloc(MAXHOSTNAMELEN);
    gethostname(sysname, MAXHOSTNAMELEN);
    [hostName setStringValue:[NSString stringWithCString:sysname]];
    free(sysname);
  }
  value = CFPreferencesCopyAppValue(CFSTR("keyPath"), appID);
  if (value)
  {
    [keyPath setStringValue:(NSString *)value];
    CFRelease(value);
  }
  else
  {
    [keyPath setStringValue:@"None set"];
  }
  value = CFPreferencesCopyAppValue(CFSTR("ttl"), appID);
  if (value)
  {
    [ttl setStringValue:(NSString *)value];
    CFRelease(value);
  }
  else
  {
    [ttl setStringValue:@"1d1s"];
  }
  value = CFPreferencesCopyAppValue(CFSTR("useKey"), appID);
  if (value)
  {
    [useKey setState:CFBooleanGetValue(value)];
    CFRelease(value);
  }
  else
  {
    [useKey setState:NO];
  }
  [self updateKeyPathStatus];
}

- (void)savePrefs
{
  CFPreferencesSetAppValue(CFSTR("hostName"), [hostName stringValue], appID);
  CFPreferencesSetAppValue(CFSTR("keyPath"), [keyPath stringValue], appID);
  CFPreferencesSetAppValue(CFSTR("ttl"), [ttl stringValue], appID);
  CFPreferencesAppSynchronize(appID);
}

- (NSPreferencePaneUnselectReply)shouldUnselect
{
  [self savePrefs];
  return NSUnselectNow;
}

- (void)didUnselect
{
  CFRelease(appID);
}

- (IBAction)updateKeyPath:(id)sender
{
  int result;
  NSArray *fileTypes = [NSArray arrayWithObject:@"key"];
  NSOpenPanel *oPanel = [NSOpenPanel openPanel];

  [oPanel setAllowsMultipleSelection:NO];
  result = [oPanel runModalForTypes:fileTypes];
  if (result == NSOKButton) {
    NSArray *filesToOpen = [oPanel filenames];
    [keyPath setStringValue:[filesToOpen objectAtIndex:0]];
  }  
}

- (void)updateKeyPathStatus
{
  if ([useKey state] == NSOnState)
  {
    [updateButton setEnabled:YES];
    [keyPath setEnabled:YES];
  }
  else
  {
    [updateButton setEnabled:NO];
    [keyPath setEnabled:NO];
  }
}

- (IBAction)useKeyChanged:(id)sender
{
  if ([sender state])
    CFPreferencesSetAppValue(CFSTR("useKey"),  kCFBooleanTrue, appID);
  else
    CFPreferencesSetAppValue(CFSTR("useKey"), kCFBooleanFalse, appID);  
  [self updateKeyPathStatus];
}

@end
