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
        
//        // Instantiate controllers
//        nameTextFieldController = MDCTextInputControllerFilled(textInput: nameTextField)
//        lastnameTextFieldController = MDCTextInputControllerFilled(textInput: lastnameTextField)
//        emailTextFieldController = MDCTextInputControllerFilled(textInput: emailTextField)
//        passwordTextFieldController = MDCTextInputControllerFilled(textInput: passwordTextField)
//        repeatPasswordTextFieldController = MDCTextInputControllerFilled(textInput: repeatPasswordTextField)
    }
    
    // MARK: - Buttons action
    @IBAction func signUpBtnPressed(_ sender: Any) {
        signUpBasic()
    }
    
    @IBAction func facebookButtonPressed(_ sender: Any) {
        LoginViewController().loginWithFaceBook()
    }
    
    @IBAction func googleButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    // MARK: - Basic sign up
    func signUpBasic() {
        var flag = true
        if (nameTextField == nil) {
            print("\n[!] ERROR: Necesitas añadir tu nombre\n")
            //showAlert(title: "ERROR", message: "Es necesario rellenar todos los campos.")
            nameTextFieldController?.setErrorText("Es necesario introducir un nombre.", errorAccessibilityValue: nil)
            flag = false
        }
        if(lastnameTextField == nil) {
            print("\n[!] ERROR: Necesitas añadir tu apellido\n")
            lastnameTextFieldController?.setErrorText("Es necesario introducir un apellido.", errorAccessibilityValue: nil)
            flag = false
        }
        if(emailTextField == nil) {
            print("\n[!] ERROR: Necesitas añadir tu email\n")
            emailTextFieldController?.setErrorText("Es necesario introducir un email.", errorAccessibilityValue: nil)
            flag = false
        }
        if(passwordTextField == nil) {
            print("\n[!] ERROR: Necesitas añadir tu contraseña\n")
            passwordTextFieldController?.setErrorText("Es necesario introducir una contraseña.", errorAccessibilityValue: nil)
            flag = false
        }
        if(repeatPasswordTextField == nil) {
            print("\n[!] ERROR: Necesitas añadir tu contraseña de nuevo\n")
            repeatPasswordTextFieldController?.setErrorText("Es necesario introducir una contraseña.", errorAccessibilityValue: nil)
            flag = false
        }
        if(repeatPasswordTextField != nil && repeatPasswordTextField.text != passwordTextField.text){
            repeatPasswordTextFieldController?.setErrorText("Las contraseñas deben coincidir.", errorAccessibilityValue: nil)
            flag = false
        }
        if flag {
            if (passwordTextField.text!.count > 5 && (repeatPasswordTextField.text == passwordTextField.text)) {
                print("\nCampos rellenados correctamente\n")
                self.loggedUser.name = nameTextField.text!
                self.loggedUser.lastName = lastnameTextField.text!
                self.loggedUser.email = emailTextField.text!
                self.loggedUser.signedIn = true
                self.saveLoggedUser(loggedUser: self.loggedUser)
                Auth.auth().createUser(withEmail: self.loggedUser.email, password: passwordTextField.text!) { (authResult, error) in
                    
                    if error != nil {
                        if let errCode = AuthErrorCode(rawValue: error!._code) {
                            switch errCode {
                            case .invalidEmail:
                                print("Email invalido")
                                self.showAlert(title: "ERROR", message: "El formato del email introducido es incorrecto.")
                            case .emailAlreadyInUse:
                                print("Email en uso")
                                self.showAlert(title: "ERROR", message: "El email introducido ya está utilizado. Por favor, utilice uno distinto o inicie sesión")
                            default:
                                print("Create User Error: \(error!)")
                            }
                        }
                    } else {
                        guard let user = authResult?.user else { return }
                        print("\nUsuario autenticado en Firebase: ")
                        print("Nombre: \(user.displayName), Email: \(user.email), ID Firebase: \(user.uid)\n")
                        self.goToScreen(storyboard: "Authenticate", screen: "Login")
                    }
                }
            } else if (passwordTextField.text!.count < 6) {
                print("\n[!] ERROR: La contraseña debe contener al menos 6 caracteres.\n")
                self.showAlert(title: "ERROR", message: "La contraseña debe contener al menos 6 caracteres.")
            } else {
                print("\n[!] ERROR: Las contraseñas deben coincidir.\n")
                self.showAlert(title: "ERROR", message: "La contraseña debe coincidir en los dos campos.")
            }
        }
    }
    
    // MARK: - Google sign up
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
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: UITextFieldDelegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.placeholder {
        case "Nombre":
            nameTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        case "Apellido":
            lastnameTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        case "Email":
            emailTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        case "Contraseña":
            passwordTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        case "Repetir contraseña":
            repeatPasswordTextFieldController?.setErrorText(nil, errorAccessibilityValue: nil)
        default:
            print("Case default textFieldDidBeginEditing")
            break
        }
    }
    
}
