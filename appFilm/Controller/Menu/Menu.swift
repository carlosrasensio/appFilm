//
//  Menu.swift
//  appFilm
//
//  Created by Carlos R. Asensio on 6/2/19.
//  Copyright © 2019 Carlos R. Asensio. All rights reserved.
//

import UIKit

class Menu: UIViewController {
    
    // MARK: - Constants
    let functions = Functions()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Firebase logout
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let loggedUser = self.functions.readLoggedUser()
        self.functions.userLogout(loggedUser: loggedUser)
    }
}
