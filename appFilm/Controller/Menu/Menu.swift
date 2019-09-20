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
            let dialogMessage = UIAlertController(title: "Cerrar sesión", message: "¿Está seguro de querer cerrar sesión?", preferredStyle: .actionSheet)
            let signOutAction = UIAlertAction(title: "Sí", style: .destructive) { (action) in
                do {
                    self.functions.userLogout(loggedUser: user)
                    self.goToScreen(storyboard: "Authenticate", screen: "rootAuthenticateStoryboard")
                    print("\nEl usuario ha cerrado sesión con éxito\n")
                } catch let error {
                    print("[!] Error al hacer sign out --> ", error)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            dialogMessage.addAction(cancelAction)
            dialogMessage.addAction(signOutAction)
            self.present(dialogMessage, animated: true, completion: nil)
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
