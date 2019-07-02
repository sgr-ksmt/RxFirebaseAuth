# RxFirebaseAuth
Combination of RxSwift and Firebase Authentication

[![GitHub release](https://img.shields.io/github/release/sgr-ksmt/RxFirebaseAuth.svg)](https://github.com/sgr-ksmt/RxFirebaseAuth/releases)
![Language](https://img.shields.io/badge/language-Swift%205.0-orange.svg)
[![CocoaPods](https://img.shields.io/badge/Cocoa%20Pods-✓-4BC51D.svg?style=flat)](https://cocoapods.org/pods/RxFirebaseAuth)
[![CocoaPodsDL](https://img.shields.io/cocoapods/dt/RxFirebaseAuth.svg)](https://cocoapods.org/pods/RxFirebaseAuth)

## Usages

```swift
Auth.auth().rx.addStateDidChangeListener()
    .subscribe(onSuccess: { (auth, user) in
        // ...
    })
    .disposed(by: disposeBag)
```

```swift
Auth.auth().rx.signInAnonymously()
    .flatMap { UserModel.create(uid: $0.uid) }
    .subscribe(onSuccess: { user in
        // ...
    })
    .disposed(by: disposeBag)
```


## Dependencies
- RxSwift 5.x
- Firebase Auth 6.x

## Installation
### CocoaPods
**CocoaPods 1.4 or higher** required.

**RxFirebaseAuth** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
# Firebase 6.x
pod 'RxFirebaseAuth', '~> 2.4'

# Firebase 5.x
pod 'RxFirebaseAuth', '~> 2.3'

# Firebase 4.x
pod 'RxFirebaseAuth', '~> 1.0'

```

and run `pod install`

### Manually Install
Download all `*.swift` files and put your project.

## Development

```bash
$ bundle install --path vendor/bundle
$ bundle exec pod install
$ open komerco.xcworkspace
```

## Communication
- If you found a bug, open an issue.
- If you have a feature request, open an issue.
- If you want to contribute, submit a pull request.:muscle:

## License
**RxFirebaseAuth** is under MIT license. See the [LICENSE](LICENSE) file for more info.
