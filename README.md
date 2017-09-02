# [VersionUpManager](https://kostudio.github.io/VersionUpManager)

[![CI Status](http://img.shields.io/travis/kmk/VersionUpManager.svg?style=flat)](https://travis-ci.org/kmk/VersionUpManager)
[![Version](https://img.shields.io/cocoapods/v/VersionUpManager.svg?style=flat)](http://cocoapods.org/pods/VersionUpManager)
[![License](https://img.shields.io/cocoapods/l/VersionUpManager.svg?style=flat)](http://cocoapods.org/pods/VersionUpManager)
[![Platform](https://img.shields.io/cocoapods/p/VersionUpManager.svg?style=flat)](http://cocoapods.org/pods/VersionUpManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

##import head file
```Objective-C
#import <VersionUpManager/VersionUpManager.h>
```

##Use this when app's version number has changed
```Objective-C
 [[VersionUpManager sharedManager] runVersionUpdateProcessIfNeedsWith:^(NSString *oldVer, NSString *newVer) {
        NSLog(@"oldVer: %@, newVer:%@",oldVer, newVer);
    }];
```

##Use this with your custom token
```
[[VersionUpManager sharedManager] runOnceWithToken:@"AnyToken" onProcessBlock:^(NSString *oldVer, NSString *newVer) {
        NSLog(@"Only run once with token: AnyToken");
    }];
```
## Requirements

## Installation

VersionUpManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "VersionUpManager"
```

## Author

kmk, minghua1211@gmail.com

## License

VersionUpManager is available under the MIT license. See the LICENSE file for more info.
