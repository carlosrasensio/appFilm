//
//  SignUp.swift
//  appFilm
//
//  Created by Carlos Rodriguez Asensio on 20/05/2019.
//  Copyright © 2019 Carlos R. Asensio. All rights reserved.
//

import UIKit
import Firebase

class SignUp: UIViewController {
    
    @IBOutlet weak var correoText: UITextField!
    @IBOutlet weak var nombreText: UITextField!
    @IBOutlet weak var apellidosText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordRepeatText: UITextField!
    var email:String = ""
    var password:String = ""
    
    @IBAction func signUpButton(_ sender: Any) {
        email = correoText.text!
        password = passwordText.text!
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else { return }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
