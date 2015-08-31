//
//  SpotifyHelper.m
//  proyecto_spotify
//
//  Created by Jorge Salas C on 8/23/15.
//  Copyright (c) 2015 Jorge Salas C. All rights reserved.
//


#import "SpotifyHelper.h"

@implementation SpotifyHelper

static SPTSession* session = nil;

+(void) requestSessionUsingApplication:(UIApplication *)application{
    // Override point for customization after application launch.
    [[SPTAuth defaultInstance] setClientID:@"70b45c70fa51493795c5a6456123f7cd"];
    [[SPTAuth defaultInstance] setRedirectURL:[NSURL URLWithString:@"spotproject://callback"]];
    [[SPTAuth defaultInstance] setRequestedScopes:@[SPTAuthStreamingScope]];
    
    // Construct a login URL and open it
    NSURL *loginURL = [[SPTAuth defaultInstance] loginURL];
    
    // Opening a URL in Safari close to application launch may trigger
    // an iOS bug, so we wait a bit before doing so.
    [application performSelector:@selector(openURL:)
                      withObject:loginURL afterDelay:0.1];

}

+(BOOL) handleAuthRequestWithUrl:(NSURL *)url{
    // Ask SPTAuth if the URL given is a Spotify authentication callback
    if ([[SPTAuth defaultInstance] canHandleURL:url]) {
        [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *newSession) {
            
            if (error != nil) {
                NSLog(@"*** Auth error: %@", error);
                return;
            }
            // Store the session locally
            [self setSession:newSession];
        }];
        return YES;
    }
    
    return NO;

}
///*
+(void) setSession:(SPTSession *)newSession{
    session = newSession;
}

+(SPTSession*) getSession{
    return session;
}
//*/

+(void) searchForArtist{
    if([self getSession] != nil){
        [SPTSearch performSearchWithQuery:@"incubus" queryType:SPTQueryTypeArtist accessToken:[self getSession].accessToken callback:^(NSError *error, id object) {
            if (error != nil || [(SPTListPage*)object items].count <= 0) {
                NSLog(@"*** error while searching for Incubus %@", error);
                return;
                
            }
            NSArray* results = [(SPTListPage*)object items];
            NSLog(@"SEARCH RESULTS: \n%@", results);
            
        }];
    }
    else{
        NSLog(@"Session was nil");
    }
    
}

+(void)searchForArtist:(NSString *)artist withCallback:(SEL)callback{
    if([self getSession] != nil){
        [SPTSearch performSearchWithQuery:@"incubus" queryType:SPTQueryTypeArtist accessToken:[self getSession].accessToken callback:^(NSError *error, id object) {
            if (error != nil || [(SPTListPage*)object items].count <= 0) {
                NSLog(@"*** error while searching for Incubus %@", error);
                return;
                
            }
            NSArray* results = [(SPTListPage*)object items];
            NSLog(@"SEARCH RESULTS: \n%@", results);
            //[target performSelector:callback:results];
            
        }];
    }
    else{
        NSLog(@"Session was nil");
    }

}

+(void)searchForArtist:(NSString *)artist withTarget:(ArtistSearchTableViewController *)target{
    if([self getSession] != nil){
        [SPTSearch performSearchWithQuery:artist queryType:SPTQueryTypeArtist accessToken:[self getSession].accessToken callback:
            ^(NSError *error, id object) {
            if (error != nil || [(SPTListPage*)object items].count <= 0) {
                NSLog(@"*** error while searching for artist %@", error);
                return;
                
            }
            NSArray* results = [(SPTListPage*)object items];
            NSMutableArray* mResults = [NSMutableArray arrayWithArray:results];
            //[target updateArtists:mResults];
                
                
            //NSLog(@"URI FROM PARTIAL ARTIST: \n%@", [(SPTPartialArtist*)[mResults objectAtIndex:0] uri]);
            
            /*
            NSURL* artistURI = [(SPTPartialArtist*)[mResults objectAtIndex:0] uri];
            [SPTArtist artistWithURI:artistURI session:[self getSession] callback:^(NSError *error, id object) {
                if (error != nil) {
                    NSLog(@"*** error while searching for FULL ARTIST %@", error);
                    return;
                        
                }
                //SPTArtist* fullArtist = (SPTArtist*)object;
            }];
            //*/
                
                NSMutableArray* artistUris = [[NSMutableArray alloc] init];
                for (SPTPartialArtist* partialArtist in mResults) {
                    [artistUris addObject: partialArtist.uri];
                    NSLog(@"Artist: %@ has the URI: %@", partialArtist.name, partialArtist.uri);
                }
                NSArray* arrayOfUris = [artistUris copy];
                [self searchForFullArtists:arrayOfUris withTarget:target];
                
            
        }];
    }
    else{
        NSLog(@"Session was nil");
    }

}

+(void) searchForFullArtists:(NSArray *)artistURIs withTarget:(ArtistSearchTableViewController *)target{
    [SPTArtist artistsWithURIs:artistURIs session:[self getSession] callback:^(NSError *error, id object) {
        if (error != nil) {
            NSLog(@"*** error while searching for artist %@", error);
            return;
            
        }
        NSArray* results = object;
        NSMutableArray* mResults = [NSMutableArray arrayWithArray:results];
        [target updateArtists:mResults];
    }];
}

+(void) promoteToFullArtist:(NSString*)artistID{

}

@end
