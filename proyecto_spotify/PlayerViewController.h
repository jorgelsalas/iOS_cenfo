//
//  PlayerViewController.h
//  proyecto_spotify
//
//  Created by Jorge Salas C on 8/23/15.
//  Copyright (c) 2015 Jorge Salas C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>

@interface PlayerViewController : UIViewController

@property (nonatomic, strong) SPTTrack* currentTrack;

@end
