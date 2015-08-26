//
//  ArtistSearchTableViewController.m
//  proyecto_spotify
//
//  Created by Jorge Salas C on 8/23/15.
//  Copyright (c) 2015 Jorge Salas C. All rights reserved.
//

#import <Spotify/Spotify.h>
#import "ArtistSearchTableViewController.h"
#import "ArtistCell.h"
#import "SpotifyHelper.h"

@interface ArtistSearchTableViewController()

@property (nonatomic,strong) NSMutableArray* artists;

@end


@implementation ArtistSearchTableViewController

- (void)viewDidLoad{
    [SpotifyHelper searchForArtist:@"Oasis" withTarget:self];
}



-(void) updateArtists:(NSMutableArray *)newArtists{
    self.artists = newArtists;
    [self.tableView reloadData];
}

-(void) requestArtistSearch:(NSString *)artistName{
    [SpotifyHelper searchForArtist];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.artists.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArtistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArtistCell" forIndexPath:indexPath];
    
    // Configure the cell...
    SPTPartialArtist* artist = self.artists[indexPath.row];
    cell.artistName.text = artist.name;
    return cell;
}

@end
