//
//  PhotoViewController.h
//  NG Landscape
//
//  Created by Sodapig on 2016/10/20.
//  Copyright © 2016年 Taozhu Ye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoObject.h"

@protocol DismissPageViewControllerDelegate <NSObject>

- (void)disMissPageViewController;

@end

@interface PhotoViewController : UIViewController

@property (weak, nonatomic) PhotoObject * photoObject;
@property (assign, nonatomic) BOOL isNeedRefreshData;

@property (assign, nonatomic) id <DismissPageViewControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIView *photoDetailView;

@end
