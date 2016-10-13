//
//  ViewController.m
//  WuCNetwork
//
//  Created by allthings_LuYD on 2016/10/13.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import "ViewController.h"
#import "WuCNetworkManager.h"
#define inkeMainData @"http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=5&multiaddr=1"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*How to user this function：example
       The function RequestType and Parameters is not required
     */
#warning note
    /*
     Request failed: unacceptable content-type: text/plain
     The content-type of this url as inkeMainData is text/plain
     And AFNetworking is not acceptable content-type:text/plain
     */
    /*
     How to deal with
     add code ：session.responseserializer = [[AFCompoundResponsezer allco]init]   and that will return Data type data
     */
    [[WuCNetworkManager manager].setRequest(inkeMainData).RequestType(GET).Parameters(nil) startRequestWithSuccess:^(id response) {
        //we  need to convert the data into text
        NSLog(@"%@",response);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}


@end
