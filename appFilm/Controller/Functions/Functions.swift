//
//  Functions.swift
//  appFilm
//
//  Created by Carlos Rodriguez Asensio on 20/09/2019.
//  Copyright © 2019 Carlos R. Asensio. All rights reserved.
//

import Foundation
import Firebase

class Functions {
    
    // MARK: - Navigation
    func goToScreen(storyboard: String, screen: String) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: screen)
        //present(controller, animated: true, completion: nil)
    }
    
    // MARK: - UserDefaults
    func saveLoggedUser(loggedUser: User) {
        let defaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: loggedUser)
        defaults.set(encodedData, forKey: "loggedUser")
        defaults.synchronize()
        print("\n\nFunción saveLoggedUser:")
        print("Name: \(loggedUser.name)\nLast Name: \(loggedUser.lastName)\nEmail: \(loggedUser.email)\nSigned: \(loggedUser.signedIn)")
    }
    
    // MARK: - Firebase
    func getUserIdFirebase() -> String {
        var uid = ""
        if let user = Auth.auth().currentUser {
            uid = user.uid
        }
        return uid
    }
    
    // MARK: - Alert
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        //present(alertController, animated: true, completion: nil)
    }
    
}
