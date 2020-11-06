//
//  ViewController.m
//  preForiPhone
//
//  Created by 李阿龙 on 2020/10/26.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>
#import "AppleStoreModel.h"

#import <AudioToolbox/AudioToolbox.h>

typedef NS_ENUM(NSUInteger, PhoneType) {
    PhoneTypeTwelveMini,
    PhoneTypeTwelve,
    PhoneTypeTwelvePro,
    PhoneTypeTwelveProMax
};

// 12 mini
static NSString * twelveMiniStoreUrl = @"https://reserve-prime.apple.com/CN/zh_CN/reserve/H/stores.json";
// 12 mini
static NSString * twelveMiniAvailabilityUrl = @"https://reserve-prime.apple.com/CN/zh_CN/reserve/H/availability.json";

// 12
static NSString * twelveStoreUrl = @"https://reserve-prime.apple.com/CN/zh_CN/reserve/F/stores.json";
// 12
static NSString * twelveAvailabilityUrl = @"https://reserve-prime.apple.com/CN/zh_CN/reserve/F/availability.json";


// 12 pro
static NSString * twelveProStoreUrl = @"https://reserve-prime.apple.com/CN/zh_CN/reserve/A/stores.json";
// 12 pro
static NSString * twelveProAvailabilityUrl = @"https://reserve-prime.apple.com/CN/zh_CN/reserve/A/availability.json";

// 12 pro max
static NSString * twelveProMaxStoreUrl = @"https://reserve-prime.apple.com/CN/zh_CN/reserve/G/stores.json";
// 12 pro max
static NSString * twelveProMaxAvailabilityUrl = @"https://reserve-prime.apple.com/CN/zh_CN/reserve/G/availability.json";


@interface ViewController ()<UIWebViewDelegate>

@property(nonatomic, strong) NSArray *storeArr; // 商店信息

@property(nonatomic, strong) NSDictionary *twelveMiniColorDic; // 12 Mini 颜色字典
@property(nonatomic, strong) NSDictionary *twelveMiniCapacityDic; // 12 Mini 容量字典

@property(nonatomic, strong) NSDictionary *twelveColorDic; // 12颜色字典
@property(nonatomic, strong) NSDictionary *twelveCapacityDic; // 12容量字典

@property(nonatomic, strong) NSDictionary *twelveProColorDic; // 12 Pro 颜色字典
@property(nonatomic, strong) NSDictionary *twelveProCapacityDic; // 12 Pro 容量字典

@property(nonatomic, strong) NSDictionary *twelveProMaxColorDic; // 12 Pro Max 颜色字典
@property(nonatomic, strong) NSDictionary *twelveProMaxCapacityDic; // 12 Pro Max 容量字典

@property(nonatomic, assign) PhoneType requestType;

@property (nonatomic, strong) NSDictionary *responseObject;
@property (nonatomic, strong) NSString *requestUrl;

@property(nonatomic, strong) NSSet *wantCitySet;
@property(nonatomic, strong) NSSet *wantColorSet;
@property(nonatomic, strong) NSSet *wantCapacitySet;

@end


@implementation ViewController

- (void)setUp12Button {
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"查询12" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    btn.frame = CGRectMake(0, 100, 200, 100);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(request12) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)setUp12ProButton {
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"查询12 Pro" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    btn.frame = CGRectMake(0, 200, 200, 100);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(request12Pro) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)setUp12ProMaxButton {
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"查询12 ProMax" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    btn.frame = CGRectMake(0, 300, 200, 100);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(request12ProMax) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)setcreat12Button {
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"creat 12" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    btn.frame = CGRectMake(0, 500, 200, 100);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(orderCreat) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.wantCitySet = [NSSet setWithObjects:@"北京", @"上海", @"成都", @"重庆", @"杭州", @"宁波", @"天津", @"南京", nil];
    
    self.wantColorSet = [NSSet setWithObjects:@"海蓝色", @"石墨色", @"银色", @"金色", nil];
    
    self.wantCapacitySet = [NSSet setWithObjects:@"128GB", @"256GB", @"512GB", nil];
    
//    [self setUPUI];
    // Do any additional setup after loading the view.
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(request12ProMax) userInfo:nil repeats:YES];
    [timer fire];
    [self setUp12Button];
    [self setUp12ProButton];
    [self setUp12ProMaxButton];
    [self setcreat12Button];
}

