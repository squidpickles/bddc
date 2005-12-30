#import <Foundation/Foundation.h>
#define prefs [NSUserDefaults standardUserDefaults]


@interface bddcNSUpdater : NSObject {

}

+(void)updateServer:(NSString *)withIP;

@end
