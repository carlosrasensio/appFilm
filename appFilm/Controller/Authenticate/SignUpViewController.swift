//
//  SignUpViewController.swift
//  appFilm
//
//  Created by Carlos Rodriguez Asensio on 09/09/2019.
//  Copyright © 2019 Carlos R. Asensio. All rights reserved.
//

import UIKit
import MaterialComponents
import Firebase
import GoogleSignIn
import FirebaseAuth

class SignUpViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet var nameTextField: MDCTextField!
    @IBOutlet var lastnameTextField: MDCTextField!
    @IBOutlet var emailTextField: MDCTextField!
    @IBOutlet var passwordTextField: MDCTextField!
    @IBOutlet var repeatPasswordTextField: MDCTextField!
    
    // MARK: - Outlets properties
    var nameTextFieldController: MDCTextInputController?
    var lastnameTextFieldController: MDCTextInputController?
    var emailTextFieldController: MDCTextInputController?
    var passwordTextFieldController: MDCTextInputController?
    var repeatPasswordTextFieldController: MDCTextInputController?
    
    // MARK: - Constants
    let functions = Functions()
    
    // MARK: - Global variables
    var loggedUser = User(name: "", lastName: "", email: "", signedIn: false, idFirebase: "", idGoogle: "", idFacebook: "")
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate controllers
        nameTextFieldController = MDCTextInputControllerFilled(textInput: nameTextField)
        lastnameTextFieldController = MDCTextInputControllerFilled(textInput: lastnameTextField)
        emailTextFieldController = MDCTextInputControllerFilled(textInput: emailTextField)
        passwordTextFieldController = MDCTextInputControllerFilled(textInput: passwordTextField)
        repeatPasswordTextFieldController = MDCTextInputControllerFilled(textInput: repeatPasswordTextField)
    }
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: - Buttons action
    @IBAction func signUpBtnPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func facebookButtonPressed(_ sender: Any) {
        LoginViewController().loginWithFaceBook()
    }
    
    @IBAction func googleButtonPressed(_ sender: Any) {
    }
    
    // MARK: - Google login
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        print("\n\nEntra en la funcion sign (GOOGLE) de SignUpViewController\n")
        
        if let error = error {
            showAlert(title: "ERROR", message: error.localizedDescription)
            print("Failed to login with Google: \(error.localizedDescription)")
            return
        } else {
            self.loggedUser.idGoogle = user.userID
            print("SignIn Google --> self.loggedUser.idGoogle: \(self.loggedUser.idGoogle)")
            self.loggedUser.name = user.profile.name
            print("SignIn Google --> self.loggedUser.name: \(self.loggedUser.name)")
            self.loggedUser.email = user.profile.email
            print("SignIn Google --> self.loggedUser.email: \(self.loggedUser.email)\n")
            self.saveLoggedUser(loggedUser: self.loggedUser)
            // Se obtiene un token de ID de Google y un token de acceso de Google del objeto GIDAuthentication:
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            LoginViewController().firebaseAuth(credential: credential)
        }
        
    }
    
    // MARK: - Alert
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
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
    
    // MARK: - Navigation
    func goToScreen(storyboard: String, screen: String) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: screen)
        self.present(controller, animated: true, completion: nil)
    }
    
}
