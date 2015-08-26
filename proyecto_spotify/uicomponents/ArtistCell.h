//
//  ArtistCell.h
//  proyecto_spotify
//
//  Created by Jorge Salas Chacon on 8/25/15.
//  Copyright (c) 2015 Jorge Salas C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *artistName;
@property (nonatomic, weak) IBOutlet UIImageView *artistImage;

@end
