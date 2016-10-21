//
//  AlbumObject.m
//  A National Geographic Client
//
//  Created by Sodapig on 2016/9/13.
//  Copyright © 2016年 Taozhu Ye. All rights reserved.
//

/*
 
 {
 "id":"1341",
 "title":"2016-09-11每日精选",
 "url":"http://pic01.bdatu.com/Upload/appsimg/1473074323.jpg",
 "addtime":"2016-09-11 00:04:15",
 "adshow":"NO",
 "fabu":"YES",
 "encoded":"1",
 "amd5":"f1663cb9747874dbca4d51b372cb079e",
 "sort":"1527",
 "ds":"1",
 "timing":"1",
 "timingpublish":"2016-09-11 00:00:00"
 }
 
 int * Id;
 NSString * title;
 NSString * url;
 NSString * addtime;
 BOOL adshow;
 BOOL fabu;
 int * encoded;
 NSString * amd5;
 int sort;
 int ds;
 int timing;
 NSString * timingpublish;
 
 */
#import "AlbumObject.h"

@implementation AlbumObject

- (void)setAlbumObjectWithDictionary:(NSDictionary *)dictionary {
    
    self.Id = [NSString stringWithFormat: @"%@", [dictionary objectForKey:@"id"]].intValue;
    self.title = [dictionary objectForKey:@"title"];
    self.url = [dictionary objectForKey:@"url"];
    self.addtime = [dictionary objectForKey:@"addtime"];
    self.adshow = [dictionary objectForKey:@"adshow"];
    self.fabu = [dictionary objectForKey:@"fabu"];
    self.encoded = [NSString stringWithFormat: @"%@", [dictionary objectForKey:@"encoded"]].intValue;
    self.amd5 = [dictionary objectForKey:@"amd5"];
    self.sort = [NSString stringWithFormat: @"%@", [dictionary objectForKey:@"sort"]].intValue;
    self.ds = [NSString stringWithFormat: @"%@", [dictionary objectForKey:@"ds"]].intValue;
    self.timing = [NSString stringWithFormat: @"%@", [dictionary objectForKey:@"timing"]].intValue;
    self.timingpublish = [dictionary objectForKey:@"timingpublish"];
}

@end
