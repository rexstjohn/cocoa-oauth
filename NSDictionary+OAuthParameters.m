//
//  NSDictionary+OAuthParameters.m
//  FMag
//
//  Created by Rex St. John on 12/16/13.
//  Copyright (c) 2013 UX-RX. All rights reserved.
//

#import "NSDictionary+OAuthParameters.h"
#import "GCOAuth.h"
#import <CommonCrypto/CommonHMAC.h>
#import "NSData+Base64.h"

@implementation NSDictionary (OAuthParameters)

+(NSDictionary*)dictionaryWithOAuthParametersUsingConsumerKey:(NSString*)consumerKey
                                               consumerSecret:(NSString*)consumerSecret
                                                     tokenKey:(NSString*)tokenKey
                                                  tokenSecret:(NSString*)tokenSecret
                                                  withBaseURL:(NSURL*)url{
    
    NSDictionary *OAuthParameters = @{
                                      @"oauth_consumer_key":[consumerKey copy],
                                      @"oauth_nonce":[GCOAuth nonce],
                                      @"oauth_timestamp":[GCOAuth timeStamp],
                                      @"oauth_version": @"1.0",
                                      @"oauth_signature_method":@"HMAC-SHA1",
                                      @"oauth_token":tokenKey
                                      };
    
    NSString *signatureSecret = [NSString stringWithFormat:@"%@&%@", [consumerSecret pcen], [tokenSecret ?: @"" pcen]];
    
    NSString *signature = [self signatureFromSignatureSecret:signatureSecret withRequestParameters:@{} withOAUTHParameters:OAuthParameters andBaseURL:url];
    
    return @{@"oauth_consumer_key":[consumerKey copy],
             @"oauth_nonce":[GCOAuth nonce],
             @"oauth_timestamp":[GCOAuth timeStamp],
             @"oauth_version": @"1.0",
             @"oauth_signature":signature,
             @"oauth_signature_method":@"HMAC-SHA1",
             @"oauth_token":tokenKey};
}

+ (NSString *)signatureFromSignatureSecret:(NSString*)signatureSecret withRequestParameters:(NSDictionary*)parameters withOAUTHParameters:(NSDictionary*)OauthParameters andBaseURL:(NSURL*)url{
    
    // get signature components
    NSData *base = [[self signatureBaseWithParameters:parameters withOAUTHParameters:OauthParameters andBaseURL:url] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *secret = [signatureSecret dataUsingEncoding:NSUTF8StringEncoding];
    
    // hmac
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CCHmacContext cx;
    CCHmacInit(&cx, kCCHmacAlgSHA1, [secret bytes], [secret length]);
    CCHmacUpdate(&cx, [base bytes], [base length]);
    CCHmacFinal(&cx, digest);
    
    // base 64
    NSData *data = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    return [data base64EncodedString];
    
}

+ (NSString *)signatureBaseWithParameters:(NSDictionary*)requestParameters withOAUTHParameters:(NSDictionary*)oauthParameters andBaseURL:(NSURL*)url {
    
    // normalize parameters
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:oauthParameters];
    [parameters addEntriesFromDictionary:requestParameters];
    NSMutableArray *entries = [NSMutableArray arrayWithCapacity:[parameters count]];
    NSArray *keys = [[parameters allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in keys) {
        NSString *obj = [parameters objectForKey:key];
        NSString *entry = [NSString stringWithFormat:@"%@=%@", [key pcen], [obj pcen]];
        [entries addObject:entry];
    }
    NSString *normalizedParameters = [entries componentsJoinedByString:@"&"];
    
    // construct request url
    NSURL *URL = url;
    
	// Use CFURLCopyPath so that the path is preserved with trailing slash, then escape the percents ourselves
    NSString *pathWithPrevervedTrailingSlash = [CFBridgingRelease(CFURLCopyPath((CFURLRef)URL)) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *URLString = [NSString stringWithFormat:@"%@://%@%@",
                           [[URL scheme] lowercaseString],
                           [[URL hostAndPort] lowercaseString],
                           pathWithPrevervedTrailingSlash];
    
    // create components
    NSArray *components = [NSArray arrayWithObjects:
                           [@"POST" pcen],
                           [URLString pcen],
                           [normalizedParameters pcen],
                           nil];
    
    // return
    return [components componentsJoinedByString:@"&"];
}
@end
