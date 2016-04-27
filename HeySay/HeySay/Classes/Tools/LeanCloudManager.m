//
//  LeanCloudManager.m
//  HeySay
//
//  Created by ChinaChong on 16/4/21.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "LeanCloudManager.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation LeanCloudManager

+ (instancetype)defaultManeger {
    
    static LeanCloudManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[LeanCloudManager alloc] init];
    });
    
    return manager;
}

// MARK:添加新用户到AllID
- (void)addNewUserToAllIDWithAccountID:(NSString *)accountID andObjectID:(NSString *)objectID {
    
    AVObject *all = [AVObject objectWithoutDataWithClassName:AllIDClassName objectId:AllIDObjectID];
    
    [all fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        NSMutableArray *arrM = (NSMutableArray *)[object objectForKey:AllIDArrayName];
        
        NSDictionary *dict = @{accountID:objectID};
        
        [arrM addObject:dict];
        
        [object setObject:arrM forKey:AllIDArrayName];
        
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                
                NSLog(@"save new user succeeded");
            
            }else {
                
                NSLog(@"save new user failed. error:%@",error);
            }
        }];
        
        if (error) {
            
            NSLog(@"fetchIfNeededInBackground error:%@",error);
        }
        
    }];
    
}

// MARK:从AllID获取全网用户信息(包含多个字典的数组)
- (void)fetchAllIDArr:(fetchAllIDArray)allIdArray {
    
    AVObject *all = [AVObject objectWithoutDataWithClassName:AllIDClassName objectId:AllIDObjectID];
    
    __block typeof(allIdArray) weakArr = allIdArray;
    [all fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        NSArray *array = (NSArray *)[object objectForKey:AllIDArrayName];;
        
        weakArr(array);
    }];
}

// MARK:账号查重
- (void)duplicateCheckWithAccountID:(NSString *)accountID isDuplicate:(checkAccountDuplicate)isDuplicate {
    
    if (accountID == nil || accountID.length < 1) return;
    
    __block typeof(isDuplicate) weakValue = isDuplicate;
    
    [self fetchAllIDArr:^(NSArray *allIdArr) {
        
        NSMutableArray *allKey = [NSMutableArray array];
        
        for (NSDictionary *dict in allIdArr) {
            
            [allKey addObject:[dict allKeys].lastObject];
        }
        
        for (NSString *account in allKey) {
            
            if ([account isEqualToString:accountID]) {
                
                weakValue(YES);
                return;
            }
        }
        weakValue(NO);
    }];
}

// MARK:获取上传图片的URL并上传
- (void)getImageURLAndUploadImageWithName:(NSString *)name imageURL:(fetchImageURL)imageURL {
    
    NSString *filePath = [[NSString documentPath] stringByAppendingPathComponent:[name stringByAppendingString:@".png"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        
        NSLog(@"此路径下没有图片");
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    AVFile *file = [AVFile fileWithName:name data:data];
    
    __block typeof(imageURL) weakImgURL = imageURL;
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            weakImgURL(file.url);
            
            NSLog(@"upload image succeded");
            
        }else {
            
            NSLog(@"upload image failed with error:%@",error);
        }
    }];
}

// MARK:在UserInfo中创建新用户
- (void)createNewUser:(UserModel *)userModel newUserObjectID:(fetchNewUserObjectID)newUserObjectID {
    
    AVObject *user = [AVObject objectWithClassName:@"UserInfo"];
    
    [user setObject:userModel.nickName  forKey:@"nickName"];
    [user setObject:userModel.passWord  forKey:@"passWord"];
    [user setObject:userModel.accountID forKey:@"accountID"];
    [user setObject:userModel.iconUrl   forKey:@"icon"];
    [user setObject:userModel.friends   forKey:@"relation"];
    [user setObject:userModel.chatLog   forKey:@"chatLog"];
    
    __block typeof(newUserObjectID) weakObejctID = newUserObjectID;
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            weakObejctID(user.objectId);
        }
    }];
}

