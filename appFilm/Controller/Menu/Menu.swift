//
//  Menu.swift
//  appFilm
//
//  Created by Carlos R. Asensio on 6/2/19.
//  Copyright © 2019 Carlos R. Asensio. All rights reserved.
//

import UIKit

class Menu: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var authButton: UIBarButtonItem!
    
    // MARK: - Constants
    let functions = Functions()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = self.functions.readLoggedUser()
        if user.signedIn {
            authButton.title = "Logout"
        } else {
            authButton.title = "Login"
        }
    }

    // MARK: - Firebase logout
    @IBAction func authButtonPressed(_ sender: Any) {
        let user = self.functions.readLoggedUser()
        if user.signedIn {
            self.functions.userLogout(loggedUser: user)
            viewDidLoad()
        } else {
            self.goToScreen(storyboard: "Authenticate", screen: "rootAuthenticateStoryboard")
        }
    }
    
    // MARK: - Navigation
    func goToScreen(storyboard: String, screen: String) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: screen)
        self.present(controller, animated: true, completion: nil)
    }


}
