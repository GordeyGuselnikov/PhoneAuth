//
//  SMSCodeViewController.swift
//  PhoneAuth
//
//  Created by Guselnikov Gordey on 24.06.24.
//

import UIKit

class VerificationViewController: UIViewController, UITextFieldDelegate {
    
    private var codeTextFields: [UITextField] = []
    
    private let verificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Верификация"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите код из смс, что мы отправили вам"
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var verifyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.backgroundColor = .gray
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.addAction(UIAction { [unowned self] _ in
            verifyButtonTapped()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let noCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Я не получил код!", for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [verificationLabel, instructionLabel, codeTextField])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview(mainStackView, verifyButton, noCodeButton)
        setupUI()
        noCodeButton.addTarget(self, action: #selector(noCodeButtonTapped), for: .touchUpInside)
        codeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 168),
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            verifyButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 40),
            verifyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            verifyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            verifyButton.heightAnchor.constraint(equalToConstant: 50),
            
            noCodeButton.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 20),
            noCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            codeTextField.widthAnchor.constraint(equalToConstant: 100),
            codeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        updateVerifyButtonState()
    }
    
    private func setupSubview(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    @objc private func textFieldDidChange() {
        updateVerifyButtonState()
    }
    
    private func updateVerifyButtonState() {
        let isCodeValid = codeTextField.text?.count ?? 0 == 6
        verifyButton.isEnabled = isCodeValid
        if isCodeValid {
            verifyButton.applyGradient()
        } else {
            verifyButton.backgroundColor = .gray
        }
    }

    private func verifyButtonTapped() {
        guard let verificationCode = codeTextField.text else { return }
        
        AuthManager.shared.verifyCode(smsCode: verificationCode) { [weak self] success in
            guard success else {
                print("Ошибка при верификации кода")
                return
            }
            DispatchQueue.main.async {
                let appCodeVC = AppCodeViewController()
                self?.navigationController?.pushViewController(appCodeVC, animated: true)
            }
        }
    }
    
    @objc private func noCodeButtonTapped() {
        let noCodeVC = NoCodeViewController()
        navigationController?.pushViewController(noCodeVC, animated: true)
    }
}
