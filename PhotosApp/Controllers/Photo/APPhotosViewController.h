//
//  APPhotosViewController.h
//  PhotosApp
//
//  Created by Андрей Полунин on 3/23/16.
//  Copyright © 2016 Andrey Polunin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APPhotoAlbum;

@interface APPhotosViewController : UIViewController

@property (strong, nonatomic) APPhotoAlbum *album;
@property (assign, nonatomic) NSInteger startIndex;

@end
