# Apple Store 预约助手
起因是想帮助阿姐购买一台银色的512GB的iPhone 12 Pro，但是一直刷新网页，感觉很傻，因此通过 Charles 抓包分析后得知。可以通过苹果官方的两个接口，直接获取得到当前哪个门店有对应的供货。

以下内容 复制自 [apple-store-helper](https://github.com/hteen/apple-store-helper/edit/master/README.md)

如有异议，可以联系删除。

## 正常预约步骤
1. 进入商品预购页面
2. 选择具体型号和门店
3. 要求输入注册码
4. 选择到店时间，填写身份证号
5. 完成

## 重要提示
* *这不是外挂，不能全自动一劳永逸*
* *助手可以直接进入预约步骤3，快人2步，后续步骤需要自己手动操作*
* *提前登录*
* *提前获取注册码，30min内可以复用，获取方式是找个冷门型号走到获取注册码步骤*
* *经过测试12各系列的注册码不能通用*


## 关于开发
* 由于自己是 iOS 客户端开发，因此随意用 OC 写了瞎玩玩，想着可以在iOS手机上，也可以使用，这样就不用担心出去吃饭，没电脑可用的尴尬问题。

### 运行
Mac 电脑系统下， 下载安装Xcode，然后通过 preForiPhone.xcworkspace 打开该工程。


## 使用方法
0. Mac 系统的前提下。
1. 下载 Xcode。
2. 双击 preForiPhone.xcworkspace 打开该工程。
3. 在以下代码中，修改为自己想要的城市，颜色，容量。
``` objc
  self.wantCitySet = [NSSet setWithObjects:@"北京", @"上海", @"成都", @"重庆", @"杭州", @"宁波", @"天津", @"南京", nil];
  self.wantColorSet = [NSSet setWithObjects:@"海蓝色", @"石墨色", @"银色", @"金色", nil];
  self.wantCapacitySet = [NSSet setWithObjects:@"128GB", @"256GB", @"512GB", nil];
```
4. 点击 `运行` 即可
5. 然后在控制台输出栏里，可以使用 火箭 🚀 符号对输出日志进行过滤，该符号，仅当某个店铺有货是，才会输出对应的日志。

6. 匹配到之后会发出类似微信的声音提示，并且复制到电脑的剪切板中。

## 参考图片

效果预览
![效果预览](./Images/printLog.png)

