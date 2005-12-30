#import "bddcStorageInterface.h"


@implementation bddcStorageInterface
static NSString *path = @"~/Library/Application Support/bddc/lastIPaddr.xml";

+(NSString *)previousIP
{
  NSString *plistString;

  plistString = [NSString stringWithContentsOfFile:[path stringByExpandingTildeInPath]];
  return [plistString propertyList];
}

+(void)setCurrentIP:(NSString *)currentIP
{
  NSData *xmlData;
  NSString *error;

  xmlData = [NSPropertyListSerialization dataFromPropertyList:currentIP format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
  if(xmlData)
  {
    if (! [xmlData writeToFile:[path stringByExpandingTildeInPath] atomically:YES])
      NSLog(@"%@: Error writing to file.\n", self);
  }
  else
  {
    NSLog(error);
    [error release];
  }
}

@end
