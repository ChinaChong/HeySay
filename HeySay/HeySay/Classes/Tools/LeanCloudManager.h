//
//  LeanCloudManager.h
//  HeySay
//
//  Created by ChinaChong on 16/4/21.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

typedef void (^fetchObject)          (id object);
typedef void (^fetchImageURL)        (NSString *url);
typedef void (^fetchPassWord)        (NSString *passWord);
typedef void (^fetchUserModel)       (UserModel *userModel);
typedef void (^fetchAllIDArray)      (NSArray *allIdArr);
typedef void (^fetchNewUserObjectID) (NSString *newUserObjectID);
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
- (void)createNewUser:(UserModel *)userModel newUserObjectID:(fetchNewUserObjectID)newUserObjectID;

// 通过账号取出密码
- (void)fetchPassWordWithAccount:(NSString *)account getPassWord:(fetchPassWord)passWord;

// 取出一个用户所有信息,赋值到model返回
- (void)fetchUserInfoWithAccount:(NSString *)account getUserModel:(fetchUserModel)userModel;

@end
