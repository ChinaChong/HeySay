//
//  LeanCloudManager.h
//  HeySay
//
//  Created by ChinaChong on 16/4/21.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

typedef void (^fetchAllIDArray)      (NSArray *allIdArr);
typedef void (^fetchImageURL)        (NSString *url);
typedef void (^fetchNewUserObject)   (NSString *newUserObjectID);
typedef void (^fetchPassWord)        (NSString *passWord);
typedef void (^fetchObject)          (id object);
typedef void (^checkAccountDuplicate)(BOOL isDuplicate);

@interface LeanCloudManager : NSObject

+ (instancetype)defaultManeger;

// 添加一个新用户到AllID
- (void)addNewUserToAllIDWithAccountID:(NSString *)accountID andObjectID:(NSString *)objectID;

// 从AllID获取所有用户信息
- (void)fetchAllIDArr:(fetchAllIDArray)allIdArray;

// 账号查重
- (void)duplicateCheckWithAccountID:(NSString *)accountID isDuplicate:(checkAccountDuplicate)isDuplicate;

// 获取上传图片的URL并上传
- (void)getImageURLAndUploadImageWithName:(NSString *)name imageURL:(fetchImageURL)imageURL;

// 在UserInfo中创建新用户
- (void)createNewUser:(UserModel *)userModel newUserObjectID:(fetchNewUserObject)newUserObjectID;

// 通过账号取出密码
- (void)fetchPassWordWithAccount:(NSString *)account getPassWord:(fetchPassWord)passWord;


@end
