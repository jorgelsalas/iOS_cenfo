//
//  ArtistSearchTableViewController.m
//  proyecto_spotify
//
//  Created by Jorge Salas C on 8/23/15.
//  Copyright (c) 2015 Jorge Salas C. All rights reserved.
//

#import <Spotify/Spotify.h>
#import "ArtistSearchTableViewController.h"
#import "SongListTableViewController.h"
#import "ArtistCell.h"
#import "SpotifyHelper.h"

@interface ArtistSearchTableViewController()

@property (nonatomic,strong) NSMutableArray* artists;

@end


@implementation ArtistSearchTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.mySearchBar.delegate = self;
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"SEARCH BAR HAS: \n%@", searchBar.text);
    [SpotifyHelper searchForArtist:searchBar.text withTarget:self];
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
    SPTArtist* artist = self.artists[indexPath.row];
    cell.artistName.text = artist.name;
    
    if ([artist.images count] > 0) {
        SPTImage* image = [artist.images objectAtIndex:0];
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: image.imageURL];
            if ( data == nil ){
                NSLog(@"Image of artist %@ has no data", artist.name);
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // WARNING: is the cell still using the same data by this point??
                cell.artistImage.image = [UIImage imageWithData: data];
            });
        });
    }
    else{
        NSLog(@"Artist %@ has no images", artist.name);
    }
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"ViewArtistSongsSegue"]) {
        //NSIndexPath* indexPath = sender;
        NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
        SPTArtist* artist = [self.artists objectAtIndex:indexPath.row];
        //UINavigationController* navController = segue.destinationViewController;
        //SongListTableViewController* songListController = [navController.viewControllers firstObject];
        SongListTableViewController* songListController = segue.destinationViewController;
        
        songListController.artist = artist;
    }
}

@end
