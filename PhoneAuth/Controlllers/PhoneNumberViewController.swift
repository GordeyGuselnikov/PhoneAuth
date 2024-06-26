//
//  ViewController.swift
//  PhoneAuth
//
//  Created by Guselnikov Gordey on 24.06.24.
//

import UIKit

class PhoneNumberViewController: UIViewController {
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Номер телефона"
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countryCodeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "+7"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .secondarySystemBackground
        textField.placeholder = "Ваш номер телефона"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Код придет на ваш номер телефона"
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var getCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Получить код", for: .normal)
        button.backgroundColor = .gray
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.addAction(UIAction { [unowned self] _ in
            getCodeButtonTapped()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        phoneNumberTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(phoneNumberLabel)
        view.addSubview(countryCodeTextField)
        view.addSubview(phoneNumberTextField)
        view.addSubview(infoLabel)
        view.addSubview(getCodeButton)
        
        NSLayoutConstraint.activate([
            phoneNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            countryCodeTextField.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 20),
            countryCodeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            countryCodeTextField.widthAnchor.constraint(equalToConstant: 60),
            
            phoneNumberTextField.topAnchor.constraint(equalTo: countryCodeTextField.topAnchor),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: countryCodeTextField.trailingAnchor, constant: 10),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            infoLabel.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 20),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            getCodeButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            getCodeButton.widthAnchor.constraint(equalToConstant: 319),
            getCodeButton.heightAnchor.constraint(equalToConstant: 50),
            getCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        updateGetCodeButtonState()
    }
    
    @objc private func textFieldDidChange() {
        updateGetCodeButtonState()
    }
    
    private func updateGetCodeButtonState() {
        let isPhoneNumberValid = phoneNumberTextField.text?.count ?? 0 > 9
        getCodeButton.isEnabled = isPhoneNumberValid
        if isPhoneNumberValid {
            getCodeButton.applyGradient()
        } else {
            getCodeButton.backgroundColor = .gray
        }
    }
    
    private func getCodeButtonTapped() {
        guard let phoneNumber = phoneNumberTextField.text else { return }
        let fullPhoneNumber = (countryCodeTextField.text ?? "") + phoneNumber
        
        AuthManager.shared.startAuth(phoneNumber: fullPhoneNumber) { [weak self] success in
            guard success else {
                print("Ошибка при отправке кода")
                return
            }
            DispatchQueue.main.async {
                let verificationVC = VerificationViewController()
                self?.navigationController?.pushViewController(verificationVC, animated: true)
            }
        }
    }
    
}


