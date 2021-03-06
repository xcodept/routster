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
            self.usernameTextField.attributedPlaceholder = NSAttributedString(string: L10n.email, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.7)])
            self.usernameTextField.tag = 100
            self.usernameTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            self.passwordTextField.attributedPlaceholder = NSAttributedString(string: L10n.password, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.7)])
            self.passwordTextField.tag = 101
            self.passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var loginButton: LGButton!
    @IBOutlet weak var loginDescriptionLabel: UILabel! {
        didSet {
            self.loginDescriptionLabel.text = L10n.loginDescriptionLabelText
        }
    }
    
    @IBOutlet weak var connectLabel: UILabel! {
        didSet {
            self.connectLabel.text = L10n.connectLabelText
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configuration handler
    private func handle(user: User) {
        UserDefaultsService.storeUserInformation(email: user.email, username: user.username, password: user.password)
        
        self.dismiss(animated: true, completion: {
            self.loginButton.isLoading = false
        })
    }
    
    private func handle(error: Error) {
        if let code = error.code, let errorMessage = error.error {
            AlertMessageService.showAlertBottom(title: "\(L10n.error.capitalized): \(code)/\(errorMessage)", body: error.message, icon: nil, theme: .error)
        } else {
            AlertMessageService.showAlertBottom(title: L10n.error.capitalized, body: error.message, icon: nil, theme: .error)
        }
        self.loginButton.isLoading = false
    }
    
    // MARK: - Action methods
    @IBAction func loginButtonDidClicked(_ sender: Any) {
        self.loginButton.isLoading = true
        if let username = self.usernameTextField.text, let password = self.passwordTextField.text {
            APIManager.shared.loginUser(email: username, password: password) { [weak self] (userResult) in
                switch userResult {
                case .success(let user):
                    self?.handle(user: user)
                case .error(let error):
                    self?.handle(error: error)
                }
            }
        }
    }
    
    @IBAction func socialMediaButtonDidClicked(_ sender: Any) {
        AlertMessageService.showAlertBottom(title: L10n.note.capitalized, body: L10n.featureNotImplemented, icon: "🗳", theme: .info)
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
