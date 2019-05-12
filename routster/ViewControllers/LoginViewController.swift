//
//  LoginViewController.swift
//  routster
//
//  Created by codefuse on 07.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import UIKit
import LGButton

class LoginViewController: RoutsterViewController {

    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.7)])
            usernameTextField.tag = 100
            usernameTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.7)])
            passwordTextField.tag = 101
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var loginButton: LGButton!
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Action methods
    @IBAction func loginButtonDidClicked(_ sender: Any) {
        self.loginButton.isLoading = true
        if let username = self.usernameTextField.text, let password = self.passwordTextField.text {
            APIManager.shared.loginUser(email: username, password: password) { (user, error) in
                if let user = user {
                    UserDefaultsService.email = user.email
                    UserDefaultsService.id = user.username
                    UserDefaultsService.password = user.password
                    
                    self.dismiss(animated: true, completion: {
                        self.loginButton.isLoading = false
                    })
                } else if let error = error {
                    if let code = error.code, let errorMessage = error.error {
                        AlertMessageService.showAlertBottom(title: "Error: \(code)/\(errorMessage)", body: error.message, icon: nil, theme: .error)
                    } else {
                        AlertMessageService.showAlertBottom(title: "Error", body: error.message, icon: nil, theme: .error)
                    }
                    self.loginButton.isLoading = false
                } else {
                    // TODO: - error handling
                    self.loginButton.isLoading = false
                }
            }
        }
    }
    
    @IBAction func socialMediaButtonDidClicked(_ sender: Any) {
        AlertMessageService.showAlertBottom(title: "Note", body: "This feature is not yet implemented in the current version.", icon: "🗳", theme: .info)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFieldTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(textFieldTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
