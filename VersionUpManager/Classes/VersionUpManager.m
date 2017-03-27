//
//  VersionUpManager.m
//  VersionUpManager
//
//  Created by ko on 13/05/27.
//  Copyright 2013 MinghuaHu. All rights reserved.
//

#import "VersionUpManager.h"

#define VerUpKey_ListKey       @"VersionUpdateList"
#define VerUpKey_MapVer        @"VersionUpdate_BunderVersion"
#define VerUpKey_MapUpdated    @"VersionUpdate_Updated"
#define VerUpBundleVersion     [NSString stringWithFormat:@"%@",dBundleVersion]

#define VerUpFirstVersion      @"0.0.0"
#define VerMaxRecordCount      5

#define dBundleVersion        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

@interface VersionUpManager(PrivateMethod)

- (BOOL) doDatabaseUpdate;
- (void) synchronize;

- (BOOL) needsUpdate;
- (void) saveUpdated;

@end

static  VersionUpManager  *_sVersionUpManager = nil;

@implementation VersionUpManager
{
    NSMutableArray *_verInfos;  // List<Dict<string,string>>
    NSString       *_oldVer;
    NSString       *_newVer;
}

#pragma mark - init
+ (VersionUpManager *)sharedManager{
	
	if (!_sVersionUpManager) {
		_sVersionUpManager = [[self alloc] init];
	}
	return _sVersionUpManager;
}

- (id)init{
	self = [super init];
	if (self) {
		
		if (!_verInfos) {
            
			//VersionUp plist ロード...
			_verInfos                = [NSMutableArray array];
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			NSArray *orgVerInfos     = [defaults objectForKey:VerUpKey_ListKey];
            
			if (orgVerInfos) {
                [_verInfos addObjectsFromArray:orgVerInfos];
			}
            
            //存在しているかを探索
            BOOL curVerExists = NO;
            for (NSDictionary *dict in _verInfos) {
                if ([[dict objectForKey:VerUpKey_MapVer] isEqualToString:VerUpBundleVersion]) {
                    curVerExists = YES;
                    break;
                }
            }
            
            //存在していない時、追加する
            if (!curVerExists) {
                
                NSMutableDictionary *verInfo = [NSMutableDictionary dictionaryWithCapacity:1];
                [verInfo setObject:VerUpBundleVersion           forKey:VerUpKey_MapVer];
                [verInfo setObject:[NSNumber numberWithBool:NO] forKey:VerUpKey_MapUpdated];
                [_verInfos addObject:verInfo];
                
            }
            
            if ([_verInfos count] < 2) {
                _oldVer = VerUpFirstVersion;
                _newVer = [[_verInfos lastObject] objectForKey:VerUpKey_MapVer];
            }else{
                _oldVer = [[_verInfos objectAtIndex:[_verInfos count] - 2] objectForKey:VerUpKey_MapVer];
                _newVer = [[_verInfos lastObject] objectForKey:VerUpKey_MapVer];
            }
            
		}
	}
	
	return self;
}

#pragma mark -
- (BOOL) needsUpdate
{
	BOOL needs = YES;
	if ([[_verInfos lastObject] objectForKey:VerUpKey_MapUpdated] ) {
		needs = ![[[_verInfos lastObject] objectForKey:VerUpKey_MapUpdated] boolValue];
	}
    
	NSLog(@"needsUpdate: %@",needs ? @"YES" : @"NO");
	
	return needs;
}

- (void)saveUpdated
{
    if ([_verInfos count] > VerMaxRecordCount) {
        [_verInfos removeObjectAtIndex:0];
    }
    
	NSMutableDictionary *verInfo = [_verInfos lastObject];
	[verInfo setObject:[NSNumber numberWithBool:YES] forKey:VerUpKey_MapUpdated];
	[self synchronize];
    
}

- (void)synchronize
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:_verInfos forKey:VerUpKey_ListKey];
	[defaults synchronize];
}

#pragma mark - Version Update Main Process -
- (void)runVersionUpdateProcessIfNeedsWith:(void (^)(NSString * oldVersion, NSString *newVersion))updateProcess
{
    //新バージョンの時のみ行う
	if ([self needsUpdate]) {
		
        //アップデート処理...
        NSLog(@"doUpdate.... FromVersion: %@ toVersion:%@", _oldVer, _newVer);
		updateProcess(_oldVer, _newVer);
        
		//バージョンアップデーティド完了
		[self saveUpdated];
		
	}
}
#pragma mark - runOnceWithToken
- (void)runOnceWithToken:(NSString *)token onProcessBlock:(void (^)(NSString * oldVer, NSString *newVer))processBlock
{
    if (!token) {
        return;
    }
    
    NSString       *tokensKey   = @"Tokens";
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    NSArray        *tokensArray = [defaults objectForKey:tokensKey];
    
    BOOL hasRuned = NO;
    if (tokensArray) {
        for (NSString *tk in tokensArray) {
            if ([token isEqualToString:tk]) {
                hasRuned = YES;
                break;
            }
        }
    }
    
    if (!hasRuned) {
        
        processBlock(_oldVer, _newVer);
        
        NSMutableArray *array = [NSMutableArray arrayWithObject:token];
        if (tokensArray) {
            [array addObjectsFromArray:tokensArray];
        }
        [defaults setObject:array forKey:tokensKey];
        [defaults synchronize];
    }
}

@end










