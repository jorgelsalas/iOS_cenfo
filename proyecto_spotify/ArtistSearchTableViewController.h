//
//  ArtistSearchTableViewController.h
//  proyecto_spotify
//
//  Created by Jorge Salas C on 8/23/15.
//  Copyright (c) 2015 Jorge Salas C. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ArtistSearchTableViewController : UITableViewController <UISearchBarDelegate>
@property(nonatomic, strong) IBOutlet UISearchBar* mySearchBar;

-(void) updateArtists:(NSMutableArray*)newArtists;
-(void) requestArtistSearch:(NSString*)artistName;

@end
