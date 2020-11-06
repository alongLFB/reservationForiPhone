//
//  AppleStoreModel.h
//  preForiPhone
//
//  Created by 李阿龙 on 2020/10/26.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppleStoreModel : NSObject<NSCoding,NSCopying>
    /*
     * "storeNumber":"R705",
     *          "city":"上海",
     *          "latitude":"31.156105",
     *         "storeName":"七宝",
     *        "enabled":true,
     *       "longitude":"121.345228"
     */

@property(nonatomic, strong) NSString *storeNumber; // "storeNumber":"R705",
@property(nonatomic, strong) NSString *city; // "city":"上海",
@property(nonatomic, strong) NSString *storeName; // "storeName":"七宝",
@property(nonatomic, assign) BOOL enabled;; // "enabled":true,
@property(nonatomic, assign) float latitude; // "latitude":"31.156105",
@property(nonatomic, assign) float longitude; // "longitude":"121.345228"

@end

NS_ASSUME_NONNULL_END
