//
//  AppCodeViewController.swift
//  PhoneAuth
//
//  Created by Guselnikov Gordey on 25.06.24.
//

import UIKit

class AppCodeViewController: UIViewController {
    
    private let createCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "Создайте код приложения"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите код из 4 символов"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "••••"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let confirmCodeTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "••••"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var createCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.backgroundColor = .gray
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.addAction(UIAction { [unowned self] _ in
            createCodeButtonTapped()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Пропустить", for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var appCodeExists: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInitialView()

        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        codeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmCodeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViewBasedOnAuthorization()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(createCodeLabel)
        view.addSubview(instructionLabel)
        view.addSubview(codeTextField)
        view.addSubview(confirmCodeTextField)
        view.addSubview(createCodeButton)
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            createCodeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            createCodeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCodeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            instructionLabel.topAnchor.constraint(equalTo: createCodeLabel.bottomAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            codeTextField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            codeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            codeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            confirmCodeTextField.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 20),
            confirmCodeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmCodeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            createCodeButton.topAnchor.constraint(equalTo: confirmCodeTextField.bottomAnchor, constant: 40),
            createCodeButton.widthAnchor.constraint(equalToConstant: 319),
            createCodeButton.heightAnchor.constraint(equalToConstant: 50),
            createCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            skipButton.topAnchor.constraint(equalTo: createCodeButton.bottomAnchor, constant: 20),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        updateCreateCodeButtonState()
    }
    
    // MARK: - Private Methods
    
    private func setupInitialView() {
        // Check if the user is already authorized with app code
        appCodeExists = KeychainManager.isAuthorizedWithAppCode("")
        updateViewBasedOnAuthorization()
    }
    
    private func updateViewBasedOnAuthorization() {
        if appCodeExists {
            createCodeLabel.isHidden = true
            instructionLabel.isHidden = true
            codeTextField.isHidden = true
            confirmCodeTextField.isHidden = true
            
            createCodeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = false
            createCodeButton.topAnchor.constraint(equalTo: skipButton.bottomAnchor, constant: 40).isActive = true
        } else {
            createCodeLabel.isHidden = false
            instructionLabel.isHidden = false
            codeTextField.isHidden = false
            confirmCodeTextField.isHidden = false
            
            createCodeButton.topAnchor.constraint(equalTo: confirmCodeTextField.bottomAnchor, constant: 40).isActive = true
            createCodeButton.topAnchor.constraint(equalTo: skipButton.bottomAnchor, constant: 20).isActive = false
        }
    }
    
    private func updateCreateCodeButtonState() {
        let isCodeValid = codeTextField.text?.count == 4 && confirmCodeTextField.text?.count == 4
        createCodeButton.isEnabled = isCodeValid
        createCodeButton.backgroundColor = isCodeValid ? UIColor.systemBlue : UIColor.gray
    }
    
    @objc private func textFieldDidChange() {
        updateCreateCodeButtonState()
    }
    
    private func createCodeButtonTapped() {
        guard let code = codeTextField.text, let confirmCode = confirmCodeTextField.text else { return }
        
        if code == confirmCode {
            KeychainManager.save(key: "appCode", value: code)
            appCodeExists = true
            updateViewBasedOnAuthorization()
            
            let accountVC = AccountViewController()
            navigationController?.pushViewController(accountVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Коды не совпадают", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func skipButtonTapped() {
        let accountVC = AccountViewController()
        navigationController?.pushViewController(accountVC, animated: true)
    }
}
