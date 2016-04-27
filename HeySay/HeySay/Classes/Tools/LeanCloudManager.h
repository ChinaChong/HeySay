//
//  LeanCloudManager.h
//  HeySay
//
//  Created by ChinaChong on 16/4/21.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "FriendModel.h"

typedef void (^fetchObject)          (id object);
typedef void (^isSucceeded)          (BOOL isSucceeded);
typedef void (^fetchImageURL)        (NSString *url);
typedef void (^fetchPassWord)        (NSString *passWord);
typedef void (^fetchUserModel)       (UserModel *userModel);
typedef void (^fetchAllIDArray)      (NSArray *allIdArr);
typedef void (^fetchFriendsInfo)     (NSArray *allFriendsModel);
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
// 通过账号取出密码
- (void)fetchPassWordWithAccount:(NSString *)account getPassWord:(fetchPassWord)passWord;

// 获取上传图片的URL并上传
- (void)getImageURLAndUploadImageWithName:(NSString *)name imageURL:(fetchImageURL)imageURL;

// 在UserInfo中创建新用户
- (void)createNewUser:(UserModel *)userModel newUserObjectID:(fetchNewUserObjectID)newUserObjectID;


// 通过账号取出一个用户所有信息,返回UserModel
- (void)fetchUserInfoWithAccount:(NSString *)account getUserModel:(fetchUserModel)userModel;
// 获用户的所有好友信息,返回所有FriendModel
- (void)fetchAllFriendsModelWithAccount:(NSString *)account getAllFriendsModel:(fetchFriendsInfo)allFriendsModel;

// 给用户添加一个好友关系
- (void)insertFriendAccount:(NSString *)friendAccount userAccount:(NSString *)userAccount friendIsSucceeded:(isSucceeded)friendIsSucceeded userIsSucceeded:(isSucceeded)userIsSucceeded;
// 删除用户的指定账号好友
- (void)deleteFriendWithUserAccount:(NSString *)userAccount andFriendAccount:(NSString *)friendAccount completion:(isSucceeded)isSucceeded;

@end
