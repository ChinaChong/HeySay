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
    
    [user setObject:userModel.nickName forKey:@"nickName"];
    [user setObject:userModel.passWord forKey:@"passWord"];
    [user setObject:userModel.accountID forKey:@"accountID"];
    [user setObject:userModel.iconUrl forKey:@"icon"];
    
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
                    
                    model.passWord = avObject[@"passWord"];
                    model.nickName = avObject[@"nickName"];
                    model.iconUrl  = avObject[@"icon"];
                    model.objectID = avObject[@"objectId"];
                    model.accountID = account;
                    
                    weakValue2(model);
                }];
            }
        }
    }];
}


@end
