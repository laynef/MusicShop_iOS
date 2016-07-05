//
//  ViewController.swift
//  MusicShop
//
//  Created by Layne Faler on 6/24/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

// segue: "enterApp"

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import TwitterKit

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    // MARK: - Login View Controller Oulets
    @IBOutlet weak var loginTitleLabel: UILabel!
    @IBOutlet weak var loginUsernameTextfield: UITextField!
    @IBOutlet weak var loginPasswordTextfield: UITextField!
    @IBOutlet weak var loginEnterButton: UIButton!
    @IBOutlet weak var loginSignUpButton: UIButton!
    @IBOutlet weak var loginFacebookButton: UIButton!
    @IBOutlet weak var loginTwitterButton: TWTRLogInButton!
    @IBOutlet weak var loginGoogleButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTwitterLogin()
        googleSignInUI()
    }
}

// MARK: - Login View Controller (Facebook)
extension LoginViewController {
    
    
}

// MARK: - Login View Controller (Twitter)
extension LoginViewController {
    
    func setupTwitterLogin() {
        
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                let alert = UIAlertController(title: "Logged In",
                    message: "User \(unwrappedSession.userName) has logged in",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
        
    }
    
}

// MARK: - Login View Controller (Google)
extension LoginViewController {
    
    // Implement these methods only if the GIDSignInUIDelegate is not a subclass of
    // UIViewController.
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        activityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Google sign in UI
    func googleSignInUI() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignInButtonColorScheme.Dark
    }

    
}

//MARK: - Login View Controller (Error Handling)
extension LoginViewController {
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: title, style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - Login View Controller ()
extension LoginViewController {
    
}

