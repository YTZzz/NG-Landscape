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
#import "PhotoViewController.h"

@interface AlbumViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *albumCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *albumCollectionViewLayout;

@property (strong, nonatomic) NSMutableArray <PhotoObject *> * photoObjectsArray;

@property (strong, nonatomic) NSString * reuseIdentifier;
@property (assign, nonatomic) int row;

@property (strong, nonatomic) NetworkManager * networkManager;



@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAllViewsAndVariables];
    [self loadPhotos];
}

- (void)initAllViewsAndVariables {
    
    self.title = _albumObject.title;
    _reuseIdentifier = @"AlbumCollectionViewCell";
    
    UINib *cellNib = [UINib nibWithNibName:self.reuseIdentifier bundle:nil];
    [_albumCollectionView registerNib:cellNib forCellWithReuseIdentifier:self.reuseIdentifier];
    _albumCollectionViewLayout.minimumLineSpacing = 0;
    _albumCollectionViewLayout.minimumInteritemSpacing = 0;
    if (SCREEN_WIDTH > SCREEN_HEIGHT) {
        _albumCollectionViewLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 3, SCREEN_WIDTH / 3);
    } else {
        _albumCollectionViewLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 2, SCREEN_WIDTH / 2);
    }
    _albumCollectionView.delegate = self;
    
    _photoObjectsArray = [[NSMutableArray alloc]init];
    
    _networkManager = [NetworkManager sharedInstance];
}

- (void)loadPhotos {
    
    NSLog(@"loadPhotos begin!");
    
    __weak typeof(self) weakSelf = self;
    
    [_networkManager getPhotoObjectsFromServerWithAlbumId:self.albumObject.Id completionHandler:^(NSDictionary * receivedPhotoDict) {
        
        if (receivedPhotoDict == nil) {
            NSLog(@"ERROR: receivedPhotoDict = nil");
            return;
        }
        
        if ([receivedPhotoDict objectForKey:@"picture"] == NO) {
            NSLog(@"ERROR : [receivedPhotoDict objectForKey:%@] == NO;", @"picture");
            return;
        }
        
        NSArray * receivedPhotosArray = [receivedPhotoDict objectForKey:@"picture"];
        
        for (int i = 0; i < receivedPhotosArray.count; i++) {
            
            PhotoObject * photoObject = [[PhotoObject alloc]init];
            [weakSelf.photoObjectsArray addObject:photoObject];
            
            NSDictionary * dict = [receivedPhotosArray objectAtIndex:i];
            [photoObject setPhotoObjectWithDictionary:dict];
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
    
    // 旋转屏幕之后，调整 itemSize
    CGSize originalItemSize = _albumCollectionViewLayout.itemSize;
    if (size.width > size.height) {
        _albumCollectionViewLayout.itemSize = CGSizeMake(size.width / 3, size.width / 3);
    } else {
        _albumCollectionViewLayout.itemSize = CGSizeMake(size.width / 2, size.width / 2);
    }
    if (originalItemSize.width == _albumCollectionViewLayout.itemSize.width) {
        return;
    }
    
    // 将之前可见的（不被 navigationBar 遮挡的）最上方的 cell 滚动至最上方
    UICollectionViewCell * firstVisableCell = _albumCollectionView.visibleCells.firstObject;
    CGFloat sumOfXY = firstVisableCell.frame.origin.x + firstVisableCell.frame.origin.y;
    NSArray * visibleCellsArray = _albumCollectionView.visibleCells;

    for (UICollectionViewCell * cell in visibleCellsArray) {
        CGFloat tmpSumOfXY = cell.frame.origin.x + cell.frame.origin.y;
        if (tmpSumOfXY < sumOfXY) {
            sumOfXY = tmpSumOfXY;
            firstVisableCell = cell;
        }
    }
    NSIndexPath * indexPath = [_albumCollectionView indexPathForCell:firstVisableCell];
    
    __weak typeof(self) weakSelf = self;
    [_albumCollectionView performBatchUpdates:nil completion:^(BOOL finished){
        if (finished) {
            [weakSelf.albumCollectionView scrollToItemAtIndexPath:indexPath
                                                atScrollPosition:UICollectionViewScrollPositionTop
                                                        animated:NO];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoObjectsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < _photoObjectsArray.count == NO) {
        NSLog(@"ERROR : indexPath.row < self.photoObjectsArray.count == NO");
        return cell;
    }
    
    PhotoObject * photoObject = [_photoObjectsArray objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:photoObject.url] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _row = (int)indexPath.row;
    [self performSegueWithIdentifier:@"showPhotoViewController" sender:indexPath];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PhotoViewController * photoViewController = [segue destinationViewController];
    NSLog(@"photoViewController = %@", photoViewController);
    photoViewController.photoObjectsArray = _photoObjectsArray;
    photoViewController.row = _row;
}
@end