// MARK:通过账号获取密码
- (void)fetchPassWordWithAccount:(NSString *)account getPassWord:(fetchPassWord)passWord {
    
    __block typeof(passWord) weakValue1 = passWord;
    
    [self fetchAllIDArr:^(NSArray *allIdArr) {
        
        for (NSDictionary *dict in allIdArr) {
            
            if ([account isEqualToString:[[dict allKeys] lastObject]]) {
                
                NSString *objectID = dict[account];
                
                __block typeof(weakValue1) weakValue2 = weakValue1;
                
                [self fetchObjectWithObjectID:objectID className:UserInfoClassName getObject:^(id object) {
                    
                    AVObject *avObject = (AVObject *)object;
                    
                    NSString *pwd = avObject[@"passWord"];
                    
                    weakValue2(pwd);
                }];
            }
        }
    }];
}

// MARK:通过ObjectID获取对象
- (void)fetchObjectWithObjectID:(NSString *)ObjectID className:(NSString *)className getObject:(fetchObject)fetchObject {
    
    __block typeof(fetchObject) weakValue = fetchObject;
    
    AVObject *obj = [AVObject objectWithoutDataWithClassName:className objectId:ObjectID];
    
    [obj fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        weakValue(object);
    }];
}

// MARK:获取用户model
- (void)fetchUserInfoWithAccount:(NSString *)account getUserModel:(fetchUserModel)userModel {
    
    __block typeof(userModel) weakValue1 = userModel;
    
    [self fetchAllIDArr:^(NSArray *allIdArr) {
        
        for (NSDictionary *dict in allIdArr) {
            
            if ([account isEqualToString:[[dict allKeys] lastObject]]) {
                
                NSString *objectID = dict[account];
                
                __block typeof(weakValue1) weakValue2 = weakValue1;
                
                [self fetchObjectWithObjectID:objectID className:UserInfoClassName getObject:^(id object) {
                    
                    AVObject *avObject = (AVObject *)object;
                    
                    UserModel *model = [[UserModel alloc] init];
                    
                    model.passWord  = avObject[@"passWord"];
                    model.nickName  = avObject[@"nickName"];
                    model.iconUrl   = avObject[@"icon"];
                    model.objectID  = avObject[@"objectId"];
                    model.accountID = account;
                    model.friends   = avObject[@"relation"];
                    model.chatLog   = avObject[@"chatLog"];
                    
                    weakValue2(model);
                }];
            }
        }
    }];
}

// MARK:给用户添加一个好友关系
- (void)insertFriendAccount:(NSString *)friendAccount userAccount:(NSString *)userAccount friendIsSucceeded:(isSucceeded)friendIsSucceeded userIsSucceeded:(isSucceeded)userIsSucceeded {
    
    [self fetchAllIDArr:^(NSArray *allIdArr) {
        
        
        for (NSDictionary *dict in allIdArr) {
            NSString *act = [[dict allKeys] lastObject];
            
            // 第一层找好友objID
            if ([friendAccount isEqualToString:act]) {
                
                NSString *objID = dict[friendAccount];
                // 第二层找用户的objID
                for (NSDictionary *dic in allIdArr) {
                    if ([userAccount isEqualToString:[[dic allKeys] lastObject]]) {
                        NSString *userObjID = dic[userAccount];
                        
                        NSDictionary *relation = @{userAccount:userObjID};// 换成用户的account和objID
                        
                        // 把user存进friend中
                        [self fetchObjectWithObjectID:objID className:UserInfoClassName getObject:^(id object) {
                            
                            AVObject *obj = (AVObject *)object;
                            NSMutableArray *array = [NSMutableArray array];
                            
                            if (obj[@"relation"]) {
                                array = (NSMutableArray *)obj[@"relation"];
                            }
                            
                            [array addObject:relation];
                            [obj setObject:array forKey:@"relation"];
                            
                            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                
                                friendIsSucceeded(succeeded);
                            }];
                        }];
                        
                        // 把friend存进user中
                        NSDictionary *relation2 = @{friendAccount:objID};
                        [self fetchObjectWithObjectID:userObjID className:UserInfoClassName getObject:^(id object) {
                            
                            AVObject *obj = (AVObject *)object;
                            NSMutableArray *array = [NSMutableArray array];
                            
                            if (obj[@"relation"]) {
                                array = (NSMutableArray *)obj[@"relation"];
                            }
                            
                            [array addObject:relation2];
                            [obj setObject:array forKey:@"relation"];
                            
                            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                
                                userIsSucceeded(succeeded);
                            }];
                        }];
                    }
                }
            }
        }
    }];
}

