//
//  PlayerViewController.m
//  proyecto_spotify
//
//  Created by Jorge Salas C on 8/23/15.
//  Copyright (c) 2015 Jorge Salas C. All rights reserved.
//

#import "PlayerViewController.h"
#import "SpotifyHelper.h"

@implementation PlayerViewController

//METER EN UN NAV CONTROLLER PARA PODER REGRESAR
//TODO: VER PORQUE NO REPRODUCE NUNCA EL TRACK 4 (INDEX 3) DEL PLAYLIST

-(void) viewDidLoad{
    [super viewDidLoad];
    NSLog(@"Track List from segue contains %@", self.tracks);
    NSLog(@"Current track from segue contains %@", self.currentTrack);
    NSLog(@"Track pointer from segue contains %@", self.trackPointer);
    [SpotifyHelper playSongList:self.tracks fromIndex:self.trackPointer];
    [self updateTrackImage];
    [self updateTrackName];
}


- (IBAction)goToPreviousSong:(id)sender {
    
    if([[SpotifyHelper getPlayer] currentTrackIndex] > 0){
        [SpotifyHelper goToPreviousSongWithTarget:self];
    }
    else{
        NSLog(@"Did not call goToPrevious method");
    }
    
}

- (IBAction)pauseSong:(id)sender {
    [SpotifyHelper pauseSong];
}

- (IBAction)playSong:(id)sender {
    [SpotifyHelper playOrResumeSong];
}

- (IBAction)goToNextSong:(id)sender {
    if([[SpotifyHelper getPlayer] currentTrackIndex] < ( [self.tracks count]) - 1){
        [SpotifyHelper goToNextSongWithTarget:self];
    }
    else{
        NSLog(@"Did not call goToNext method");
    }
}

-(void) updateTrackImage{
    if ([self.currentTrack.album.covers count] > 0) {
        //SPTImage* image = [self.currentTrack.album.covers objectAtIndex:0];
        SPTImage* image = self.currentTrack.album.largestCover;
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: image.imageURL];
            if ( data == nil ){
                NSLog(@"Image of track %@ has no data", self.currentTrack.name);
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.albumImage.image = [UIImage imageWithData: data];
            });
        });
    }
    else{
        NSLog(@"Track %@ has no images", self.currentTrack.name);
        //TODO: Use an image placeholder if one cannot be loaded
    }
}

-(void) updateTrackName{
    self.songNameLabel.text = self.currentTrack.name;
}

-(void) updateCurrentTrack{
    NSLog(@"Track BEFORE changing: %d: %@ - %@", [[SpotifyHelper getPlayer] currentTrackIndex], self.currentTrack.name, self.currentTrack.uri);
    self.currentTrack = [self.tracks objectAtIndex:[[SpotifyHelper getPlayer] currentTrackIndex]];
    NSLog(@"Track AFTER changing: %d: %@ - %@", [[SpotifyHelper getPlayer] currentTrackIndex], self.currentTrack.name, self.currentTrack.uri);
    [self updateTrackImage];
    [self updateTrackName];
}

@end
