//
//  PhotoObject.m
//  A National Geographic Client
//
//  Created by Sodapig on 2016/9/13.
//  Copyright © 2016年 Taozhu Ye. All rights reserved.
//

/*
 
 {
 "id":"11498",
 "albumid":"1341",
 "title":"形单影只",
 "content":"我当时正赶着在日出前从位在杜拜城内的旅馆，前往玛格罕沙漠中拍摄罕见的阿拉伯大羚羊。我从低处往上拍，将这只生物和美丽天色用相机捕捉下来。",
 "url":"http://pic01.bdatu.com/Upload/picimg/1473074819.jpg",
 "size":"107573",
 "addtime":"2016-09-05 19:27:22",
 "author":"Ali Faisal Al-Houti",
 "thumb":"http://pic01.bdatu.com/Upload/picimg/1473074819.jpg",
 "encoded":"1",
 "weburl":"http://",
 "type":"pic",
 "yourshotlink":"http://yourshot.nationalgeographic.com/photos/8849172/",
 "copyright":"",
 "pmd5":"9d159945cd928c5f09fd49799763e9dc",
 "sort":"11498"
 }
 
 int Id;
 int albumid;
 NSString * title;
 NSString * content;
 NSString * url;
 NSIntger size;
 NSString * addtime;
 NSString * author;
 NSString * thumb;
 int encoded;
 NSString * weburl;
 NSString * type;
 NSString * yourshotlink;
 NSString * copyright;
 NSString * pmd5;
 int sort;
 
 */

#import "PhotoObject.h"

@implementation PhotoObject

- (void)setPhotoObjectWithDictionary:(NSDictionary *)dictionary {
    
    _Id = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"id"]].intValue;
    _albumid = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"albumid"]].intValue;
    _title = [dictionary objectForKey:@"title"];
    _content = [dictionary objectForKey:@"content"];
    _url = [dictionary objectForKey:@"url"];
    _size = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"size"]].integerValue;
    _addtime = [dictionary objectForKey:@"addtime"];
    _author = [dictionary objectForKey:@"author"];
    _thumb = [dictionary objectForKey:@"thumb"];
    _encoded = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"encoded"]].intValue;
    _weburl = [dictionary objectForKey:@"weburl"];
    _type = [dictionary objectForKey:@"type"];
    _yourshotlink = [dictionary objectForKey:@"yourshotlink"];
    _copyright = [dictionary objectForKey:@"copyright"];
    _pmd5 = [dictionary objectForKey:@"pmd5"];
    _sort = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"sort"]].intValue;
}

@end
