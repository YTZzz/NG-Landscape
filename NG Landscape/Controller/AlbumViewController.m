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

@interface AlbumViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, DismissPageViewControllerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *albumCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *albumCollectionViewLayout;
@property (weak, nonatomic) IBOutlet UIScrollView *transitionScrollView;
@property (strong, nonatomic) UIImageView * transitionImageView;
@property (strong, nonatomic) UIPageViewController * photoPageViewController;

@property (strong, nonatomic) NSMutableArray <PhotoObject *> * photoObjectsArray;
@property (strong, nonatomic) NSMutableArray * photoViewControlersArray;
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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // 由于 navigationBar 会挡住后面的内容，故重设 UIEdgeInsetsMake
    if (self.albumCollectionView.contentInset.top == 0) {
        self.albumCollectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);
    }
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
    self.photoViewControlersArray = [[NSMutableArray alloc]init];
    
    self.networkManager = [NetworkManager sharedInstance];
        
    self.transitionImageView = [[UIImageView alloc]init];
    self.transitionImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.transitionImageView.backgroundColor = [UIColor blackColor];
    [self.transitionScrollView addSubview:self.transitionImageView];
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

            PhotoViewController * photoViewController = nil;
            if (i < weakSelf.photoViewControlersArray.count) {
                photoViewController = [weakSelf.photoViewControlersArray objectAtIndex:i];
            } else {
                photoViewController = [[PhotoViewController alloc]initWithNibName:@"PhotoViewController" bundle:nil];
                photoViewController.delegate = weakSelf;
                [weakSelf.photoViewControlersArray addObject:photoViewController];
            }
            photoViewController.photoObject = photoObject;
            photoViewController.isNeedRefreshData = YES;
        }
        
        if (receivedPhotosArray.count < self.photoObjectsArray.count) {
            for (int i = (int)receivedPhotosArray.count; i < self.photoObjectsArray.count; i++) {
                [self.photoObjectsArray removeObjectAtIndex:i];
                [self.photoViewControlersArray removeObjectAtIndex:i];
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
    self.albumCollectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);
    [self.albumCollectionView setContentOffset:CGPointZero animated:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (self.photoObjectsArray.count == 0) {
//        return 15;
//    }
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
    
    if (self.photoPageViewController == nil) {
        self.photoPageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        self.photoPageViewController.dataSource = self;
        self.photoPageViewController.delegate = self;
    }
    
    PhotoViewController * photoViewController = [self.photoViewControlersArray objectAtIndex:indexPath.row];
    [self.photoPageViewController setViewControllers:@[photoViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    AlbumCollectionViewCell * albumCollectionViewCell = (AlbumCollectionViewCell *)[self.albumCollectionView cellForItemAtIndexPath:indexPath];
    
//    self.transitionImageView.image = cell.imageView.image;
//    UIWindow * window = self.view.window;
//    CGPoint startPointInWindow = [cell convertPoint:CGPointZero toView:window];
//    self.transitionImageView.frame = CGRectMake(startPointInWindow.x, startPointInWindow.y, cell.frame.size.width, cell.frame.size.height);
//    
//    [self.view bringSubviewToFront:self.transitionScrollView];
//    [self.transitionScrollView zoomToRect:cell.imageView.frame animated:YES];
//    
//    [self presentViewController:self.photoPageViewController animated:NO completion:nil];
//    [self.view sendSubviewToBack:self.transitionScrollView];

    [UIView animateWithDuration:2 animations:^(){
        
        [albumCollectionViewCell.imageView setFrame:CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH * 2 / 3) / 2, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [albumCollectionViewCell setBackgroundColor:[UIColor blackColor]];
        
    } completion:^(BOOL finished){
    
        if (finished) {
            [self presentViewController:self.photoPageViewController animated:NO completion:nil];
        }
        
    }];
}

#pragma mark - UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if (self.photoViewControlersArray.firstObject == viewController) {
        return nil;
    }
    int index = (int)[self.photoViewControlersArray indexOfObject:viewController] - 1;
    return  [self.photoViewControlersArray objectAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if (self.photoViewControlersArray.lastObject == viewController) {
        return nil;
    }
    int index = (int)[self.photoViewControlersArray indexOfObject:viewController] + 1;
    return  [self.photoViewControlersArray objectAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate

- (UIInterfaceOrientationMask)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController {
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - DismissPageViewControllerDelegate

- (void)disMissPageViewController {
    [self.photoPageViewController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.transitionImageView;
}

@end
