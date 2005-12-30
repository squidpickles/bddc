/* bddcPrefPane */

#import <Cocoa/Cocoa.h>
#import <PreferencePanes/NSPreferencePane.h>
#import <CoreFoundation/CFPreferences.h>

@interface bddcPrefPane : NSPreferencePane
{
    IBOutlet id hostName;
    IBOutlet id keyPath;
    IBOutlet id ttl;
    IBOutlet id useKey;
    IBOutlet id updateButton;
    CFStringRef appID;
}
- (void)updateKeyPathStatus;
- (void)savePrefs;
- (IBAction)updateKeyPath:(id)sender;
- (IBAction)useKeyChanged:(id)sender;
@end
