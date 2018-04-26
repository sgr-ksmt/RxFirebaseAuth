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
    case userNotFound
}

// MARK: - Listener
extension Reactive where Base: Auth {
    public func addStateDidChangeListener() -> Observable<(Auth, User?)> {
        return .create { observer in
            let handle = self.base.addStateDidChangeListener { (auth, user) in
                observer.onNext((auth, user))
            }
            return Disposables.create {
                self.base.removeStateDidChangeListener(handle)
            }
        }
    }

    public func addIDTokenDidChangeListener() -> Observable<(Auth, User?)> {
        return .create { observer in
            let handle = self.base.addIDTokenDidChangeListener { (auth, user) in
                observer.onNext((auth, user))
            }
            return Disposables.create {
                self.base.removeIDTokenDidChangeListener(handle)
            }
        }
    }
}

// MARK: - Create user
extension Reactive where Base: Auth {
    public func createUser(WithEmail email: String, password: String) -> Single<User> {
        return .create { observer in
            self.base.createUser(withEmail: email, password: password, completion: singleEventHandler(observer))
            return Disposables.create()
        }
    }

    public func createUserAndRetrieveData(WithEmail email: String, password: String) -> Single<AuthDataResult> {
        return .create { observer in
            self.base.createUserAndRetrieveData(withEmail: email, password: password, completion: singleEventHandler(observer))
            return Disposables.create()
        }
    }
}


// MARK: - Sign in
extension Reactive where Base: Auth {
    public func signInAnonymously() -> Single<User> {
        return .create { observer in
            self.base.signInAnonymously(completion: singleEventHandler(observer))
            return Disposables.create()
        }
    }

    public func signIn(WithEmail email: String, password: String) -> Single<User> {
        return .create { observer in
            self.base.signIn(withEmail: email, password: password, completion: singleEventHandler(observer))
            return Disposables.create()
        }
    }

    public func signInWith(customToken: String) -> Single<User> {
        return .create { observer in
            self.base.signIn(withCustomToken: customToken, completion: singleEventHandler(observer))
            return Disposables.create()
        }
    }

    public func signInWithFacebook(WithAccessToken accessToken: String) -> Single<User> {
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        return signIn(with: credential)
    }

    public func signInWithTwitter(withToken token: String, secret: String) -> Single<User> {
        let credential = TwitterAuthProvider.credential(withToken: token, secret: secret)
        return signIn(with: credential)
    }

    public func signInWithPhoneAuth(withVerificationID verificationID: String, verificationCode code: String) -> Single<User> {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        return signIn(with: credential)
    }

    public func signInWithGitHub(withToken token: String) -> Single<User> {
        let credential = GitHubAuthProvider.credential(withToken: token)
        return signIn(with: credential)
    }

    public func signIn(with credential: AuthCredential) -> Single<User> {
        return .create { observer in
            self.base.signIn(with: credential, completion: singleEventHandler(observer))
            return Disposables.create()
        }
    }

    public func signInAndRetriveData(with credential: AuthCredential) -> Single<AuthDataResult> {
        return .create { observer in
            self.base.signInAndRetrieveData(with: credential, completion: singleEventHandler(observer))
            return Disposables.create()
        }
    }
}

// MARK: - Link
extension Reactive where Base: Auth {
    public func linkWithFacebook(withAccessToken accessToken: String) -> Single<User> {
        return link(with: FacebookAuthProvider.credential(withAccessToken: accessToken))
    }

    public func linkWithTwitter(withToken token: String, secret: String) -> Single<User> {
        return link(with: TwitterAuthProvider.credential(withToken: token, secret: secret))
    }

    public func linkWithPhoneAuth(withVerificationID verificationID: String, verificationCode code: String) -> Single<User> {
        return link(with: PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code))
    }

    public func linkWithGitHub(withToken token: String) -> Single<User> {
        let credential = GitHubAuthProvider.credential(withToken: token)
        return link(with: credential)
    }

    public func link(with credential: AuthCredential) -> Single<User> {
        return base.currentUser.map { $0.rx.link(with: credential) } ?? .error(AuthError.userNotFound)
    }

    public func unlink(with provider: String) -> Single<User> {
        return base.currentUser.map { $0.rx.unlink(with: provider) } ?? .error(AuthError.userNotFound)
    }
}


// MARK: - Sign out
extension Reactive where Base: Auth {
    public func signOut() -> Single<Void> {
        return .create { observer in
            do {
                try self.base.signOut()
                observer(.success(()))
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
}


// MARK: - Send password reset
extension Reactive where Base: Auth {
    public func sendPasswordReset(withEmail email: String) -> Single<Void> {
        return .create { observer in
            self.base.sendPasswordReset(withEmail: email, completion: singleEventErrorHandler(observer))
            return Disposables.create()
        }
    }

    public func sendPasswordReset(withEmail email: String, actionCodeSettings: ActionCodeSettings) -> Single<Void> {
        return .create { observer in
            self.base.sendPasswordReset(withEmail: email, actionCodeSettings: actionCodeSettings, completion: singleEventErrorHandler(observer))
            return Disposables.create()
        }
    }
}
