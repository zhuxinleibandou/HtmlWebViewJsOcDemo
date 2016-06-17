//
//  ViewController.m
//  HtmlWebViewJsOcDemo
//
//  Created by 朱信磊 on 16/6/16.
//  Copyright © 2016年 朱信磊. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *str_url = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"demo.html"];
    [self.myweb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str_url]]];
    [self.myweb setDelegate:self];
    
    
    JSContext *context = [self.myweb valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //定义好JS要调用的方法, share就是调用的share方法名   第二种 方式
    context[@"share"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        //传递过来的参数
        NSArray *args = [JSContext currentArguments];
        
//        [self showText];
        [self showTextTwo];
        
        
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal.toString);
        }
        
        NSLog(@"-------End Log-------");
    };
    
    context[@"showalert"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        //传递过来的参数
        [[[UIAlertView alloc]initWithTitle:@"呵呵" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  使用 stringByEvaluatingJavaScriptFromString 方法 运行 js代码
 */
-(void)showText{
    //NSString *str = [self.webview stringByEvaluatingJavaScriptFromString:@"postStr();"];
    //要传递的参数一
    NSString *str1 = @"我来自于oc";
    //要传递的参数二
    NSString *str2 = @"我来自于地球";
    NSString *str = [self.myweb stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"postStr('%@','%@');",str1,str2]];
    NSLog(@"JS返回值：%@",str);
}

/**
 *  使用js.framework 实现调用 html方法
 */
-(void)showTextTwo{
    //要传递的参数一
    NSString *str1 = @"我来自于oc";
    //要传递的参数二
    NSString *str2 = @"我来自于地球";
    JSContext *context = [self.myweb valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *textJS = @"showAlert('这里是JS中alert弹出的message')";
    NSString *textJS  = [NSString stringWithFormat:@"postStr('%@','%@');",str1,str2];
    [context evaluateScript:textJS];
}



- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    //第一种方式
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString=%@",urlString);
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    NSArray *urlCompsTwo = [[urlComps objectAtIndex:1] componentsSeparatedByString:@"/"];
    if([urlCompsTwo count] && [[urlCompsTwo objectAtIndex:1] isEqualToString:@"getInfo"])
    {
         [self showText];
        
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@":/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if (1 == [arrFucnameAndParameter count])
        {
            // 没有参数
            if([funcStr isEqualToString:@"doFunc1"])
            {
                
                /*调用本地函数1*/
                NSLog(@"doFunc1");
               
                
            }
        }
        else
        {
            //有参数的
            if([funcStr isEqualToString:@"getParam1:withParam2:"])
            {
//                [self getParam1:[arrFucnameAndParameter objectAtIndex:1] withParam2:[arrFucnameAndParameter objectAtIndex:2]];
            }
        }
        return NO;
    }
    return TRUE;
}
@end
