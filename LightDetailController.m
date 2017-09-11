//
//  LightDetailController.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/9.
//  Copyright © 2017年 street. All rights reserved.
//

#import "LightDetailController.h"


@interface LightDetailController()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)WKWebView *webView;

@end

@implementation LightDetailController
-(void)viewDidLoad
{
    
    
    UIBarButtonItem *leftButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"houtui"] style:UIBarButtonItemStylePlain target:self action:@selector(leftView)];
    [leftButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    
    self.navigationItem.title=@"路灯详情";
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    //加载webview
    [self initWebView];
    
}

//返回
-(void) leftView
{
    [self.navigationController popViewControllerAnimated:YES];
}
//加载web视图
-(void)initWebView
{

    self.webView=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight- 64) ];
    self.webView.navigationDelegate=self;
    self.webView.UIDelegate=self;
    [self.view addSubview:self.webView];
    
    //配置参数
    if (self.lightResult!=nil) {
        NSString *lampcode=[self.lightResult valueForKey:@"lampcode"];
        NSString *urlString=[NSString stringWithFormat:@"%@%@?lampcode=%@",[HttpTool sharedInstance].pingtaiUrl,lampDetail,lampcode];
        NSURL *url=[NSURL URLWithString:urlString];
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    
   
}

#pragma mark webview协议
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
    NSLog(@"正在加载");

}

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
NSLog(@"内容开始返回");
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"返回成功");
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"返回失败");
}

-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
NSLog(@"didReceiveServerRedirectForProvisionalNavigation");
}
@end
