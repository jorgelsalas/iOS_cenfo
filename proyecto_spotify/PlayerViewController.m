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
//TODO: Cargar imagen, enviar grupo de tracks a player, odificar imagen al ir a prev y next
//METER EN UN NAV CONTROLLER PARA PODER REGRESAR
//AGREGAR CALLBACKS AL PLAYER PARA ACTUALIZAR EL CURRENT TRACK, IMAGEN Y NOMBRE EN LA PANTALLA
//UTILIZAR PROPIEDAD CURRENT TRACK INDEX DEL PLAYER

-(void) viewDidLoad{
    [super viewDidLoad];
    NSLog(@"Track List from segue contains %@", self.tracks);
    NSLog(@"Current track from segue contains %@", self.currentTrack);
    NSLog(@"Track pointer from segue contains %@", self.trackPointer);
    [SpotifyHelper playSongList:self.tracks];
    [self updateTrackImage];
    [self updateTrackName];
}


- (IBAction)goToPreviousSong:(id)sender {
    
    if([[SpotifyHelper getPlayer] currentTrackIndex] > 0){
        //NSLog(@"Track BEFORE going to next: %d: %@", [[SpotifyHelper getPlayer] currentTrackIndex], self.currentTrack.name);
        //[SpotifyHelper goToPreviousSong];
        //self.trackPointer = [NSNumber numberWithLong:([self.trackPointer longValue] - 1)];
        //self.currentTrack = [self.tracks objectAtIndex:[self.trackPointer integerValue]];
        //self.currentTrack = [self.tracks objectAtIndex:[[SpotifyHelper getPlayer] currentTrackIndex]];
        //NSLog(@"Track AFTER going to next: %d: %@", [[SpotifyHelper getPlayer] currentTrackIndex], self.currentTrack.name);
        //[self updateTrackImage];
        //[self updateTrackName];
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
    //NOTA PUEDE HABER RACE CONDITIONS QUE HAGAN QUE NO ACTUALICE BIEN
    if([[SpotifyHelper getPlayer] currentTrackIndex] < ( [self.tracks count]) - 1){
        //NSLog(@"Track BEFORE going to next: %d: %@", [[SpotifyHelper getPlayer] currentTrackIndex], self.currentTrack.name);
        //[SpotifyHelper goToNextSong];
        //self.trackPointer = [NSNumber numberWithLong:([self.trackPointer longValue] + 1)];
        //self.currentTrack = [self.tracks objectAtIndex:[self.trackPointer integerValue]];
        //self.currentTrack = [self.tracks objectAtIndex:[[SpotifyHelper getPlayer] currentTrackIndex]];
        //NSLog(@"Track AFTER going to next: %d: %@", [[SpotifyHelper getPlayer] currentTrackIndex], self.currentTrack.name);
        //[self updateTrackImage];
        //[self updateTrackName];
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
                // WARNING: is the cell still using the same data by this point??
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
    NSLog(@"Track BEFORE changing: %d: %@", [[SpotifyHelper getPlayer] currentTrackIndex], self.currentTrack.name);
    self.currentTrack = [self.tracks objectAtIndex:[[SpotifyHelper getPlayer] currentTrackIndex]];
    NSLog(@"Track AFTER changing: %d: %@", [[SpotifyHelper getPlayer] currentTrackIndex], self.currentTrack.name);
    [self updateTrackImage];
    [self updateTrackName];
}

@end
