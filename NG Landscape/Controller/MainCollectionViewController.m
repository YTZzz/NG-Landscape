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

@property (strong, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *mainCollectionViewLayout;

@property (strong, nonatomic) NSMutableArray <AlbumObject *> * albumObjectsArray;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) int loadAlbumsCount;
@property (assign, nonatomic) int totalAlbumsCount;
@property (strong, nonatomic) NSString * reuseIdentifier;
@property (assign, nonatomic) int row;

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
    
    self.title = @"首页";
    
    self.albumObjectsArray = [[NSMutableArray alloc]init];
    self.currentPage = 1;
    self.loadAlbumsCount = 0;
    self.totalAlbumsCount = 0;
    self.reuseIdentifier = @"MainCollectionViewCell";
        
    UINib *cellNib = [UINib nibWithNibName:self.reuseIdentifier bundle:nil];
    [self.mainCollectionView registerNib:cellNib forCellWithReuseIdentifier:self.reuseIdentifier];
    self.mainCollectionViewLayout.minimumLineSpacing = 0;
    self.mainCollectionViewLayout.minimumInteritemSpacing = 0;
    self.mainCollectionViewLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 2 / 3);
    
    self.mainCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirstPage)];
    self.mainCollectionView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorePage)];
    
    self.netWorkManager = [NetworkManager sharedInstance];
}

- (void)loadFirstPage {
    [self loadAlubmsWithPage:1];
    [self.mainCollectionView.mj_header endRefreshing];
}

- (void)loadMorePage {
    [self loadAlubmsWithPage:self.currentPage+1];
    [self.mainCollectionView.mj_footer endRefreshing];
}

- (void)loadAlubmsWithPage:(int)page {
    
    NSLog(@"loadAlubmsWithPage:page = %d begin!", page);
    
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
    
    __weak typeof(self) weakSelf = self;
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
            [weakSelf.mainCollectionView reloadData];
            NSLog(@"loadAlubmsWithPage:page = %d end!", page);
        });
    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // 旋转屏幕之后，调整 itemSize
    CGSize originalItemSize = self.mainCollectionViewLayout.itemSize;
    if (size.width > size.height) {
        self.mainCollectionViewLayout.itemSize = CGSizeMake(size.width / 2, size.width / 3);
    } else {
        self.mainCollectionViewLayout.itemSize = CGSizeMake(size.width, size.width * 2 / 3);
    }
    if (originalItemSize.width == self.mainCollectionViewLayout.itemSize.width) {
        return;
    }
    
    // 将之前可见的（不被 navigationBar 遮挡的）最上方的 cell 滚动至最上方
    UICollectionViewCell * firstVisableCell = self.mainCollectionView.visibleCells.firstObject;
    for (UICollectionViewCell * cell in self.mainCollectionView.visibleCells) {
        if (cell.frame.origin.y < firstVisableCell.frame.origin.y
            || (cell.frame.origin.y == firstVisableCell.frame.origin.y && cell.frame.origin.x < firstVisableCell.frame.origin.x)) {
            
            if ([cell convertPoint:cell.frame.origin toView:self.view.window].y > CGRectGetMaxY(self.navigationController.navigationBar.frame)) {
                
                firstVisableCell = cell;
            }
        }
    }
    NSIndexPath * indexPath = [self.mainCollectionView indexPathForCell:firstVisableCell];
    
    __weak typeof(self) weakSelf = self;
    [self.mainCollectionView performBatchUpdates:nil completion:^(BOOL finished){
        if (finished) {
            [weakSelf.mainCollectionView scrollToItemAtIndexPath:indexPath
                                                atScrollPosition:UICollectionViewScrollPositionTop
                                                        animated:NO];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    AlbumViewController * albumViewController = [segue destinationViewController];
    albumViewController.albumObject = [self.albumObjectsArray objectAtIndex:self.row];
}


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
    self.row = (int)indexPath.row;
    [self performSegueWithIdentifier:@"showAlbumViewController" sender:nil];
}


@end
