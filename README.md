I have forked this library so I could (a) Upgrade it to ARC compatibility (b) modify it for use with MKNetorkKit and (c) Add a helped dictionary category (using some of the same source) for producing OAUTH 1.0 compatbile dictionaries for use with MKNetworkKit.

I have modified the GCOAuth.h and .m files to include ARC compatibility, appropriate __bridge casting and expose some previously "private" methods which are useful to my category extension.

NOTE: For use with MKNetworkKit, delete the included NSData+Base64 files from the project and instead add the include (from MKNetworkKit) of "NSData+MKBase64.h" into the header of the NSDictionary+OAuthParameters.

====================================================================================

Example Useage:

NSURL *url = [NSURL URLWithString:@"api.yelp.com/v2"];
NSDictionary *oauthDictionary = [NSDictionary dictionaryWithOAuthParametersUsingConsumerKey:@"consumerKey*****"
                                                                             consumerSecret:@"consumerSecret******"
                                                                                   tokenKey:@"tokenKey*****" tokenSecret:@"tokenSecret*****"
                                 withBaseURL:url];

NSLog(@"%@", [oauthDictionary description]);

====================================================================================

Below this line are necessary installation instructions from the pre-forked ReadMe:

Cocoa library for creating signed requests according to the OAuth 1.0a standard.

Usage is fully documented in the header.

You will need to make your Xcode project link against CommonCrypto. Otherwise
just drag and drop. Or better yet, use git submodules:

    git submodule add https://github.com/guicocoa/cocoa-oauth.git

Forked from [GCOAUTH](https://github.com/guicocoa/cocoa-oauth)