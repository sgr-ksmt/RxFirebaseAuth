//
//  Auth+Rx.swift
//  RxFirebase
//
//  Created by suguru-kishimoto on 2017/10/17.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift

public enum AuthError: Error {
    case currentAuthUserNotFound
}

extension Reactive where Base: Auth {
    public func addStateDidChangeListener() -> Observable<(Auth, User?)> {
        return .create { observer in
            let handle = self.base.addStateDidChangeListener(observer.onNext)
            return Disposables.create {
                self.base.removeStateDidChangeListener(handle)
            }
        }
    }

    public func createUserWith(email: String, password: String) -> Single<User> {
        return .create { observer in
            self.base.createUser(withEmail: email, password: password) { user, error in
                switch Result(user, error) {
                case .success(let user):
                    observer(.success(user))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    public func signInAnonymously() -> Single<User> {
        return .create { observer in
            self.base.signInAnonymously { (user, error) in
                switch Result(user, error) {
                case .success(let user):
                    observer(.success(user))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    public func signInWith(email: String, password: String) -> Single<User> {
        return .create { observer in
            self.base.signIn(withEmail: email, password: password) { user, error in
                switch Result(user, error) {
                case .success(let user):
                    observer(.success(user))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    public func signInWith(customToken: String) -> Single<User> {
        return .create { observer in
            self.base.signIn(withCustomToken: customToken) { user, error in
                switch Result(user, error) {
                case .success(let user):
                    observer(.success(user))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    public func signInWithFacebook(accessToken: String) -> Single<User> {
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        return signIn(with: credential)
    }

    public func signInWithTwitter(token: String, secret: String) -> Single<User> {
        let credential = TwitterAuthProvider.credential(withToken: token, secret: secret)
        return signIn(with: credential)
    }

    public func signInWithPhoneAuth(verificationID id: String, verificationCode code: String) -> Single<User> {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: code)
        return signIn(with: credential)
    }

    public func signInWithGitHub(token: String) -> Single<User> {
        let credential = GitHubAuthProvider.credential(withToken: token)
        return signIn(with: credential)
    }

    public func signIn(with credential: AuthCredential) -> Single<User> {
        return .create { observer in
            self.base.signIn(with: credential) { (authUser, error) in
                switch Result(authUser, error) {
                case .success(let user):
                    observer(.success(user))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    public func signInAndRetriveData(with credential: AuthCredential) -> Single<AuthDataResult> {
        return .create { observer in
            self.base.signInAndRetrieveData(with: credential) { (authDataResult, error) in
                switch Result(authDataResult, error) {
                case .success(let result):
                    observer(.success(result))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    public func linkWithFacebook(accessToken: String) -> Single<User> {
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        return link(with: credential)
    }

    public func linkWithTwitter(token: String, secret: String) -> Single<User> {
        let credential = TwitterAuthProvider.credential(withToken: token, secret: secret)
        return link(with: credential)
    }

    public func linkWithPhoneAuth(verificationID id: String, verificationCode code: String) -> Single<User> {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: code)
        return link(with: credential)
    }

    public func linkWithGitHub(token: String) -> Single<User> {
        let credential = GitHubAuthProvider.credential(withToken: token)
        return link(with: credential)
    }

    public func link(with credential: AuthCredential) -> Single<User> {
        guard let authUser = base.currentUser else {
           return Single.error(AuthError.currentAuthUserNotFound)
        }
        return authUser.rx.link(with: credential)
    }

    public func unlink(with provider: String) -> Single<User> {
        guard let authUser = base.currentUser else {
            return Single.error(AuthError.currentAuthUserNotFound)
        }
        return authUser.rx.unlink(with: provider)
    }

    public func signOut() -> Completable {
        return .create { observer in
            do {
                try self.base.signOut()
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
}

