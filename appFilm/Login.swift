//
//  Login.swift
//  appFilm
//
//  Created by Carlos Rodriguez Asensio on 20/05/2019.
//  Copyright © 2019 Carlos R. Asensio. All rights reserved.
//

import UIKit
import Firebase

class Login: UIViewController {

    @IBOutlet weak var correoText: UITextField!
    @IBOutlet weak var passwordtext: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        //1.
        if self.correoText.text == "" || self.passwordtext.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Por favor introduce email y contraseña", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            //2.
            Auth.auth().signIn(withEmail: self.correoText.text!, password: self.passwordtext.text!) { (user, error) in
                //3.
                if error == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    //4.
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
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
