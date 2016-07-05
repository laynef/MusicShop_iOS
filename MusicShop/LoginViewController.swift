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
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    // MARK: - Login View Controller Oulets
    @IBOutlet weak var loginTitleLabel: UILabel!
    @IBOutlet weak var loginUsernameTextfield: UITextField!
    @IBOutlet weak var loginPasswordTextfield: UITextField!
    @IBOutlet weak var loginEnterButton: UIButton!
    @IBOutlet weak var loginSignUpButton: UIButton!
    @IBOutlet weak var loginFacebookButton: FBSDKLoginButton!
    @IBOutlet weak var loginTwitterButton: TWTRLogInButton!
    @IBOutlet weak var loginGoogleButton: GIDSignInButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTwitterLogin()
        googleSignInUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubsribeToKeyboardNotification()
    }
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
        GIDSignInButtonStyle.Wide
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

// MARK: - Login View Controller (Custom Firebase Login)
extension LoginViewController {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    @IBAction func didTapEmailLogin(sender: AnyObject) {
        if let email = self.loginUsernameTextfield.text, password = self.loginPasswordTextfield.text {
            showSpinner({
                // [START headless_email_auth]
                FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                    // [START_EXCLUDE]
                    self.hideSpinner({
                        if let error = error {
                            self.showMessagePrompt(error.localizedDescription)
                            return
                        }
                        self.navigationController!.popViewControllerAnimated(true)
                    })
                    // [END_EXCLUDE]
                }
                // [END headless_email_auth]
            })
        } else {
            self.showMessagePrompt("email/password can't be empty")
        }
    }
    
    /** @fn requestPasswordReset
     @brief Requests a "password reset" email be sent.
     */
    @IBAction func didRequestPasswordReset(sender: AnyObject) {
        showTextInputPromptWithMessage("Email:") { (userPressedOK, userInput) in
            if let userInput = userInput {
                self.showSpinner({
                    // [START password_reset]
                    FIRAuth.auth()?.sendPasswordResetWithEmail(userInput) { (error) in
                        // [START_EXCLUDE]
                        self.hideSpinner({
                            if let error = error {
                                self.showMessagePrompt(error.localizedDescription)
                                return
                            }
                            self.showMessagePrompt("Sent")
                        })
                        // [END_EXCLUDE]
                    }
                    // [END password_reset]
                })
            }
        }
    }
    
    @IBAction func didCreateAccount(sender: AnyObject) {
        showTextInputPromptWithMessage("Email:") { (userPressedOK, email) in
            if let email = email {
                self.showTextInputPromptWithMessage("Password:") { (userPressedOK, password) in
                    if let password = password {
                        self.showSpinner({
                            // [START create_user]
                            FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
                                // [START_EXCLUDE]
                                self.hideSpinner({
                                    if let error = error {
                                        self.showMessagePrompt(error.localizedDescription)
                                        return
                                    }
                                    print("\(user!.email!) created")
                                    self.navigationController!.popViewControllerAnimated(true)
                                })
                                // [END_EXCLUDE]
                            }
                            // [END create_user]
                        })
                    } else {
                        self.showMessagePrompt("password can't be empty")
                    }
                }
            } else {
                self.showMessagePrompt("email can't be empty")
            }
        }
    }

    
}

// MARK: - Login View Controller (Keyboard)
extension LoginViewController {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        selectedTextField = textField
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        selectedTextField = nil
        
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubsribeToKeyboardNotification(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if selectedTextField == loginPasswordTextfield && view.frame.origin.y == 0.0 {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }

    
}

// MARK: - Login View Controller ()
extension LoginViewController {
    
}