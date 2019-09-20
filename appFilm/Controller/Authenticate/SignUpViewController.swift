//
//  SignUpViewController.swift
//  appFilm
//
//  Created by Carlos Rodriguez Asensio on 09/09/2019.
//  Copyright © 2019 Carlos R. Asensio. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

}
