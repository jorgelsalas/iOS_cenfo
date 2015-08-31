//
//  SpotifyHelper.h
//  proyecto_spotify
//
//  Created by Jorge Salas C on 8/23/15.
//  Copyright (c) 2015 Jorge Salas C. All rights reserved.
//

#import <Spotify/Spotify.h>
#import <Foundation/Foundation.h>
#import "ArtistSearchTableViewController.h"

@interface SpotifyHelper : NSObject
//@property (nonatomic, strong) SPTSession* session;

+(void) requestSessionUsingApplication:(UIApplication*)application;
+(BOOL) handleAuthRequestWithUrl:(NSURL*)url;
+(void) setSession:(SPTSession *)session;
+(SPTSession*) getSession;
+(void) searchForArtist;
+(void) searchForArtist:(NSString*)artist withCallback:(SEL)callback;
+(void) searchForArtist:(NSString*)artist withTarget:(ArtistSearchTableViewController*)target;
+(void) searchForFullArtists:(NSArray*)artistURIs withTarget:(ArtistSearchTableViewController*)target;
+(void) promoteToFullArtist:(NSString*)artistID;
@end

