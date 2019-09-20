//
//  LoginViewController.swift
//  appFilm
//
//  Created by Carlos Rodriguez Asensio on 09/09/2019.
//  Copyright © 2019 Carlos R. Asensio. All rights reserved.
//

import UIKit
import Foundation
import MaterialComponents
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet var emailTextField: MDCTextField!
    @IBOutlet var passwordTextField: MDCTextField!
    
    // MARK: - Outlets properties
    var emailTextFieldController: MDCTextInputController?
    var passwordTextFieldController: MDCTextInputController?
    
    // MARK: - Global variables
    let functions = Functions()
    var loggedUser = User(name: "", lastName: "", email: "", signedIn: false, idFirebase: "", idGoogle: "", idFacebook: "")
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        // Instantiate controllers
        emailTextFieldController = MDCTextInputControllerFilled(textInput: emailTextField)
        passwordTextFieldController = MDCTextInputControllerFilled(textInput: passwordTextField)

    }
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: - Buttons action
    @IBAction func loginButtonPressed(_ sender: Any) {
    }
    
    @IBAction func facebookButtonPressed(_ sender: Any) {
    }
    
    @IBAction func googleButtonPressed(_ sender: Any) {
    }
    
    // MARK: - Google login
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        print("\n\nEntra en la funcion sign (Google)\n")
        
        if let error = error {
            showAlert(title: "Failed to login with Google", message: error.localizedDescription)
            print("Failed to login with Google: \(error.localizedDescription)")
            return
        } else {
            self.loggedUser.idGoogle = user.userID
            print("idGoogle: \(self.loggedUser.idGoogle)")
            self.loggedUser.name = user.profile.name
            print("SignIn Google --> self.loggedUser.name: \(self.loggedUser.name)")
            self.loggedUser.email = user.profile.email
            print("SignIn Google --> self.loggedUser.email: \(self.loggedUser.email)")
            self.functions.saveLoggedUser(loggedUser: self.loggedUser)
            //firebaseAuth()
        }
        
    }
    
    // MARK: - Facebook login
    func loginWithFaceBook() {
        
        print("\n\nEntra en la funcion loginWithFacebook\n")
        
        let fbLoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if let error = error {
                self.showAlert(title: "Failed to login with Facebook", message: error.localizedDescription)
                print("Failed to login with Facebook: \(error.localizedDescription)")
                return
            }
            
            let parameters = ["fields": "id, name, email"]
            GraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, result, error) in
                
                if let error = error {
                    self.showAlert(title: "Failed getting Facebook user data", message: error.localizedDescription)
                    HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
                    fbLoginManager.logOut()
                    print("Failed getting Facebook user data: ", error.localizedDescription)
                    return
                } else {
                    if let result = result as? [String:String] {
                        if let id: String = result["id"] {
                            print("Facebook id (GraphRequest): \(id)")
                            self.loggedUser.idFacebook = id
                            print("loggedUser id (GraphRequest): \(self.loggedUser.idFacebook)")
                        }
                        if let name: String = result["name"] {
                            print("Facebook name (GraphRequest): \(name)")
                            self.loggedUser.name = name
                            print("loggedUser name (GraphRequest): \(self.loggedUser.name)")
                        }
                        if let email: String = result["email"] {
                            print("Email (GraphRequest): \(email)")
                            self.loggedUser.email = email
                            print("loggedUser email (GraphRequest): \(self.loggedUser.email)")
                        }
                    }
                    self.functions.saveLoggedUser(loggedUser: self.loggedUser)
                    //firebaseAuth()
                }
            })
        }
        
    }
    
    //MARK: - Facebook login
//    func firebaseAuth(loggedUser: User) {
//        self.loggedUser = loggedUser
//        Auth.auth().signIn(withCustomToken: self.loggedUser.tokenFirebase) { (user, error) in
//            if error == nil {
//                let uid = self.getUserIdFirebase()
//                print("ID Firebase: \(uid)")
//                self.loggedUser.signedIn = true
//                self.saveLoggedUser(loggedUser: self.loggedUser)
//                self.dismiss(animated: true, completion: nil)
//                print("\nLogado con éxito en Firebase. Datos del usuario guardados:")
//                print("Nombre: \(self.loggedUser.name), Apellido: \(self.loggedUser.lastName1), Birthday: \(self.loggedUser.birthday), Email: \(self.loggedUser.email), Signed: \(self.loggedUser.signedIn)")
//            } else {
//                self.showAlert(title: "Error", message: error?.localizedDescription)
//            }
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Alert
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
