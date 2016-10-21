//
//  NetworkManager.m
//  NG Landscape
//
//  Created by Sodapig on 2016/10/15.
//  Copyright © 2016年 Taozhu Ye. All rights reserved.
//

#import "NetworkManager.h"
#import "Definition.h"
#import "AlbumObject.h"
#import "PhotoObject.h"

@implementation NetworkManager

static id _instance;

//重写allocWithZone:方法，在这里创建唯一的实例(注意线程安全)
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    }
    return _instance;
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return _instance;
}

+ (instancetype)sharedInstance{
    @synchronized(self){
        if(_instance == nil){
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (void)getAlbumObjectsFromServerWithPage:(int)page completionHandler:(void(^)(NSDictionary * receivedAlbumsDict))completionHandler {

    dispatch_async(DEFAULT_QUEUE, ^{
        

        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:GET_ALBUMS_URL, page]];
        NSURLSession * session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"ERROR : getAlbumsFromServerWithPage:%d error = %@", page, error.description);
                return;
            }
            NSDictionary * receivedAlbumsDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            completionHandler(receivedAlbumsDict);
            
        }];
        [task resume];
    });
    
    return;
}

- (void)getPhotoObjectsFromServerWithAlbumId:(int)albumId completionHandler:(void(^)(NSDictionary * receivedPhotoDict))completionHandler {

    dispatch_async(DEFAULT_QUEUE, ^{
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:GET_PHOTOS_URL, albumId]];
        NSURLSession * session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"ERROR : getPhotosFromServerWithAlbumId:%d error = %@", albumId, error.description);
            } else {
                NSDictionary * receivedPhotoDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                completionHandler(receivedPhotoDict);
            }
        }];
        [task resume];
    });
}

@end
