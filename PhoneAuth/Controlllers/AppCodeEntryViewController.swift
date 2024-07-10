//
//  AppCodeEntryViewController.swift
//  PhoneAuth
//
//  Created by Guselnikov Gordey on 25.06.24.
//

import UIKit

final class AppCodeEntryViewController: UIViewController {
    // MARK: - Private Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите код приложения"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var codeTextField: UITextField = {
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
    
    // MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        codeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        setupSubview(titleLabel, codeTextField, loginWithAppCodeButton)
        setupConstraints()
        updateGetCodeButtonState()
    }
    
    private func setupSubview(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setupConstraints() {
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
    }
    
    // MARK: - Private Methods
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
        guard let enteredCode = codeTextField.text else { return }
        
        guard let savedCode = KeychainManager.load(key: "appCode") else {
            showAlert(title: "Ошибка", message: "Не удалось загрузить код приложения")
            return
        }
        
        if enteredCode == savedCode {
            let accountVC = AccountViewController()
            navigationController?.pushViewController(accountVC, animated: true)
        } else {
            showAlert(title: "Ошибка", message: "Введенный код неверный")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

