//
//  ViewController.swift
//  FBLoginIsolatedBackendless
//
//  Created by Nevin Jethmalani on 12/2/16.
//  Copyright © 2016 Nevin Jethmalani. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton = FBSDKLoginButton()
        //let loginButton = LoginButton(readPermissions: [ .PublicProfile ])
        loginButton.center = self.view.center
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

