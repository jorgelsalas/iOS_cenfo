//
//  SpotifyHelper.h
//  proyecto_spotify
//
//  Created by Jorge Salas C on 8/23/15.
//  Copyright (c) 2015 Jorge Salas C. All rights reserved.
//

#import <Spotify/Spotify.h>
#import <Foundation/Foundation.h>

@interface SpotifyHelper : NSObject
//@property (nonatomic, strong) SPTSession* session;

+(void) requestSessionUsingApplication:(UIApplication*)application;
+(BOOL) handleAuthRequestWithUrl:(NSURL*)url;
+(void) setSession:(SPTSession *)session;
+(SPTSession*) getSession;
+(void) searchForArtist;
@end

