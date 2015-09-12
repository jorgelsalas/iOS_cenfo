//
//  SongListTableViewController.m
//  proyecto_spotify
//
//  Created by Jorge Salas C on 8/23/15.
//  Copyright (c) 2015 Jorge Salas C. All rights reserved.
//

#import "SongListTableViewController.h"
#import "SongCell.h"
#import "SpotifyHelper.h"
#import "PlayerViewController.h"

@implementation SongListTableViewController



-(void) viewDidLoad{
    [super viewDidLoad];
    NSLog(@"Artst from segue contains %@", self.artist);
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [SpotifyHelper searchForTopSongs:self.artist withTarget:self];
}

-(void) updateTracks:(NSMutableArray *)newTracks{
    self.tracks = newTracks;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.tracks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongCell" forIndexPath:indexPath];
    
    // Configure the cell...
    SPTTrack* track = self.tracks[indexPath.row];
    cell.songName.text = track.name;
    
    if ([track.album.covers count] > 0) {
        SPTImage* image = [track.album.covers objectAtIndex:0];
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: image.imageURL];
            if ( data == nil ){
                NSLog(@"Image of track %@ has no data", track.name);
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // WARNING: is the cell still using the same data by this point??
                cell.albumImage.image = [UIImage imageWithData: data];
            });
        });
    }
    else{
        NSLog(@"Track %@ has no images", track.name);
    }
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"PlaySongSegue"]) {
        //NSIndexPath* indexPath = sender;
        NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
        SPTTrack* track = [self.tracks objectAtIndex:indexPath.row];
        UINavigationController* navController = segue.destinationViewController;
        PlayerViewController* playerController = [navController.viewControllers firstObject];
        //PlayerViewController* playerController = segue.destinationViewController;
        
        playerController.currentTrack = track;
        playerController.tracks = self.tracks;
        playerController.trackPointer = [NSNumber numberWithInteger:indexPath.row];
    }
}

@end
