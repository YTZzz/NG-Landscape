//
//  AlbumObject.h
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

*/


#import <Foundation/Foundation.h>

@interface AlbumObject : NSObject

@property (assign, nonatomic) int Id;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * url;
@property (strong, nonatomic) NSString * addtime;
@property (assign, nonatomic) NSString * adshow;
@property (assign, nonatomic) NSString * fabu;
@property (assign, nonatomic) int encoded;
@property (strong, nonatomic) NSString * amd5;
@property (assign, nonatomic) int sort;
@property (assign, nonatomic) int ds;
@property (assign, nonatomic) int timing;
@property (strong, nonatomic) NSString * timingpublish;

- (void)setAlbumObjectWithDictionary:(NSDictionary *)dictionary;

@end

/*
 
 {
 "total":"811",
 "page":"1",
 "pagecount":"15",
 "album":[
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
 },
 {"id":"1340","title":"2016-09-10每日精选","url":"http://pic01.bdatu.com/Upload/appsimg/1473073446.jpg","addtime":"2016-09-10 00:04:36","adshow":"NO","fabu":"YES","encoded":"1","amd5":"52dfdd0659205ae47032ea1a9d0f64cd","sort":"1526","ds":"1","timing":"1","timingpublish":"2016-09-10 00:00:00"
 },
 {"id":"1339","title":"2016-09-09每日精选","url":"http://pic01.bdatu.com/Upload/appsimg/1473064842.jpg","addtime":"2016-09-09 00:04:09","adshow":"NO","fabu":"YES","encoded":"1","amd5":"020dec4d9cf2ec7d6d52c3dceb3bcfbf","sort":"1525","ds":"1","timing":"1","timingpublish":"2016-09-09 00:00:00"
 },
 {"id":"1338","title":"2016-09-08 珍惜食物","url":"http://pic01.bdatu.com/Upload/appsimg/1473130923.jpg","addtime":"2016-09-08 00:04:07","adshow":"NO","fabu":"YES","encoded":"1","amd5":"341ba541024f675dd8a87c8b80c94ae6","sort":"1524","ds":"1","timing":"1","timingpublish":"2016-09-08 00:00:00"
 },
 {"id":"1337","title":"2016-09-07每日精选","url":"http://pic01.bdatu.com/Upload/appsimg/1472458852.jpg","addtime":"2016-09-07 00:04:23","adshow":"NO","fabu":"YES","encoded":"1","amd5":"a7e0199a98a5a8204d5f8bfa1d0b31a5","sort":"1523","ds":"1","timing":"1","timingpublish":"2016-09-07 00:00:00"
 },
 {"id":"1336","title":"2016-09-06每日精选","url":"http://pic01.bdatu.com/Upload/appsimg/1472458404.jpg","addtime":"2016-09-06 00:04:03","adshow":"NO","fabu":"YES","encoded":"1","amd5":"6d810bf23d79c05757a754d7e9e2617a","sort":"1522","ds":"1","timing":"1","timingpublish":"2016-09-06 00:00:00"
 },
 {"id":"1335","title":"2016-09-05每日精选","url":"http://pic01.bdatu.com/Upload/appsimg/1472458163.jpg","addtime":"2016-09-05 00:04:01","adshow":"NO","fabu":"YES","encoded":"1","amd5":"9d9f0ddbe34bea4312737c58882932fc","sort":"1521","ds":"1","timing":"1","timingpublish":"2016-09-05 00:00:00"
 },
 {"id":"1334","title":"2016-09-04每日精选","url":"http://pic01.bdatu.com/Upload/appsimg/1472457901.jpg","addtime":"2016-09-04 00:04:07","adshow":"NO","fabu":"YES","encoded":"1","amd5":"9dccd0b592bfdaca8ce65aa9c47397d7","sort":"1520","ds":"1","timing":"1","timingpublish":"2016-09-04 00:00:00"
 },
 {"id":"1333","title":"2016-09-03每日精选","url":"http://pic01.bdatu.com/Upload/appsimg/1472457443.jpg","addtime":"2016-09-03 00:04:14","adshow":"NO","fabu":"YES","encoded":"1","amd5":"be38c32d4e6e54ff2219eca98a463677","sort":"1519","ds":"1","timing":"1","timingpublish":"2016-09-03 00:00:00"
 },
 {"id":"1332","title":"2016-09-02每日精选","url":"http://pic01.bdatu.com/Upload/appsimg/1472456825.jpg","addtime":"2016-09-02 00:04:39","adshow":"NO","fabu":"YES","encoded":"1","amd5":"b135ad884e497fc0d1172b70efe60fce","sort":"1518","ds":"1","timing":"1","timingpublish":"2016-09-02 00:00:00"
 },
 {"id":"1331","title":"2016-09-01〈影像方舟〉","url":"http://pic01.bdatu.com/Upload/appsimg/1471922642.jpg","addtime":"2016-09-01 00:04:09","adshow":"NO","fabu":"YES","encoded":"1","amd5":"76157b27951ec89c776cdcfa7fa962ad","sort":"1517","ds":"1","timing":"1","timingpublish":"2016-09-01 00:00:00"
 },
 {"id":"1330","title":"2016-08-31每日精选","url":"http://pic01.bdatu.com/Upload/appsimg/1471922366.jpg","addtime":"2016-08-31 00:04:07","adshow":"NO","fabu":"YES","encoded":"1","amd5":"fd5ae52590b62140723edd282e300f9f","sort":"1516","ds":"1","timing":"1","timingpublish":"2016-08-31 00:00:00"
 },
 {"id":"1329","title":"2016-08-30每日精选","url":"http://pic01.bdatu.com/Upload/appsimg/1471922083.jpg","addtime":"2016-08-30 00:04:23","adshow":"NO","fabu":"YES","encoded":"1","amd5":"6c629c2dc1211029b3ca2454fccfeb67","sort":"1515","ds":"1","timing":"1","timingpublish":"2016-08-30 00:00:00"
 },
 {"id":"1328","title":"2016-08-29每日精选","url":"http://pic01.bdatu.com/Upload/appsimg/1471921773.jpg","addtime":"2016-08-29 00:04:02","adshow":"NO","fabu":"YES","encoded":"1","amd5":"3f002458920232fae1566f3d957192be","sort":"1514","ds":"1","timing":"1","timingpublish":"2016-08-29 00:00:00"
 },
 {"id":"1327","title":"2016-08-28每日精选","url":"http://pic01.bdatu.com/Upload/appsimg/1471921302.jpg","addtime":"2016-08-28 00:04:51","adshow":"NO","fabu":"YES","encoded":"1","amd5":"38740a29de4c32dadde402598a117e1f","sort":"1513","ds":"1","timing":"1","timingpublish":"2016-08-28 00:00:00"
 }
 ]
 }
 
 */
