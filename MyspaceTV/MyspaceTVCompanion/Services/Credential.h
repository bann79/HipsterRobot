//
// Created by rmacharg on 19/07/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Credential : NSObject
@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *password;

@property (strong, nonatomic)NSString *deviceId;
@property (strong, nonatomic)NSString *snName;
@property BOOL rememberMe;
@end