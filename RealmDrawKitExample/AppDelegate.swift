//
//  AppDelegate.swift
//  RealmDrawCanvasExample
//
//  Created by Tim Oliver on 9/5/17.
//  Copyright © 2017 Realm. All rights reserved.
//

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

