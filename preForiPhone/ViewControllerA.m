//
//  ViewControllerA.m
//  preForiPhone
//
//  Created by 李阿龙 on 2020/10/26.
//

#import "ViewControllerA.h"
#import "ViewController.h"

@interface ViewControllerA ()<UIWebViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *mutableDic;

@end

@implementation ViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray* cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
    
    NSLog(@"cookie dictionary found is %@",cookieDictionary);
    
    if (cookieDictionary) {
        for (NSInteger i = 0; i < cookieDictionary.count; i++) {
            
            NSLog(@"cookie found is %@",[cookieDictionary objectAtIndex:i]);
            
            NSDictionary *cookieDic = [cookieDictionary objectAtIndex:i];
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDic];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    //设置请求之前加载 cookie 确保 cookie 在请求头之前设置
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.apple.com.cn/"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];

        //加载网页
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    webView.frame = CGRectMake(0, 64, 375, 667-64);
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    [self setUp12Button];
    
}

- (void)setUp12Button {
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"Jump" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    btn.frame = CGRectMake(0, 0, 375, 64);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(push) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)push {
    ViewController *vc = [[ViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

//加载成功
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *requestUrl = webView.request.URL.absoluteString;
    NSLog(@" requestUrl: %@",requestUrl);
    
    //设置原始 cookie 根据key 存储本地
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    
    //网页加载完成取出 cookies
    NSArray *nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSHTTPCookie *cookie;
    for (id c in nCookies) {
        if ([c isKindOfClass:[NSHTTPCookie class]]) {
            cookie=(NSHTTPCookie *)c;
            //我这里是cookie存入字典中 去重
            if ([cookie value]) {
                //如果 vaule 值不为 nil 存入字典中,
                [self.mutableDic setValue:[cookie value] forKey:[cookie name]];
            }
            //设置原始 cookie
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
            [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
            [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
            [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
            [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
            [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
            [cookieArray addObject:cookieProperties];
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    //cookie 存入本地
    [[NSUserDefaults standardUserDefaults] setObject:cookieArray forKey:@"cookieArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    //下面 cookie 去重是为了得到 key=Value;形式的字符串，这里由于我有需求这样做，实际中下面可以忽略
//    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
//    // cookie重复，先放到字典进行去重，再进行拼接
//    for (NSString *key in self.mutableDic) {
//        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [self.mutableDic valueForKey:key]];
//        [cookieValue appendString:appendString];
//    }
//    NSLog(@"########################     %@        ####################",cookieValue);
}

@end
