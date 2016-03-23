//
//  ViewController.m
//  PhotosApp
//
//  Created by Андрей Полунин on 3/22/16.
//  Copyright © 2016 Andrey Polunin. All rights reserved.
//

#import "APAlbumsViewController.h"
#import "APPhotoAlbum.h"
#import "APAlbumTableViewCell.h"

@import Photos;

@interface APAlbumsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIAlertController *unauthorizedAlert;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *fetchIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSArray<APPhotoAlbum *> *albums;

@end

@implementation APAlbumsViewController

#pragma mark - Lifecyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self requestPermission];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setup

- (void)setupWithAuthorization:(PHAuthorizationStatus)status {
    if (status == PHAuthorizationStatusAuthorized) {
        [self setupAuthorized];
    } else {
        [self setupUnauthorized];
    }
}

- (void)setupAuthorized {
    [self setupDataSource];
}

- (void)setupUnauthorized {
    [self presentViewController:self.unauthorizedAlert animated:YES completion:nil];
}

- (void)setupDataSource {
    [self showActivity];
    [APPhotoAlbum fetchPhotoAlbumsWithCompletion:^(NSArray<APPhotoAlbum *> *albums) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.albums = albums;
            [self reloadData];
            [self hideActivity];
        });
    }];

}


#pragma mark - Reload data

- (void)reloadData {
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    APAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[APAlbumTableViewCell reuseIdentifier]
                                                                 forIndexPath:indexPath];
    [cell configureWithAlbum:self.albums[indexPath.row]];

    return cell;
}


#pragma mark - Photo permission

- (void)requestPermission {
    __weak typeof(self) wSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wSelf setupWithAuthorization:status];
        });
    }];
}


#pragma mark - Private properties

- (UIAlertController *)unauthorizedAlert {
    if (!_unauthorizedAlert) {
        _unauthorizedAlert = [UIAlertController
                              alertControllerWithTitle:@"Нет доступа к фотографиям"
                              message:@"Для работы приложения необходим доступ к фотографиям"
                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* exitButton = [UIAlertAction
                                    actionWithTitle:@"Выход"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        exit(0);
                                    }];
        UIAlertAction* settingsButton = [UIAlertAction
                                     actionWithTitle:@"Настройки доступа"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                         exit(0);
                                     }];

        [_unauthorizedAlert addAction:settingsButton];
        [_unauthorizedAlert addAction:exitButton];
    }
    return _unauthorizedAlert;
}


#pragma mark - Private 

- (void)showActivity {
    self.fetchIndicator.hidden = NO;
    [self.fetchIndicator startAnimating];
}

- (void)hideActivity {
    self.fetchIndicator.hidden = YES;
    [self.fetchIndicator stopAnimating];
}


@end
