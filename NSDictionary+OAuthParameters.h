//
//  NSDictionary+OAuthParameters.h
//  FMag
//
//  Created by Rex St. John on 12/16/13.
//  Copyright (c) 2013 UX-RX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (OAuthParameters)


+(NSDictionary*)dictionaryWithOAuthParametersUsingConsumerKey:(NSString*)consumerKey
                                               consumerSecret:(NSString*)consumerSecret
                                                     tokenKey:(NSString*)tokenKey
                                                  tokenSecret:(NSString*)tokenSecret
                                                  withBaseURL:(NSURL*)url;

@end
