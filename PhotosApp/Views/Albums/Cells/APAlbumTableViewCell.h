//
//  APAlbumTableViewCell.h
//  PhotosApp
//
//  Created by Андрей Полунин on 3/23/16.
//  Copyright © 2016 Andrey Polunin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APPhotoAlbums;


@interface APAlbumTableViewCell : UITableViewCell

+ (NSString *)reuseIdentifier;
- (void)configureWithAlbum:(APPhotoAlbums *)album;

@end
