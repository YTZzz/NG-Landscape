//
//  NetworkManager.h
//  NG Landscape
//
//  Created by Sodapig on 2016/10/15.
//  Copyright © 2016年 Taozhu Ye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (instancetype)sharedInstance;

- (void)getAlbumObjectsFromServerWithPage:(int)page completionHandler:(void(^)(NSDictionary * receivedAlbumsDict))completionHandler;

- (void)getPhotoObjectsFromServerWithAlbumId:(int)albumId completionHandler:(void(^)(NSDictionary * receivedPhotoDict))completionHandler;

@end
