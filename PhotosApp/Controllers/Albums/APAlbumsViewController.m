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
#import "APAlbumDetailViewController.h"

@import Photos;


static NSString *const kShowAlbumSegue = @"ShowAlbumSegue";

@interface APAlbumsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIAlertController *unauthorizedAlert;
@property (strong, nonatomic) UIAlertController *preauthorizedAlert;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *fetchIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) APPhotoAlbum *selectedAlbum;
@property (strong, nonatomic) NSArray<APPhotoAlbum *> *albums;

@end

@implementation APAlbumsViewController

#pragma mark - Lifecyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupViews];
    [self preRequestPermission];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Animate desseclect
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setup

- (void)setupViews {
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

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


#pragma mark - Photo permission

- (void)requestPermission {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupWithAuthorization:status];
        });
    }];
}

- (void)preRequestPermission {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [self presentViewController:self.preauthorizedAlert animated:YES completion:nil];
    } else {
        [self requestPermission];
    }
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


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    self.selectedAlbum = self.albums[indexPath.row];
    [self performSegueWithIdentifier:kShowAlbumSegue sender:self];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kShowAlbumSegue]) {
        APAlbumDetailViewController *vc = segue.destinationViewController;
        vc.album = self.selectedAlbum;
    }
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

- (UIAlertController *)preauthorizedAlert {
    if (!_preauthorizedAlert) {
        _preauthorizedAlert = [UIAlertController
                              alertControllerWithTitle:@"Запрос на разрешение доступа"
                              message:@"Для работы приложения необходим доступ к фотографиям"
                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* exitButton = [UIAlertAction
                                     actionWithTitle:@"Выход"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         exit(0);
                                     }];
        __weak typeof(self) wSelf = self;
        UIAlertAction* startAutorizationButton = [UIAlertAction
                                         actionWithTitle:@"Разрешить доступ"
                                         style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action)
                                                  {
                                                      [wSelf requestPermission];
                                                  }];

        [_preauthorizedAlert addAction:startAutorizationButton];
        [_preauthorizedAlert addAction:exitButton];
    }
    return _preauthorizedAlert;
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
