//
//  SongCell.h
//  proyecto_spotify
//
//  Created by Jorge Salas Chacon on 8/25/15.
//  Copyright (c) 2015 Jorge Salas C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *songName;
@property (nonatomic, weak) IBOutlet UIImageView *albumImage;

@end
