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
#import "SongListTableViewController.h"
#import "PlayerViewController.h"

@interface SpotifyHelper : NSObject
//@property (nonatomic, strong) SPTSession* session;
//@property (nonatomic, strong) SPTAudioStreamingController *player;

+(void) requestSessionUsingApplication:(UIApplication*)application;
+(BOOL) handleAuthRequestWithUrl:(NSURL*)url;
+(void) setSession:(SPTSession *)session;
+(SPTSession*) getSession;
+(void) setPlayer:(SPTAudioStreamingController *)newPlayer;
+(SPTAudioStreamingController*) getPlayer;
+(void) searchForArtist;
+(void) searchForArtist:(NSString*)artist withCallback:(SEL)callback;
+(void) searchForArtist:(NSString*)artist withTarget:(ArtistSearchTableViewController*)target;
+(void) searchForFullArtists:(NSArray*)artistURIs withTarget:(ArtistSearchTableViewController*)target;
+(void) promoteToFullArtist:(NSString*)artistID;
+(void) searchForTopSongs:(SPTArtist*)artist withTarget:(SongListTableViewController*)target;
+(void) playSong:(SPTTrack*)track;
+(void) playSongList:(NSMutableArray*)tracks;
+(void) playSongList:(NSMutableArray*)tracks fromIndex:(NSNumber*)index;
+(void) pauseSong;
+(void) playOrResumeSong;
+(void) goToNextSong;
+(void) goToPreviousSong;
+(void) goToNextSongWithTarget:(PlayerViewController*)target;
+(void) goToPreviousSongWithTarget:(PlayerViewController*)target;
+(void) setPlayerDelegate:(PlayerViewController*)delegate;
+(void) setTracks:(NSMutableArray*)tracks fromIndex:(NSNumber*)index;
@end