// MARK:获用户的所有好友信息
- (void)fetchAllFriendsModelWithAccount:(NSString *)account getAllFriendsModel:(fetchFriendsInfo)allFriendsModel {
    
    [self fetchAllIDArr:^(NSArray *allIdArr) {
        
        
        for (NSDictionary *dict in allIdArr) {
            NSString *act = [[dict allKeys] lastObject];
            
            if ([account isEqualToString:act]) {
                NSString *objcID = dict[account];
                [self fetchObjectWithObjectID:objcID className:UserInfoClassName getObject:^(id object) {
                    
                    AVObject *obj = (AVObject *)object;
                    NSMutableArray *relation = [NSMutableArray array];
                    NSMutableArray *array = [NSMutableArray array];
                    if (obj[@"relation"]) {
                        relation = (NSMutableArray *)obj[@"relation"];
                        for (NSDictionary *dict in relation) {
                            NSString *objID = [dict.allValues lastObject];
                            
                            __block typeof(array) weakArr = array;
                            [self fetchObjectWithObjectID:objID className:UserInfoClassName getObject:^(id object) {
                                
                                FriendModel *model = [[FriendModel alloc] init];
                                AVObject *friendObj = (AVObject *)object;
                                model.nickName  = friendObj[@"nickName"];
                                model.iconURL   = friendObj[@"icon"];
                                model.accountID = friendObj[@"accountID"];
                                model.objectID  = friendObj.objectId;
                                
                                [weakArr addObject:model];
                                if (weakArr.count == relation.count) {
                                    
                                    allFriendsModel(weakArr);
                                }
                            }];
                        }
                    }
                }];
            }
        }
    }];
    
}

// MARK:删除用户的指定账号好友
- (void)deleteFriendWithUserAccount:(NSString *)userAccount andFriendAccount:(NSString *)friendAccount completion:(isSucceeded)isSucceeded {
    
    [self fetchObjectWithObjectID:userAccount className:UserInfoClassName getObject:^(id object) {
        
        AVObject *obj = (AVObject *)object;
        NSMutableArray *relation = [NSMutableArray array];
        
        if (obj[@"relation"]) {
            // 取出好友数组relation
            relation = (NSMutableArray *)obj[@"relation"];
            for (int i = 0; i < relation.count; i++) {
                NSDictionary *dict = relation[i];
                NSString *actID = [dict.allKeys lastObject];
                if ([friendAccount isEqualToString:actID]) {
                    [relation removeObjectAtIndex:i];
                    
                    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        // 注册删除好友成功的通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:DeleteFriend object:@(succeeded)];
                    }];
                }
            }
        }
    }];
    
    [self fetchObjectWithObjectID:UserInfoClassName className:userAccount getObject:^(id object) {
        
        AVObject *obj = (AVObject *)object;
        NSMutableArray *relation = [NSMutableArray array];
        
        if (obj[@"relation"]) {
            // 取出好友数组relation
            relation = (NSMutableArray *)obj[@"relation"];
            for (int i = 0; i < relation.count; i++) {
                NSDictionary *dict = relation[i];
                NSString *actID = [dict.allKeys lastObject];
                if ([friendAccount isEqualToString:actID]) {
                    [relation removeObjectAtIndex:i];
                    
                    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        // 注册删除好友成功的通知
//                        [[NSNotificationCenter defaultCenter] postNotificationName:DeleteFriend object:@(succeeded)];
                    }];
                }
            }
        }
    }];
}

@end
