//
//  AlbumCollectionViewController.h
//  NG Landscape
//
//  Created by Sodapig on 2016/10/15.
//  Copyright © 2016年 Taozhu Ye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumObject.h"

@interface AlbumViewController : UIViewController

@property (weak, nonatomic) AlbumObject * albumObject;

- (void)rotateCollectionViewWithSize:(CGSize)size;

@end
