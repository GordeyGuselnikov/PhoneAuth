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
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите код из 4 символов"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(red: 28/255, green: 25/255, blue: 44/255, alpha: 1)
        
        let placeholderText = "••••"
        let placeholderFont = UIFont.systemFont(ofSize: 24)
        let placeholderColor = UIColor.gray
        let attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                NSAttributedString.Key.foregroundColor: placeholderColor,
                NSAttributedString.Key.font: placeholderFont
            ]
        )
        textField.attributedPlaceholder = attributedPlaceholder
        
        textField.isSecureTextEntry = true
        
        textField.layer.cornerRadius = 25
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.textColor = .systemCyan
        textField.font = .systemFont(ofSize: 24)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пропустить", for: .normal)
        button.backgroundColor = .gray
        button.tintColor = .white
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addAction(UIAction { [unowned self] _ in
            skipButtonTapped()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var appCodeExists = false
    private var firstCode: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Код приложения"
        setupUI()
        setupInitialView()

        codeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewDidLayoutSubviews() {
        skipButton.applyGradient()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(createCodeLabel)
        view.addSubview(instructionLabel)
        view.addSubview(codeTextField)
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            createCodeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 169),
            createCodeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            instructionLabel.topAnchor.constraint(equalTo: createCodeLabel.bottomAnchor, constant: 47),
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            codeTextField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 36),
            codeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeTextField.widthAnchor.constraint(equalToConstant: 180),
            codeTextField.heightAnchor.constraint(equalToConstant: 52),
            
            skipButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 77),
            skipButton.widthAnchor.constraint(equalToConstant: 319),
            skipButton.heightAnchor.constraint(equalToConstant: 56),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    
    // MARK: - Private Methods
    
    private func setupInitialView() {
        appCodeExists = KeychainManager.isAuthorizedWithAppCode("")
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.count == 4 {
            if firstCode == nil {
                firstCode = text
                textField.text = ""
                instructionLabel.text = "Подтвердите код"
            } else {
                validateCodes()
            }
        }
    }
    
    private func validateCodes() {
        guard let code = firstCode, let confirmCode = codeTextField.text else { return }
        
        if code == confirmCode {
            KeychainManager.save(key: "appCode", value: code)
            appCodeExists = true
            let accountVC = AccountViewController()
            navigationController?.pushViewController(accountVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Коды не совпадают", preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(title: "ОК", style: .default, handler: { _ in
                self.resetCodeEntry()
            }))
            present(alert, animated: true)
        }
    }
    
    private func resetCodeEntry() {
        firstCode = nil
        codeTextField.text = ""
        instructionLabel.text = "Введите код из 4 символов"
        skipButton.isHidden = false
    }
    
    private func skipButtonTapped() {
        let accountVC = AccountViewController()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(accountVC, animated: true)
    }
}
