//
//  APPhotoCell.m
//  PhotosApp
//
//  Created by Андрей Полунин on 3/23/16.
//  Copyright © 2016 Andrey Polunin. All rights reserved.
//

#import "APPhotoCell.h"

@import Photos;

@interface APPhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) PHImageRequestID requestId;

@end

@implementation APPhotoCell

#pragma mark - Initialize

- (void)awakeFromNib {
    self.imageView.clipsToBounds = YES;
}


#pragma mark - Public

+ (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass([self class])];
}

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)configureWithAsset:(PHAsset *)asset imageContentMode:(UIViewContentMode)mode {
    if (self.requestId != 0) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestId];
        self.requestId = 0;
    }

    self.imageView.contentMode = mode;

    self.requestId = [[PHImageManager defaultManager] requestImageForAsset:asset
                                                                targetSize:self.imageView.frame.size
                                                               contentMode:PHImageContentModeAspectFill
                                                                   options:nil
                                                             resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                                 self.imageView.image = result;
                                                             }];
}


#pragma mark - Ovveride

- (void)prepareForReuse {
    self.imageView.image = nil;
}

@end
