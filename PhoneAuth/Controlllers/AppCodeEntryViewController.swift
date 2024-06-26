//
//  AppCodeEntryViewController.swift
//  PhoneAuth
//
//  Created by Guselnikov Gordey on 25.06.24.
//

import UIKit

class AppCodeEntryViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите код приложения"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "Введите код"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginWithAppCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти по коду приложения", for: .normal)
        button.backgroundColor = .gray
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.addAction(UIAction { [unowned self] _ in
            loginButtonTapped()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupUI()
        codeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupUI() {
        
        
        view.addSubview(titleLabel)
        view.addSubview(codeTextField)
        view.addSubview(loginWithAppCodeButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            codeTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            codeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            codeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            codeTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginWithAppCodeButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 20),
            loginWithAppCodeButton.widthAnchor.constraint(equalToConstant: 319),
            loginWithAppCodeButton.heightAnchor.constraint(equalToConstant: 50),
            loginWithAppCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
            
        ])
        updateGetCodeButtonState()
    }
    
    @objc private func textFieldDidChange() {
        updateGetCodeButtonState()
    }
    
    private func updateGetCodeButtonState() {
        let isPhoneNumberValid = codeTextField.text?.count ?? 0 > 3
        loginWithAppCodeButton.isEnabled = isPhoneNumberValid
        if isPhoneNumberValid {
            loginWithAppCodeButton.applyGradient()
        } else {
            loginWithAppCodeButton.backgroundColor = .gray
        }
    }
    
    private func loginButtonTapped() {
        guard let enteredCode = codeTextField.text else {
            // Handle case where code is empty
            return
        }
        
        // Load saved app code from Keychain
        guard let savedCode = KeychainManager.load(key: "appCode") else {
            // Handle case where there is no saved app code
            showAlert(title: "Ошибка", message: "Не удалось загрузить код приложения")
            return
        }
        
        // Check if entered code matches the saved app code
        if enteredCode == savedCode {
            // Navigate to AccountViewController upon successful login
            let accountVC = AccountViewController()
            navigationController?.pushViewController(accountVC, animated: true)
        } else {
            // Show alert for incorrect code
            showAlert(title: "Ошибка", message: "Введенный код неверный")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

