//
//  MainCollectionViewController.m
//  NG Landscape
//
//  Created by Sodapig on 2016/10/17.
//  Copyright © 2016年 Taozhu Ye. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "MainCollectionViewCell.h"
#import "AlbumViewController.h"
#import "AlbumObject.h"
#import "Definition.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

@interface MainCollectionViewController ()

@property (strong, nonatomic) IBOutlet UICollectionView *MainCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *mainCollectionViewLayout;

@property (strong, nonatomic) AlbumViewController * albumViewController;

@property (strong, nonatomic) NSMutableArray <AlbumObject *> * albumObjectsArray;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) int loadAlbumsCount;
@property (assign, nonatomic) int totalAlbumsCount;
@property (strong, nonatomic) NSString * reuseIdentifier;
@property (assign, nonatomic) UIInterfaceOrientation collectionViewOrientationInBackground;

@property (strong, nonatomic) NetworkManager * netWorkManager;

@end

@implementation MainCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAllViewsAndVariables];

    [self loadAlubmsWithPage:self.currentPage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initAllViewsAndVariables {
    
    self.albumObjectsArray = [[NSMutableArray alloc]init];
    self.currentPage = 1;
    self.loadAlbumsCount = 0;
    self.totalAlbumsCount = 0;
    self.reuseIdentifier = @"MainCollectionViewCell";
        
    UINib *cellNib = [UINib nibWithNibName:self.reuseIdentifier bundle:nil];
    [self.MainCollectionView registerNib:cellNib forCellWithReuseIdentifier:self.reuseIdentifier];
    self.mainCollectionViewLayout.minimumLineSpacing = 0;
    self.mainCollectionViewLayout.minimumInteritemSpacing = 0;
    self.mainCollectionViewLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 2 / 3);
    
    self.MainCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirstPage)];
    self.MainCollectionView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorePage)];
    
    self.netWorkManager = [NetworkManager sharedInstance];
}

- (void)loadFirstPage {
    [self loadAlubmsWithPage:1];
    [self.MainCollectionView.mj_header endRefreshing];
}

- (void)loadMorePage {
    [self loadAlubmsWithPage:self.currentPage+1];
    [self.MainCollectionView.mj_footer endRefreshing];
}

- (void)loadAlubmsWithPage:(int)page {
    
    NSLog(@"loadAlubmsWithPage:page = %d begin!", page);
    
    __weak typeof(self) weakSelf = self;
    
    if (page == 1) {
        [self.albumObjectsArray removeAllObjects];
        self.loadAlbumsCount = 0;
        self.totalAlbumsCount = 0;
    }
    
    if (self.totalAlbumsCount != 0
        && self.totalAlbumsCount == self.loadAlbumsCount) {
        
        // TODO: 显示已加载完所有数据
        
        return;
    }
    
    [self.netWorkManager getAlbumObjectsFromServerWithPage:page completionHandler:^(NSDictionary * receivedAlbumsDict) {
        
        if (receivedAlbumsDict == nil) {
            NSLog(@"ERROR: receivedAlbumsDict = nil");
            return;
        }
        
        if ([receivedAlbumsDict objectForKey:@"album"] == NO) {
            NSLog(@"ERROR : [receivedAlbumsDict objectForKey:%@] == NO;", @"album");
            return;
        }
        
        // 更新目前页数
        if ([receivedAlbumsDict objectForKey:@"page"]) {
            weakSelf.currentPage = [NSString stringWithString:[receivedAlbumsDict objectForKey:@"page"]].intValue;
        }
        // 更新目前加载过的相册数
        if ([receivedAlbumsDict objectForKey:@"pagecount"]) {
            self.loadAlbumsCount += [NSString stringWithString:[receivedAlbumsDict objectForKey:@"pagecount"]].intValue;
        }
        // 更新总相册数
        if ([receivedAlbumsDict objectForKey:@"total"]) {
            weakSelf.totalAlbumsCount = [NSString stringWithString:[receivedAlbumsDict objectForKey:@"total"]].intValue;
        }
        
        NSArray * receivedAlbumsArray = nil;
        receivedAlbumsArray = [receivedAlbumsDict objectForKey:@"album"];
        
        for (NSDictionary * dict in receivedAlbumsArray) {
            AlbumObject * albumObject = [[AlbumObject alloc]init];
            [albumObject setAlbumObjectWithDictionary:dict];
            [weakSelf.albumObjectsArray addObject:albumObject];
        }
        
        dispatch_async(MAIN_QUEUE, ^(){
            [weakSelf.MainCollectionView reloadData];
            NSLog(@"loadAlubmsWithPage:page = %d end!", page);
        });
    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    if (size.width > size.height) {
        self.mainCollectionViewLayout.itemSize = CGSizeMake(size.width / 2, size.width / 3);
    } else {
        self.mainCollectionViewLayout.itemSize = CGSizeMake(size.width, size.width * 2 / 3);
    }
    [self.MainCollectionView performBatchUpdates:nil completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark  - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumObjectsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.albumObjectsArray.count) {
        AlbumObject * albumObject = [self.albumObjectsArray objectAtIndex:indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:albumObject.url]];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.albumObjectsArray.count == NO) {
        NSLog(@"ERROR : indexPath.row < self.albumObjectsArray.count == NO");
        return;
    }
    
    if (self.albumViewController == nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.albumViewController = [storyboard instantiateViewControllerWithIdentifier:@"AlbumViewController"];
    }

    AlbumObject * albumObject = [self.albumObjectsArray objectAtIndex:indexPath.row];
    if (albumObject) {
        
        if (self.albumViewController.albumObject
            && self.albumViewController.albumObject != albumObject) {
            
            self.albumViewController.isRefreshData = YES;
        }
        
        self.albumViewController.albumObject = albumObject;
        [self.navigationController pushViewController:self.albumViewController animated:YES];
    }
}

@end
