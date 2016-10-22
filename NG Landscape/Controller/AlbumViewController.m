//
//  AlbumCollectionViewController.m
//  NG Landscape
//
//  Created by Sodapig on 2016/10/15.
//  Copyright © 2016年 Taozhu Ye. All rights reserved.
//

#import "AlbumViewController.h"
#import "NetworkManager.h"
#import "AlbumCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "Definition.h"
#import "PhotoObject.h"
#import "PhotoBrowserController/PhotoBrowserNavigationController.h"

@interface AlbumViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *albumCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *albumCollectionViewLayout;
@property (strong, nonatomic) PhotoBrowserNavigationController * photoBrowserNavigationController;

@property (strong, nonatomic) NSMutableArray <PhotoObject *> * photoObjectsArray;
@property (strong, nonatomic) NSString * reuseIdentifier;

@property (strong, nonatomic) NetworkManager * networkManager;



@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAllViewsAndVariables];
    [self loadPhotos];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isRefreshData == YES) {
        self.isRefreshData = NO;
        [self.albumCollectionView setContentOffset:CGPointZero animated:NO];
        [self loadPhotos];
    }
    [self rotateCollectionViewWithSize:SCREEN_SIZE];
}

- (void)initAllViewsAndVariables {
    
    self.isRefreshData = NO;
    self.reuseIdentifier = @"AlbumCollectionViewCell";
    
    UINib *cellNib = [UINib nibWithNibName:self.reuseIdentifier bundle:nil];
    [self.albumCollectionView registerNib:cellNib forCellWithReuseIdentifier:self.reuseIdentifier];
    self.albumCollectionViewLayout.minimumLineSpacing = 0;
    self.albumCollectionViewLayout.minimumInteritemSpacing = 0;
    self.albumCollectionViewLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 2, SCREEN_WIDTH / 2);
    
    self.photoObjectsArray = [[NSMutableArray alloc]init];
    
    self.networkManager = [NetworkManager sharedInstance];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.photoBrowserNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"PhotoBrowserNavigationController"];
}

- (void)loadPhotos {
    
    NSLog(@"loadPhotos begin!");
    
    __weak typeof(self) weakSelf = self;
    
    [self.networkManager getPhotoObjectsFromServerWithAlbumId:self.albumObject.Id completionHandler:^(NSDictionary * receivedPhotoDict) {
        
        if (receivedPhotoDict == nil) {
            NSLog(@"ERROR: receivedPhotoDict = nil");
            return;
        }
        
        if ([receivedPhotoDict objectForKey:@"picture"] == NO) {
            NSLog(@"ERROR : [receivedPhotoDict objectForKey:%@] == NO;", @"picture");
            return;
        }
        
        NSArray * receivedPhotosArray = nil;
        receivedPhotosArray = [receivedPhotoDict objectForKey:@"picture"];
        
        for (int i = 0; i < receivedPhotosArray.count; i++) {
            
            PhotoObject * photoObject = nil;
            if (i < weakSelf.photoObjectsArray.count) {
                photoObject = [weakSelf.photoObjectsArray objectAtIndex:i];
            } else {
                photoObject = [[PhotoObject alloc]init];
                [weakSelf.photoObjectsArray addObject:photoObject];
            }
            NSDictionary * dict = [receivedPhotosArray objectAtIndex:i];
            [photoObject setPhotoObjectWithDictionary:dict];
        }
        
        if (receivedPhotosArray.count < self.photoObjectsArray.count) {
            for (int i = (int)receivedPhotosArray.count; i < self.photoObjectsArray.count; i++) {
                [self.photoObjectsArray removeObjectAtIndex:i];
            }
        }
        
        dispatch_async(MAIN_QUEUE, ^(){
            [weakSelf.albumCollectionView reloadData];
            NSLog(@"loadPhotos end!");
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self rotateCollectionViewWithSize:size];
}

- (void)rotateCollectionViewWithSize:(CGSize)size {
    
    CGSize originalItemSize = self.albumCollectionViewLayout.itemSize;
    if (size.width > size.height) {
        self.albumCollectionViewLayout.itemSize = CGSizeMake(size.width / 3, size.width / 3);
    } else {
        self.albumCollectionViewLayout.itemSize = CGSizeMake(size.width / 2, size.width / 2);
    }
    if (originalItemSize.width == self.albumCollectionViewLayout.itemSize.width) {
        return;
    }
    [self.albumCollectionView performBatchUpdates:nil completion:nil];
    [self.albumCollectionView setContentOffset:CGPointZero animated:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"self.photoObjectsArray.count = %ld", self.photoObjectsArray.count);
    return self.photoObjectsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.photoObjectsArray.count == NO) {
        NSLog(@"ERROR : indexPath.row < self.photoObjectsArray.count == NO");
        return cell;
    }
    
    PhotoObject * photoObject = [self.photoObjectsArray objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:photoObject.url] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboardSegue * segue = [UIStoryboardSegue segueWithIdentifier:@"PresentPhotoBrowserNavigationController"
                                                                source:self
                                                           destination:self.photoBrowserNavigationController performHandler:^(){
                                                               NSLog(@"UIStoryboardSegue : PresentPhotoBrowserNavigationController");
                                                           }];
    [self prepareForSegue:segue sender:self];
    [segue perform];
}


@end
