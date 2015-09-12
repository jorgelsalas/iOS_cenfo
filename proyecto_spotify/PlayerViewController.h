//
//  PlayerViewController.h
//  proyecto_spotify
//
//  Created by Jorge Salas C on 8/23/15.
//  Copyright (c) 2015 Jorge Salas C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>

@interface PlayerViewController : UIViewController <SPTAudioStreamingPlaybackDelegate>

@property (nonatomic,strong) NSMutableArray* tracks;
@property (nonatomic, strong) SPTTrack* currentTrack;
@property (nonatomic, strong) NSNumber* trackPointer;
@property (nonatomic, weak) IBOutlet UIImageView *albumImage;
@property (nonatomic, weak) IBOutlet UILabel* songNameLabel;

-(void) updateTrackImage;
-(void) updateTrackName;
-(void) updateCurrentTrack;

@end
