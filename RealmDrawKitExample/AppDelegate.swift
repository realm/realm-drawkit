//
//  AppDelegate.swift
//
//  Copyright 2017 Realm Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import RealmSwift
import RealmLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawViewController: DrawViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        drawViewController = DrawViewController()
        window?.rootViewController = drawViewController

        window?.makeKeyAndVisible()

        let loginViewController = LoginViewController(style: .lightTranslucent)
        loginViewController.loginSuccessfulHandler = { user in
            DispatchQueue.main.async {
                let serverURL = loginViewController.serverURL!

                var configuration = Realm.Configuration.defaultConfiguration
                configuration.syncConfiguration = SyncConfiguration(user: user, realmURL: URL(string: "realm://\(serverURL):9080/~/DrawKit")!)
                Realm.Configuration.defaultConfiguration = configuration

                // Create canvas for first time
                Realm.asyncOpen(callback: { realm, error in
                    var realmCanvas = realm!.objects(RealmDrawCanvas.self).first
                    if realmCanvas == nil {
                        realmCanvas = RealmDrawCanvas()
                        try! realm!.write {
                            realm!.add(realmCanvas!)
                        }
                    }

                    self.drawViewController?.realmCanvas = realmCanvas
                    self.drawViewController?.dismiss(animated: true, completion: nil )
                })
            }
        }

        window?.rootViewController?.present(loginViewController, animated: true)

        return true
    }
}

