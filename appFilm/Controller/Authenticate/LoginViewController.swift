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
    
    // MARK: - Constants
    let functions = Functions()
    
    // MARK: - Global variables
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
        loginWithFaceBook()
    }
    
    @IBAction func googleButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    // MARK: - Google login
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        print("\n\nEntra en la funcion sign (GOOGLE) de LoginViewController\n")
        
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
            self.firebaseAuth(credential: credential)
        }
        
    }
    
    // MARK: - Facebook login
    func loginWithFaceBook() {
        
        print("\n\nEntra en la funcion loginWithFacebook\n")
        
        let fbLoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if let error = error {
                self.showAlert(title: "ERROR", message: error.localizedDescription)
                print("Failed to login with Facebook: \(error.localizedDescription)")
                return
            }
            
            let parameters = ["fields": "id, name, email"]
            GraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, result, error) in
                
                if let error = error {
                    self.showAlert(title: "ERROR", message: error.localizedDescription)
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
                    self.saveLoggedUser(loggedUser: self.loggedUser)
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    self.firebaseAuth(credential: credential)
                }
            })
        }
        
    }
    
    //MARK: - Facebook login
    func firebaseAuth(credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (authResult, error) in
            if error == nil {
                self.loggedUser.name = (authResult?.user.displayName)!
                self.loggedUser.email = (authResult?.user.email)!
                self.loggedUser.idFirebase = (authResult?.user.uid)!
                self.loggedUser.signedIn = true
                let uid = self.functions.getUserIdFirebase()
                print("ID obtenido de la uid de Firebase: \(uid)")
                self.saveLoggedUser(loggedUser: self.loggedUser)
                print("\nLogado con éxito en Firebase. Datos del usuario guardados en loggedUser:")
                print("Nombre: \(self.loggedUser.name), Apellido: \(self.loggedUser.lastName), Email: \(self.loggedUser.email), Signed: \(self.loggedUser.signedIn), ID Firebase: \(self.loggedUser.idFirebase), ")
                //self.dismiss(animated: true, completion: nil)
                self.goToScreen(storyboard: "Main", screen: "rootMainStoryboard")
            } else {
                self.showAlert(title: "ERROR", message: error!.localizedDescription)
            }
        })
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
