//
//  PhotoObject.h
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
 
 */

#import <Foundation/Foundation.h>

@interface PhotoObject : NSObject

@property (assign, nonatomic) int Id;
@property (assign, nonatomic) int albumid;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * content;
@property (strong, nonatomic) NSString * url;
@property (assign, nonatomic) NSInteger size;
@property (strong, nonatomic) NSString * addtime;
@property (strong, nonatomic) NSString * author;
@property (strong, nonatomic) NSString * thumb;
@property (assign, nonatomic) int encoded;
@property (strong, nonatomic) NSString * weburl;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * yourshotlink;
@property (strong, nonatomic) NSString * copyright;
@property (strong, nonatomic) NSString * pmd5;
@property (assign, nonatomic) int sort;

- (void)setPhotoObjectWithDictionary:(NSDictionary *)dictionary;

@end

/*
 {
 "counttotal":"12",
 "picture":
 [
 {
 "id":"11498","albumid":"1341","title":"形单影只","content":"我当时正赶着在日出前从位在杜拜城内的旅馆，前往玛格罕沙漠中拍摄罕见的阿拉伯大羚羊。我从低处往上拍，将这只生物和美丽天色用相机捕捉下来。","url":"http://pic01.bdatu.com/Upload/picimg/1473074819.jpg","size":"107573","addtime":"2016-09-05 19:27:22","author":"Ali Faisal Al-Houti","thumb":"http://pic01.bdatu.com/Upload/picimg/1473074819.jpg","encoded":"1","weburl":"http://","type":"pic","yourshotlink":"http://yourshot.nationalgeographic.com/photos/8849172/","copyright":"","pmd5":"9d159945cd928c5f09fd49799763e9dc","sort":"11498"
 },
 {
 "id":"11497","albumid":"1341","title":"东山再起","content":"纽约曼哈顿下城的世界贸易中心一号大楼已竣工。","url":"http://pic01.bdatu.com/Upload/picimg/1473074644.jpg","size":"60984","addtime":"2016-09-05 19:24:26","author":"Katia Lima","thumb":"http://pic01.bdatu.com/Upload/picimg/1473074644.jpg","encoded":"1","weburl":"http://","type":"pic","yourshotlink":"http://yourshot.nationalgeographic.com/photos/8850583/","copyright":"","pmd5":"150f2c14eb839e77cb29fc0462154801","sort":"11497"
 },
 {
 "id":"11496","albumid":"1341","title":"谋生工具","content":"渔民在搬运帆船。","url":"http://pic01.bdatu.com/Upload/picimg/1473074613.jpg","size":"233225","addtime":"2016-09-05 19:23:58","author":"Nguyễn Hữu Đính","thumb":"http://pic01.bdatu.com/Upload/picimg/1473074613.jpg","encoded":"1","weburl":"http://","type":"pic","yourshotlink":"http://yourshot.nationalgeographic.com/photos/8850146/","copyright":"","pmd5":"413fc290dcb94d74f7930c100ea00484","sort":"11496"
 },
 {
 "id":"11495","albumid":"1341","title":"一体两面","content":"用105毫米的微距镜头拍下池中倒影，关键是让它维持不动的姿势够久。 ","url":"http://pic01.bdatu.com/Upload/picimg/1473074587.jpg","size":"130173","addtime":"2016-09-05 19:23:31","author":"Gary Davis","thumb":"http://pic01.bdatu.com/Upload/picimg/1473074587.jpg","encoded":"1","weburl":"http://","type":"pic","yourshotlink":"http://yourshot.nationalgeographic.com/photos/8847824/","copyright":"","pmd5":"f43276baf9ecd2ad394a6c05f9aaf011","sort":"11495"
 },
 {
 "id":"11494","albumid":"1341","title":"悲欢之隔","content":"波托街景。","url":"http://pic01.bdatu.com/Upload/picimg/1473074562.jpg","size":"194557","addtime":"2016-09-05 19:23:07","author":"Oscar AF","thumb":"http://pic01.bdatu.com/Upload/picimg/1473074562.jpg","encoded":"1","weburl":"http://","type":"pic","yourshotlink":"http://yourshot.nationalgeographic.com/photos/8846197/","copyright":"","pmd5":"4ceedecf7852a1cc22bec25a7c172700","sort":"11494"
 },
 {
 "id":"11493","albumid":"1341","title":"屹立不摇","content":"风雪中的北美野牛。","url":"http://pic01.bdatu.com/Upload/picimg/1473074538.jpg","size":"202949","addtime":"2016-09-05 19:22:43","author":"Wendy Von Courter","thumb":"http://pic01.bdatu.com/Upload/picimg/1473074538.jpg","encoded":"1","weburl":"http://","type":"pic","yourshotlink":"http://yourshot.nationalgeographic.com/photos/8845882/","copyright":"","pmd5":"8be63359deadc1d934d9e2b0ebf67563","sort":"11493"
 },
 {
 "id":"11492","albumid":"1341","title":"奥林巴斯","content":"摄于希腊多德喀尼群岛的卡尔帕索斯岛上的奥林巴斯。这天是2016年8月11日，订婚日。奥林巴斯是世上少数还能体验到拜占庭帝国生活方式的地方之一。在卡尔帕索斯岛的这一区，仍保留着习俗。这里的居民与世隔绝，你得开过26公里的泥路才到得了，柏油路则四年前才铺好。","url":"http://pic01.bdatu.com/Upload/picimg/1473074513.jpg","size":"201711","addtime":"2016-09-05 19:22:18","author":"Georgios Tatakis","thumb":"http://pic01.bdatu.com/Upload/picimg/1473074513.jpg","encoded":"1","weburl":"http://","type":"pic","yourshotlink":"http://yourshot.nationalgeographic.com/photos/8847151/","copyright":"","pmd5":"e4c009135976f371b60bdcfdbda2a84d","sort":"11492"
 },
 {
 "id":"11491","albumid":"1341","title":"保持警戒","content":"这只猎豹在休息时突然听到了某些动静，这个姿势代表它随时准备好奔逃。","url":"http://pic01.bdatu.com/Upload/picimg/1473074478.jpg","size":"186100","addtime":"2016-09-05 19:21:43","author":"Julia Wimmerlin","thumb":"http://pic01.bdatu.com/Upload/picimg/1473074478.jpg","encoded":"1","weburl":"http://","type":"pic","yourshotlink":"http://yourshot.nationalgeographic.com/photos/8848740/","copyright":"","pmd5":"9c0458b690d312b81abb4369b65fd441","sort":"11491"
 },
 {
 "id":"11490","albumid":"1341","title":"无边大地","content":"摄于捷克共和国的南摩拉维亚的早春。","url":"http://pic01.bdatu.com/Upload/picimg/1473074452.jpg","size":"230971","addtime":"2016-09-05 19:21:18","author":"Tomasz Rojek","thumb":"http://pic01.bdatu.com/Upload/picimg/1473074452.jpg","encoded":"1","weburl":"http://","type":"pic","yourshotlink":"http://yourshot.nationalgeographic.com/photos/8847861/","copyright":"","pmd5":"ab49cfe0ddccfee9fad47859df4cab18","sort":"11490"
 },
 {
 "id":"11489","albumid":"1341","title":"快乐为主","content":"躺在肥沃土地上的男孩。","url":"http://pic01.bdatu.com/Upload/picimg/1473074427.jpg","size":"193824","addtime":"2016-09-05 19:20:52","author":"Nádia Maria","thumb":"http://pic01.bdatu.com/Upload/picimg/1473074427.jpg","encoded":"1","weburl":"http://","type":"pic","yourshotlink":"http://yourshot.nationalgeographic.com/photos/8847786/","copyright":"","pmd5":"e522c83c10a1e1ec34ac677d38901401","sort":"11489"
 },
 {
 "id":"11488","albumid":"1341","title":"公园一隅","content":"2016年8月摄于别布札国家公园。","url":"http://pic01.bdatu.com/Upload/picimg/1473074396.jpg","size":"72276","addtime":"2016-09-05 19:20:19","author":"II Fafao","thumb":"http://pic01.bdatu.com/Upload/picimg/1473074396.jpg","encoded":"1","weburl":"http://","type":"pic","yourshotlink":"http://yourshot.nationalgeographic.com/photos/8847538/","copyright":"","pmd5":"df7083f983e7471aeb06ef48d7c63823","sort":"11488"
 },
 {
 "id":"11487","albumid":"1341","title":"成双成对","content":"从海面往下俯瞰魔鬼鱼绕着波米灯塔游翔，很难知道它们到底有多大。潜到水下10公尺已是我的身体和相机能承受的极限，但这些魔鬼鱼却仍在数公尺之外，于是我开始推测他们的实际大小。一只发育完全的鬼蝠魟的宽度可达7公尺。","url":"http://pic01.bdatu.com/Upload/picimg/1473074366.jpg","size":"183514","addtime":"2016-09-05 19:19:51","author":"James Vodicka","thumb":"http://pic01.bdatu.com/Upload/picimg/1473074366.jpg","encoded":"1","weburl":"http://","type":"pic","yourshotlink":"http://yourshot.nationalgeographic.com/photos/8850207/","copyright":"","pmd5":"4dfa163e21b6d72859f0212a4c4278f2","sort":"11487"
 }
 ]
 }
*/
