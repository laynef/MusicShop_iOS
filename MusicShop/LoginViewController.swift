//
//  ViewController.swift
//  MusicShop
//
//  Created by Layne Faler on 6/24/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

// segue: "enterApp"

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    private enum LoginState { case Init, Idle, LoginWithUserPass, LoginWithFacebook }
    
    //MARK: - Login ViewController Properties
    private let facebookCilents = FacebookCilents.sharedClient()
    
    // MARK: - Login View Controller Oulets
    @IBOutlet weak var loginTitleLabel: UILabel!
    @IBOutlet weak var loginUsernameTextfield: UITextField!
    @IBOutlet weak var loginPasswordTextfield: UITextField!
    @IBOutlet weak var loginEnterButton: UIButton!
    @IBOutlet weak var loginSignUpButton: UIButton!
    @IBOutlet weak var loginFacebookButton: FBSDKLoginButton!
    @IBOutlet weak var loginTwitterButton: UIButton!
    @IBOutlet weak var loginGoogleButton: GIDSignInButton!
    @IBOutlet weak var loginLinkdInButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        facebookCilents.logout()
        configureUIForState(.Init)
        googleButtonDesigns()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        if facebookCilents.currentAccessToken() == nil {
            configureUIForState(.Idle)
        }
    }

    private func configureUIForState(state: LoginState) {
        
        func startActivityIndicatorAndFade() {
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            loginEnterButton.enabled = false
            loginFacebookButton.enabled = false
            view.alpha = 0.5
        }
        
        switch(state) {
        case .Init:
            let backgroundGradient = CAGradientLayer()
            backgroundGradient.colors = [AppConstants.UI.LoginColorTop, AppConstants.UI.LoginColorBottom]
            backgroundGradient.locations = [0.0, 1.0]
            backgroundGradient.frame = view.frame
            view.layer.insertSublayer(backgroundGradient, atIndex: 0)
            loginFacebookButton.readPermissions = ["public_profile"]
            loginFacebookButton.delegate = self
        case .Idle:
            loginEnterButton.enabled = true
            activityIndicator.hidden = true
            activityIndicator.stopAnimating()
            loginFacebookButton.enabled = true
            view.alpha = 1.0
        case .LoginWithUserPass:
            startActivityIndicatorAndFade()
        case .LoginWithFacebook:
            startActivityIndicatorAndFade()
            loginUsernameTextfield.text = ""
            loginPasswordTextfield.text = ""
        }
    }


}

// MARK: - Login View Controller (Facebook)
extension LoginViewController {
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        if facebookCilents.currentAccessToken() == nil {
            configureUIForState(.LoginWithFacebook)
        }
        return true
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        func displayError(error: String) {
            self.facebookCilents.logout()
            self.rejectWithError(error)
        }
        
        configureUIForState(.LoginWithFacebook)
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        configureUIForState(.Idle)
    }
    
}

// MARK: - Login View Controller (Twitter)
extension LoginViewController {
    
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
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Designs UI for the Google Sign In Button
    func googleButtonDesigns() {
        GIDSignIn.sharedInstance().uiDelegate = self
        loginGoogleButton.colorScheme = GIDSignInButtonColorScheme.Light
        loginGoogleButton.style = GIDSignInButtonStyle.Standard
    }
}

// MARK: - Login View Controller (LinkdIn)
extension LoginViewController {
    
}

//MARK: - Login View Controller (Error Handling)
extension LoginViewController {
    
    private func alertWithError(error: String) {
        configureUIForState(.Idle)
        let alertView = UIAlertController(title: AppConstants.Alerts.LoginTitle, message: error, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: AppConstants.AlertActions.Dismiss, style: .Cancel, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    private func rejectWithError(error: String) {
        configureUIForState(.Idle)
        shakeUI()
        showAlert("\(error)", message: "\(error)")
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: title, style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func shakeUI() {
        UIView.animateWithDuration(1.0) {
            let loginCenter = self.view.center
            let shake = CABasicAnimation(keyPath: "position")
            shake.duration = 0.1
            shake.repeatCount = 2
            shake.autoreverses = true
            shake.fromValue = NSValue(CGPoint: CGPointMake(loginCenter.x - 5, loginCenter.y))
            shake.toValue = NSValue(CGPoint: CGPointMake(loginCenter.x + 5, loginCenter.y))
            self.view.layer.addAnimation(shake, forKey: "position")
        }
    }
}