#pragma mark - cookies


- (void)setUpCookies {
    // todo
}

//首次请求注入cookie

- (void)setCookies {
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"hostURL"] sessionConfiguration:sessionConfiguration];
    AFHTTPRequestSerializer *requestSerialization = [AFHTTPRequestSerializer serializer];
    requestSerialization.timeoutInterval = 15;

    // 设置自动管理Cookies
    requestSerialization.HTTPShouldHandleCookies = YES;

    // 如果已有Cookie, 则把你的cookie符上
    NSString *cookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"];
        if (cookie != nil) {
            [requestSerialization setValue:cookie forHTTPHeaderField:@"Set-Cookie"];
        }

    // 安全策略
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    
    [httpManager POST:@"url" parameters:nil headers:nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        //获取 Cookie
        NSHTTPURLResponse* response = (NSHTTPURLResponse* )task.response;
        NSDictionary *allHeaderFieldsDic = response.allHeaderFields;
        NSString *setCookie = allHeaderFieldsDic[@"Set-Cookie"];
        if (setCookie != nil) {
            NSString *cookie = [[setCookie componentsSeparatedByString:@";"] objectAtIndex:0];
            // 这里对cookie进行存储
            [[NSUserDefaults standardUserDefaults] setObject:cookie forKey:@"cookie"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark -

- (void)request12Mini{
    NSLog(@"查询 iPhone 12");
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  // 震动

    AudioServicesPlaySystemSound(1007); //这个声音是是类似于QQ声音的
    
    
    self.requestType = PhoneTypeTwelveMini;
    [self requestStoresInfo];
}

- (void)request12{
    NSLog(@"查询 iPhone 12");
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  // 震动

    AudioServicesPlaySystemSound(1007); //这个声音是是类似于QQ声音的
    
    
    self.requestType = PhoneTypeTwelve;
    [self requestStoresInfo];
}

- (void)request12Pro {
    NSLog(@"查询 iPhone 12 Pro");
    
    self.requestType = PhoneTypeTwelvePro;
    [self requestStoresInfo];
}

- (void)request12ProMax {
    NSLog(@"查询 iPhone 12 ProMax");
    
    self.requestType = PhoneTypeTwelveProMax;
    [self requestStoresInfo];
}

- (void)requestStoresInfo {
    if (self.storeArr.count > 0) {
        [self requestPhoneAvailability];
        return;;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *storesJsonUrl = nil;
    if (self.requestType == 0) {
        storesJsonUrl = twelveStoreUrl;
    } else {
        storesJsonUrl = twelveProStoreUrl;
    }
    
    switch (self.requestType) {
        case PhoneTypeTwelveMini:
            storesJsonUrl = twelveMiniStoreUrl;
            break;
        case PhoneTypeTwelve:
            storesJsonUrl = twelveStoreUrl;
            break;
        case PhoneTypeTwelvePro:
            storesJsonUrl = twelveProStoreUrl;
            break;
        case PhoneTypeTwelveProMax:
            storesJsonUrl = twelveProMaxStoreUrl;
            break;
        default:
            break;
    }
    
    [manager GET:storesJsonUrl parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        NSArray *storesArr = resultDic[@"stores"];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:storesArr.count];
        for (NSDictionary *dic in storesArr) {
            AppleStoreModel *model = [AppleStoreModel yy_modelWithDictionary:dic];
            [arr addObject:model];
        }
        self.storeArr = arr;
        [self requestPhoneAvailability];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)requestPhoneAvailability {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *availabilityUrl = nil;
    
    switch (self.requestType) {
        case PhoneTypeTwelveMini:
            availabilityUrl = twelveAvailabilityUrl;
            break;
        case PhoneTypeTwelve:
            availabilityUrl = twelveAvailabilityUrl;
            break;
        case PhoneTypeTwelvePro:
            availabilityUrl = twelveProAvailabilityUrl;
            break;
        case PhoneTypeTwelveProMax:
            availabilityUrl = twelveProMaxAvailabilityUrl;
            break;
        default:
            break;
    }
    
    [manager GET:availabilityUrl parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        NSDictionary *storesDic = resultDic[@"stores"];
        
        NSArray *allValues = [storesDic allValues];
        for (int i = 0; i < allValues.count; i++) {
            NSDictionary *dic = [allValues objectAtIndex:i];
            NSString *storeNumber = [[storesDic allKeys] objectAtIndex:i];
            [self handlerWithParams:dic withStoreNumber:storeNumber];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)handlerWithParams:(NSDictionary *)dic withStoreNumber:(NSString *)storeNumber {
    NSArray *allValues = [dic allValues];
    NSString *type = nil;
    
    switch (self.requestType) {
        case PhoneTypeTwelveMini:
            type = @"12 mini";
            break;
        case PhoneTypeTwelve:
            type = @"12";
            break;
        case PhoneTypeTwelvePro:
            type = @"12 Pro";
            break;
        case PhoneTypeTwelveProMax:
            type = @"12 Pro Max";
            break;
        default:
            type = @"12 Pro Max";
            break;
    }
    
    
    for (int i = 0; i < allValues.count; i++) {
        NSDictionary *resultDic = [allValues objectAtIndex:i];
        
        NSDictionary *availabilityDic = resultDic[@"availability"];
        
        BOOL unlocked_flag = [availabilityDic[@"unlocked"] boolValue];
        BOOL contract_flag = [availabilityDic[@"contract"] boolValue];
        NSString *key = [[dic allKeys] objectAtIndex:i];
        
        NSString *color = nil;
        NSString *capacity = nil;
        
        switch (self.requestType) {
            case PhoneTypeTwelveMini:
                color = self.twelveMiniColorDic[key];
                capacity = self.twelveMiniCapacityDic[key];
                break;
            case PhoneTypeTwelve:
                color = self.twelveColorDic[key];
                capacity = self.twelveCapacityDic[key];
                break;
            case PhoneTypeTwelvePro:
                color = self.twelveProColorDic[key];
                capacity = self.twelveProCapacityDic[key];
                break;
            case PhoneTypeTwelveProMax:
                color = self.twelveProMaxColorDic[key];
                capacity = self.twelveProMaxCapacityDic[key];
                break;
            default:
                color = self.twelveColorDic[key];
                capacity = self.twelveCapacityDic[key];
                break;
        }
        
        if (unlocked_flag && contract_flag) { // 两者均为 ture 表示有货
            
            for (AppleStoreModel *model in self.storeArr) {
                if ([model.storeNumber isEqualToString:storeNumber]) {
                    BOOL condition1 = [self.wantCitySet containsObject:model.city];
                    BOOL condition2 = [self.wantColorSet containsObject:color];
                    BOOL condition3 = [self.wantCapacitySet containsObject:capacity];
                    if (condition1 &&
                        condition2 &&
                        condition3) {
                        // 震动提醒
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        //这个声音是是类似于微信消息声音
                        AudioServicesPlaySystemSound(1007);
                        // 江浙沪有货时，进行对应提醒 此处后续可以优化为传参数集合，使用者可以自定义想要关注的地区
                        // 打印当前时间，便于后续优化日志统计
                        NSDate *nowDate = [NSDate date];
                        NSString *logStr = [NSString stringWithFormat:@"❤️❤️❤️🚀🚀🚀 time->%@ 好消息 : %@, %@, 有 %@ %@ iPhone %@ 手机", nowDate , model.city, model.storeName, color, capacity, type];
                        NSLog(@"%@", logStr);
                        // todo 后续优化时可以考虑将数据存储起来，便于每天统计每个地区的发货数量
                        NSString *urlStr = [NSString stringWithFormat:@"https://reserve-prime.apple.com/CN/zh_CN/reserve/A?color=%@&capacity=%@&quantity=2&anchor-store=%@&store=%@&partNumber=%@&channel=&sourceID=&iUID=&iuToken=&iUP=N&appleCare=&rv=&path=&plan=unlocked",color, capacity, model.storeNumber, model.storeNumber, key];
                        NSString *encodeUrl = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                        NSLog(@"❤️❤️❤️🚀🚀🚀 encodeUrl -> %@", encodeUrl);
                        // 将 URL 快速复制到剪切板，便于直接复制到浏览器地址栏
                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                        pasteboard.URL = [NSURL URLWithString:encodeUrl];
                        
                    } else {
                        NSLog(@"🚀🚀🚀 好消息 : %@, %@, 有 %@ %@ iPhone %@ 手机", model.city, model.storeName, color, capacity, type);
                        
                        NSString *urlStr = [NSString stringWithFormat:@"https://reserve-prime.apple.com/CN/zh_CN/reserve/A?color=%@&capacity=%@&quantity=2&anchor-store=%@&store=%@&partNumber=%@&channel=&sourceID=&iUID=&iuToken=&iUP=N&appleCare=&rv=&path=&plan=unlocked",color, capacity, model.storeNumber, model.storeNumber, key];
                        NSString *encodeUrl = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                        NSLog(@"🚀🚀🚀 encodeUrl -> %@", encodeUrl);
//                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//                        pasteboard.URL = [NSURL URLWithString:encodeUrl];
                    }
                }
            }
            
        } else {
            for (AppleStoreModel *model in self.storeArr) {
                if ([model.storeNumber isEqualToString:storeNumber]) {
                    NSLog(@"😭😭😭 坏消息 ：好遗憾，%@ %@ 没找到与 %@ %@ iPhone %@ 相关匹配信息", model.city, model.storeName, color, capacity, type);
                }
            }
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestUrl = webView.request.URL.absoluteString;
    NSLog(@" requestUrl: %@",requestUrl);
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"error -> %@",error);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *requestUrl = webView.request.URL.absoluteString;
    NSLog(@" requestUrl: %@",requestUrl);
    self.requestUrl = requestUrl;
    NSString *jsonUrl = [requestUrl stringByAppendingString:@"&ajaxSource=true&_eventId=context"];
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager GET:jsonUrl parameters:nil headers:nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject -> %@", responseObject);
        self.responseObject = responseObject;
        [self postReq];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error -> %@", error);
    }];
}

- (void)postReq {
    NSString *url = self.requestUrl;
    
    NSDictionary *dic = @{
        @"phoneCountryCode" : self.responseObject[@"phoneCountryCode"],
        @"phoneNumber" : @"19957894739",
        @"registrationCode" : @"123456",
        @"_eventId" : @"next",
        @"_flowExecutionKey" : self.responseObject[@"_flowExecutionKey"],
        @"p_ie" : self.responseObject[@"_flowExecutionKey"],
        @"hc" : @"4981123",
        @"miscHc" : @"a=4978746,b=28559,c=12,d=100"
    };
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [httpManager GET:url parameters:dic headers:nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"😁responseObject --> %@", responseObject);
//        self.responseObject = responseObject;
//        [self postReq];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error -> %@", error);
    }];
    
}

- (void)orderCreat {
//    NSString *creaturl = @"https://reserve-prime.apple.com/CN/zh_CN/reserve/F";
    
    NSString *url = @"https://reserve-prime.apple.com/CN/zh_CN/reserve/F?color=%E8%93%9D%E8%89%B2&capacity=128GB&quantity=1&anchor-store=R532&store=R532&partNumber=MGGX3CH%2FA&channel=&sourceID=&iUID=&iuToken=&iUP=N&appleCare=&rv=&path=&plan=unlocked";
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    webView.frame = CGRectMake(0, 0, 375, 200);
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.view addSubview:webView];
    
//    NSDictionary *dic = @{
//        @"color" : @"  蓝色",
//        @"capacity" : @"  64GB",
//        @"quantity" : @"    1",
//        @"anchor-store " : @"   R471",
//        @"store  " : @"  R471",
//        @"partNumber  " : @" MGGQ3CH/A",
//        @"channel" : @"",
//        @"sourceID" : @"",
//        @"iUID" : @"",
//        @"iuToken" : @"",
//        @"iUP  " : @"N",
//        @"appleCare" : @"",
//        @"rv" : @"",
//        @"path" : @"",
//        @"plan  " : @"unlocked"
//    };
    
    NSString *jsonUrl = @"https://reserve-prime.apple.com/CN/zh_CN/reserve/F?execution=e2s1&ajaxSource=true&_eventId=context";
    
//    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:jsonUrl] sessionConfiguration:sessionConfiguration];
//    AFHTTPRequestSerializer *requestSerialization = [AFHTTPRequestSerializer serializer];
//    requestSerialization.timeoutInterval = 15;

    // 设置自动管理Cookies
//    requestSerialization.HTTPShouldHandleCookies = YES;

    // 如果已有Cookie, 则把你的cookie符上
//    NSString *cookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"];
//        if (cookie != nil) {
//            [requestSerialization setValue:cookie forHTTPHeaderField:@"Set-Cookie"];
//        }

    
//    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 安全策略
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    securityPolicy.allowInvalidCertificates = YES;
//    securityPolicy.validatesDomainName = NO;
//    [httpManager GET:jsonUrl parameters:nil headers:nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"responseObject -> %@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error -> %@", error);
//    }];
}

- (NSDictionary *)twelveMiniColorDic {
    if (!_twelveMiniColorDic) {
        _twelveMiniColorDic = @{
            @"MG803CH/A" : @"白色",
            @"MG853CH/A" : @"白色",
            @"MG8A3CH/A" : @"白色",
            
            @"MG7Y3CH/A" : @"黑色",
            @"MG843CH/A" : @"黑色",
            @"MG893CH/A" : @"黑色",
            
            @"MG823CH/A" : @"蓝色",
            @"MG873CH/A" : @"蓝色",
            @"MG8D3CH/A" : @"蓝色",
            
            @"MG833CH/A" : @"绿色",
            @"MG883CH/A" : @"绿色",
            @"MG8E3CH/A" : @"绿色",
            
            @"MG813CH/A" : @"红色",
            @"MG863CH/A" : @"红色",
            @"MG8C3CH/A" : @"红色",
        };
    }
    return _twelveMiniColorDic;
}

- (NSDictionary *)twelveMiniCapacityDic {
    if (!_twelveMiniCapacityDic) {
        _twelveMiniCapacityDic = @{
            @"MG803CH/A" : @"64GB",
            @"MG853CH/A" : @"128GB",
            @"MG8A3CH/A" : @"256GB",
            
            @"MG7Y3CH/A" : @"64GB",
            @"MG843CH/A" : @"128GB",
            @"MG893CH/A" : @"256GB",
            
            @"MG823CH/A" : @"64GB",
            @"MG873CH/A" : @"128GB",
            @"MG8D3CH/A" : @"256GB",
            
            @"MG833CH/A" : @"64GB",
            @"MG883CH/A" : @"128GB",
            @"MG8E3CH/A" : @"256GB",
            
            @"MG813CH/A" : @"64GB",
            @"MG863CH/A" : @"128GB",
            @"MG8C3CH/A" : @"256GB",
        };
    }
    return _twelveMiniCapacityDic;
}

- (NSDictionary *)twelveColorDic {
    if (!_twelveColorDic) {
        _twelveColorDic = @{
            @"MGGN3CH/A" : @"白色",
            @"MGGV3CH/A" : @"白色",
            @"MGH23CH/A" : @"白色",
            
            @"MGGM3CH/A" : @"黑色",
            @"MGGU3CH/A" : @"黑色",
            @"MGH13CH/A" : @"黑色",
            
            @"MGGQ3CH/A" : @"蓝色",
            @"MGGX3CH/A" : @"蓝色",
            @"MGH43CH/A" : @"蓝色",
            
            @"MGGT3CH/A" : @"绿色",
            @"MGGY3CH/A" : @"绿色",
            @"MGH53CH/A" : @"绿色",
            
            @"MGGP3CH/A" : @"红色",
            @"MGGW3CH/A" : @"红色",
            @"MGH33CH/A" : @"红色",
        };
    }
    return _twelveColorDic;
}

- (NSDictionary *)twelveCapacityDic {
    if (!_twelveCapacityDic) {
        _twelveCapacityDic = @{
            @"MGGN3CH/A" : @"64GB",
            @"MGGV3CH/A" : @"128GB",
            @"MGH23CH/A" : @"256GB",
            
            @"MGGM3CH/A" : @"64GB",
            @"MGGU3CH/A" : @"128GB",
            @"MGH13CH/A" : @"256GB",
            
            @"MGGQ3CH/A" : @"64GB",
            @"MGGX3CH/A" : @"128GB",
            @"MGH43CH/A" : @"256GB",
            
            @"MGGT3CH/A" : @"64GB",
            @"MGGY3CH/A" : @"128GB",
            @"MGH53CH/A" : @"256GB",
            
            @"MGGP3CH/A" : @"64GB",
            @"MGGW3CH/A" : @"128GB",
            @"MGH33CH/A" : @"256GB",
        };
    }
    return _twelveCapacityDic;
}

- (NSDictionary *)twelveProColorDic {
    if (!_twelveProColorDic) {
        _twelveProColorDic = @{
            @"MGLD3CH/A" : @"海蓝色",
            @"MGLH3CH/A" : @"海蓝色",
            @"MGLM3CH/A" : @"海蓝色",
            
            @"MGL93CH/A" : @"石墨色",
            @"MGLE3CH/A" : @"石墨色",
            @"MGLJ3CH/A" : @"石墨色",
            
            @"MGLA3CH/A" : @"银色",
            @"MGLF3CH/A" : @"银色",
            @"MGLK3CH/A" : @"银色",
            
            @"MGLC3CH/A" : @"金色",
            @"MGLG3CH/A" : @"金色",
            @"MGLL3CH/A" : @"金色",
        };
    }
    return _twelveProColorDic;
}

- (NSDictionary *)twelveProCapacityDic {
    if (!_twelveProCapacityDic) {
        _twelveProCapacityDic = @{
            @"MGLD3CH/A" : @"128GB",
            @"MGLH3CH/A" : @"256GB",
            @"MGLM3CH/A" : @"512GB",
            
            @"MGL93CH/A" : @"128GB",
            @"MGLE3CH/A" : @"256GB",
            @"MGLJ3CH/A" : @"512GB",
            
            @"MGLA3CH/A" : @"128GB",
            @"MGLF3CH/A" : @"256GB",
            @"MGLK3CH/A" : @"512GB",
            
            @"MGLC3CH/A" : @"128GB",
            @"MGLG3CH/A" : @"256GB",
            @"MGLL3CH/A" : @"512GB",
        };
    }
    return _twelveProCapacityDic;
}

- (NSDictionary *)twelveProMaxColorDic {
    if (!_twelveProMaxColorDic) {
        _twelveProMaxColorDic = @{
            @"MGC33CH/A" : @"海蓝色",
            @"MGC73CH/A" : @"海蓝色",
            @"MGCE3CH/A" : @"海蓝色",
            
            @"MGC03CH/A" : @"石墨色",
            @"MGC43CH/A" : @"石墨色",
            @"MGC93CH/A" : @"石墨色",
            
            @"MGC13CH/A" : @"银色",
            @"MGC53CH/A" : @"银色",
            @"MGCA3CH/A" : @"银色",
            
            @"MGC23CH/A" : @"金色",
            @"MGC63CH/A" : @"金色",
            @"MGCC3CH/A" : @"金色",
        };
    }
    return _twelveProMaxColorDic;
}

- (NSDictionary *)twelveProMaxCapacityDic {
    if (!_twelveProMaxCapacityDic) {
        _twelveProMaxCapacityDic = @{
            @"MGC33CH/A" : @"128GB",
            @"MGC73CH/A" : @"256GB",
            @"MGCE3CH/A" : @"512GB",
            
            @"MGC03CH/A" : @"128GB",
            @"MGC43CH/A" : @"256GB",
            @"MGC93CH/A" : @"512GB",
            
            @"MGC13CH/A" : @"128GB",
            @"MGC53CH/A" : @"256GB",
            @"MGCA3CH/A" : @"512GB",
            
            @"MGC23CH/A" : @"128GB",
            @"MGC63CH/A" : @"256GB",
            @"MGCC3CH/A" : @"512GB",
        };
    }
    return _twelveProMaxCapacityDic;
}

@end
