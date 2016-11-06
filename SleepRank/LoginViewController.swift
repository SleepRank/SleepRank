//
//  LoginViewController.swift
//  SleepRank
//
//  Created by Han Liu on 05/11/2016.
//  Copyright © 2016 SleepRank. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var loginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil)
        {
            performSegue(withIdentifier: "loginSegue", sender: self)
            print("Already logged In")
        }
        else
        {
            loginButton = FBSDKLoginButton()
            loginButton.delegate = self
            loginButton.readPermissions = ["public_profile", "email", "user_friends"]
            loginButton.center = self.view.center
            self.view.addSubview(loginButton)
            print("add")
        }
        print("over")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

