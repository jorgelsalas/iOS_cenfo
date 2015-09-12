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
static SPTAudioStreamingController* player = nil;

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

+(void) setPlayer:(SPTAudioStreamingController *)newPlayer{
    player = newPlayer;
}

+(SPTAudioStreamingController*) getPlayer{
    return player;
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

+(void) searchForTopSongs:(SPTArtist *)artist withTarget:(SongListTableViewController *)target{
    [artist requestTopTracksForTerritory:@"us" withSession:[self getSession] callback:^(NSError *error, id object) {
        if (error != nil) {
            NSLog(@"Error while retrieving top songs from %@. Error:\n%@", artist.name, error);
            return;
        }
        NSArray* results = object;
        NSMutableArray* mResults = [NSMutableArray arrayWithArray:results];
        [target updateTracks:mResults];
    }];
}

+(void) playSong:(SPTTrack *)track {
    // Create a new player if needed
    if ([self getPlayer] == nil) {
        [self setPlayer:[[SPTAudioStreamingController alloc] initWithClientId:[SPTAuth defaultInstance].clientID]];
    }
    
    [[self getPlayer] loginWithSession:[self getSession] callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** Logging in while trying to play a track got an error: %@", error);
            return;
        }
        
        //NSURL *trackURI = [NSURL URLWithString:@"spotify:track:58s6EuEYJdlb0kO7awm3Vp"];
        [[self getPlayer] playURIs:@[track.uri] fromIndex:0 callback:^(NSError *error) {
            NSLog(@"*** Starting playback got an error: %@", error);
            return;
        }];
    }];
}

+(void) playSongList:(NSMutableArray *)tracks {
    // Create a new player if needed
    if ([self getPlayer] == nil) {
        [self setPlayer:[[SPTAudioStreamingController alloc] initWithClientId:[SPTAuth defaultInstance].clientID]];
    }
    
    [[self getPlayer] loginWithSession:[self getSession] callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** Logging in while trying to play a track got an error: %@", error);
            return;
        }
        
        NSMutableArray* songUris = [[NSMutableArray alloc] init];
        for (SPTTrack* track in tracks) {
            [songUris addObject:track.uri];
            NSLog(@"Added URI: %@", track.uri);
        }
        
        [[self getPlayer] playURIs:songUris fromIndex:0 callback:^(NSError *error) {
            if(nil!=error){
                NSLog(@"*** Starting playback got an error: %@", error);
            }
            return;
        }];
    }];
}

+(void) playSongList:(NSMutableArray *)tracks fromIndex:(NSNumber *)index{
    // Create a new player if needed
    if ([self getPlayer] == nil) {
        [self setPlayer:[[SPTAudioStreamingController alloc] initWithClientId:[SPTAuth defaultInstance].clientID]];
    }
    
    [[self getPlayer] loginWithSession:[self getSession] callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** Logging in while trying to play a track got an error: %@", error);
            return;
        }
        
        NSMutableArray* songUris = [[NSMutableArray alloc] init];
        for (SPTTrack* track in tracks) {
            [songUris addObject:track.uri];
            NSLog(@"Added URI: %@", track.uri);
        }
        
        [[self getPlayer] playURIs:songUris fromIndex:[index intValue] callback:^(NSError *error) {
            if(nil!=error){
                NSLog(@"*** Starting playback got an error: %@", error);
            }
            return;
        }];
    }];
}

+(void) pauseSong{
    NSLog(@"Pushed PAUSE");
    if ([self getPlayer] == nil) {
        NSLog(@"Streaming player has not been initialized");
    }
    else{
        [[self getPlayer] setIsPlaying:NO callback:^(NSError *error) {
            if(nil!=error){
                NSLog(@"Error while pausing the player %@", error);
            }
            return;
        }];
    }
}


+(void) playOrResumeSong{
    NSLog(@"Pushed PLAY");
    if ([self getPlayer] == nil) {
        NSLog(@"Streaming player has not been initialized");
    }
    else{
        [[self getPlayer] setIsPlaying:YES callback:^(NSError *error) {
            if(nil!=error){
                NSLog(@"Error while resuming the player %@", error);
            }
            return;
        }];
    }
}

+(void) goToNextSong{
    NSLog(@"Pushed NEXT");
    if ([self getPlayer] == nil) {
        NSLog(@"Streaming player has not been initialized");
    }
    else{
        NSLog(@"Track index before going to next:\n%d", [[self getPlayer] currentTrackIndex]);
        NSLog(@"Track uri before going to next:\n%@", [[self getPlayer] currentTrackURI]);
        NSLog(@"Track list size before going to next:\n%d", [[self getPlayer] trackListSize]);
        [[self getPlayer] skipNext:^(NSError *error) {
            if(nil!=error){
                NSLog(@"Error while going to next song %@", error);
                return;
            }
            NSLog(@"Track index after going to previous:\n%d", [[self getPlayer] currentTrackIndex]);
            NSLog(@"Track uri after going to previous:\n%@", [[self getPlayer] currentTrackURI]);
            NSLog(@"Track list size after going to previous:\n%d", [[self getPlayer] trackListSize]);
        }];
    }
}

+(void) goToPreviousSong{
    NSLog(@"Pushed PREV");
    if ([self getPlayer] == nil) {
        NSLog(@"Streaming player has not been initialized");
    }
    else{
        //SPTAudioStreamingController* pl = [self getPlayer];
        NSLog(@"Track index before going to previous:\n%d", [[self getPlayer] currentTrackIndex]);
        NSLog(@"Track uri before going to previous:\n%@", [[self getPlayer] currentTrackURI]);
        NSLog(@"Track list size before going to previous:\n%d", [[self getPlayer] trackListSize]);
        
        //[[self getPlayer] currentTrackIndex];
        //[[self getPlayer] currentTrackURI];
        //[[self getPlayer] trackListSize];
        
        [[self getPlayer] skipPrevious:^(NSError *error) {
            if(nil!=error){
                NSLog(@"Error while going to previous song %@", error);
                return;
            }
            NSLog(@"Track index after going to previous:\n%d", [[self getPlayer] currentTrackIndex]);
            NSLog(@"Track uri after going to previous:\n%@", [[self getPlayer] currentTrackURI]);
            NSLog(@"Track list size after going to previous:\n%d", [[self getPlayer] trackListSize]);
        }];
    }
}

+(void) goToPreviousSongWithTarget:(PlayerViewController *)target{
    NSLog(@"Pushed PREV");
    if ([self getPlayer] == nil) {
        NSLog(@"Streaming player has not been initialized");
    }
    else{
        [[self getPlayer] skipPrevious:^(NSError *error) {
            if(nil!=error){
                NSLog(@"Error while going to previous song %@", error);
                return;
            }
            [target updateCurrentTrack];
        }];
    }

}

+(void) goToNextSongWithTarget:(PlayerViewController *)target{
    NSLog(@"Pushed NEXT");
    if ([self getPlayer] == nil) {
        NSLog(@"Streaming player has not been initialized");
    }
    else{
        [[self getPlayer] skipNext:^(NSError *error) {
            if(nil!=error){
                NSLog(@"Error while going to next song %@", error);
                return;
            }
            [target updateCurrentTrack];
        }];
    }
}

+(void) setPlayerDelegate:(PlayerViewController *)delegate{
    [[self getPlayer] setPlaybackDelegate:delegate];
}

@end
