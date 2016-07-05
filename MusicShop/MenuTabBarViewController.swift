//
//  MenuTabBarViewController.swift
//  MusicShop
//
//  Created by Layne Faler on 6/25/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

import UIKit
import FirebaseAuth

class MenuTabBarViewController: UITabBarController {

    
    
}

// Menu Tab View Controller (Logouts)
extension MenuTabBarViewController {
    
    func logoutOfFirebase() {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}