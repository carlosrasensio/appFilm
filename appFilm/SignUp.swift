//
//  SignUp.swift
//  appFilm
//
//  Created by Carlos Rodriguez Asensio on 20/05/2019.
//  Copyright © 2019 Carlos R. Asensio. All rights reserved.
//

import UIKit

class SignUp: UIViewController {
    
    @IBOutlet weak var correoText: UITextField!
    @IBOutlet weak var nombreText: UITextField!
    @IBOutlet weak var apellidosText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordRepeatText: UITextField!
    
    @IBAction func signUpButton(_ sender: Any) {
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
