//
//  AppDelegate.swift
//  FBLoginIsolatedBackendless
//
//  Created by Nevin Jethmalani on 12/2/16.
//  Copyright © 2016 Nevin Jethmalani. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // TestSocial : Info.plist -> FacebookAppID: 1187550204598587 [Back­e­n­d­l­e­s­s­F­S­D­K­L­ogin]
    let APP_ID = "11F87440-6823-01F4-FF7E-A899467C0400"
    let SECRET_KEY = "8AF8ACF5-47EA-B117-FFD4-D96695A8B100"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    var fault : Fault?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Override point for customization after application launch.
        
        //DebLog.setIsActive(true)
        
        backendless!.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        //backendless!.hostURL = "http://api.backendless.com"
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // no equiv. notification. return NO if the application can't open for some reason
        
        
        
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        
        print("AppDelegate (iOS9 >) -> application:openURL: \(url.scheme), [\(sourceApplication) -> \(annotation)]")
        
        let result = FBSDKApplicationDelegate.sharedInstance().application(app, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
        if result {
            
            let token = FBSDKAccessToken.current()
            if token == nil {
                print("ERROR: token = \(token)")
                return false
            }
            
            let fieldsMapping = [
                "id" : "id",
                "name" : "name",
                "first_name": "firstName",
                "last_name" : "lastName",
                "gender": "gender",
                "email": "email"
            ]
            
            if let permissions = token?.value(forKey: "permissions") {
                print("ACCOUNT PERMISSIONS: \(permissions)")
            }
            
            backendless!.userService.login(
                withFacebookSDK: token,
                permissions: ["user_friends", "email", "public_profile", "contact_email"],
                fieldsMapping: fieldsMapping,
                response: { (user: BackendlessUser?) -> Void in
                    print("user: \(user!.email)\n[\(user!.retrieveProperties())]")
                    
                    if user!.isUserRegistered() {
                        print("NEW REGISTATION")
                    }
                    self.validUserTokenSync()
            },
                error: { (fault: Fault?) -> Void in
                    print("Server reported an error: \(fault)")
            })
        }
        
        return result
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func validUserTokenSync() {
        
        Types.tryblock({ () -> Void in
            
            let result = self.backendless!.userService.isValidUserToken() //as NSNumber
            print("isValidUserToken (SYNC): \((result! as NSNumber).boolValue)")
        },
                       
                       catchblock: { (exception) -> Void in
                        self.fault = exception as? Fault
                        print("Server reported an error (SYNC): \(self.fault!)")
        }
        )
    }
    
    func validUserTokenAsync() {
        
        backendless!.userService.isValidUserToken(
            { ( result : AnyObject?) -> () in
                print("isValidUserToken (ASYNC): \((result as! NSNumber).boolValue)")
        },
            error: { ( fault : Fault?) -> () in
                self.fault = fault
                print("Server reported an error (ASYNC): \(fault)")
        }
        )
    }



}

