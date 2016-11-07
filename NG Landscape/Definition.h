//
//  Definition.h
//  NG Landscape
//
//  Created by Sodapig on 2016/10/15.
//  Copyright © 2016年 Taozhu Ye. All rights reserved.
//

#ifndef Definition_h
#define Definition_h

#define MAIN_QUEUE dispatch_get_main_queue()
#define DEFAULT_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define GET_ALBUMS_URL @"http://dili.bdatu.com/jiekou/mains/p%d.html"
#define GET_PHOTOS_URL @"http://dili.bdatu.com/jiekou/albums/a%d.html"

#endif /* Definition_h */
