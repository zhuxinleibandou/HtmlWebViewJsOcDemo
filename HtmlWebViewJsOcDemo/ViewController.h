//
//  ViewController.h
//  HtmlWebViewJsOcDemo
//
//  Created by 朱信磊 on 16/6/16.
//  Copyright © 2016年 朱信磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myweb;



-(void)showText;
@end

