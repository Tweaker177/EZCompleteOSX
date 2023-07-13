//APIKeyManager.h   by Brian Nooning
// A simple class for fetching API keys from multiple sources 
//using one set of convenience functions

#import <Foundation/Foundation.h>

#define OPENAI_KEY @"OPENAI_API_KEY"
#define GOOGLE_KEY @"GOOGLE_API_KEY"

@interface APIKeyManager : NSObject
+ (NSString *)getKeyForAPI_KeyName:(NSString*)API_KEY_NAME;
//Get the key name for associated API_NAME (Google Cloud/ OPENAI, etc) return the actual key
+ (void)setOpenAIAPIKey:(NSString *)OPENAI_API_KEY;
@end

@implementation APIKeyManager

+(NSString *)getKeyForAPI_KeyName:(NSString *)API_KEY_NAME {
NSString *API_KEY = [self objectForKey:API_KEY_NAME];
if(!API_KEY) {
API_KEY = [self readKeyFromEnvironmentWithKeyName:API_KEY_NAME];


+(NSString *)readKeyFromEnvironmentWithAPI:(NSString* )API {
NSString *key;
if([API isEqualToString:@"OPENAI"] || [API isEqualToString:OPENAI_KEY]
   {
   key = [[[NSProcessInfo processInfo] environment] objectForKey:OPENAI_KEY];
   }
 else if([API isEqualToString:@"GOOGLE_CLOUD"] || [API isEqualToString:@"GOOGLE"]) 
   {
   key = [[[NSProcessInfo processInfo] environment] objectForKey:@"GOOGLE_API_KEY"];
   }
   else { key = nil; } 
   
   if ((!key) && [API isEqualToString:@"OPENAI"] || [API isEqualToString:OPENAI_KEY]) {
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:@"/bin/bash"];

        [task setArguments:@[@"-l", @"-c", @"echo $OPENAI_API_KEY"]];

        NSPipe *pipe = [NSPipe pipe];
        [task setStandardOutput:pipe];

        [task launch];

        NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        key = [output stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ((!key) && [API isEqualToString:@"GOOGLE_CLOUD"] || [API isEqualToString:@"GOOGLE_CLOUD_API_KEY"]) {
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:@"/bin/bash"];

        [task setArguments:@[@"-l", @"-c", @"echo $GOOGLE_CLOUD_API_KEY"]];

        NSPipe *pipe = [NSPipe pipe];
        [task setStandardOutput:pipe];

        [task launch];

        NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        key = [output stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else { key = nil; }
    return key;
}






+ (NSString *)getOpenAIKey {
    NSString *key = [self readKeyFromFile];
    if (!key) {
        key = [self readKeyFromEnvironment];
        if (!key) {
            key = [self promptUserForKey];
            [self saveKeyToFile:key];
        }
    }
    return key;
}

+ (void)setOpenAIAPIKey:(NSString *)OPENAI_API_KEY {
    [self saveKeyToFile:OPENAI_API_KEY];
}

+ (NSString *)readKeyFromFile {
    // Code to read key from a file goes here
}


+ (NSString *)promptUserForKey {
    // Code to prompt user for key goes here
}

+ (void)saveKeyToDefaults:(NSString *)key {
    // Code to save key to a file goes here
}

@end


@implementation OpenAIKeyManager : NSObject
+(NSString *)readKeyFromEnvironment {
    NSString *key = [[[NSProcessInfo processInfo] environment] objectForKey:OPENAI_KEY];
    if (!key) {
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:@"/bin/bash"];
        [task setArguments:@[@"-l", @"-c", @"echo $OPENAI_API_KEY"]];

        NSPipe *pipe = [NSPipe pipe];
        [task setStandardOutput:pipe];

        [task launch];

        NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        key = [output stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return key;
}
