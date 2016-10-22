//
//  PhotoPageViewController.m
//  NG Landscape
//
//  Created by Sodapig on 2016/10/22.
//  Copyright © 2016年 Taozhu Ye. All rights reserved.
//

#import "PhotoPageViewController.h"
#import "PhotoViewController.h"

@interface PhotoPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) NSMutableArray * photoViewControlersArray;

@end

@implementation PhotoPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
