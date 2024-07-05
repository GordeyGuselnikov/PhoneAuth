//
//  MainViewController.swift
//  PhoneAuth
//
//  Created by Guselnikov Gordey on 25.06.24.
//

import UIKit

class MainViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let sisLabel: UILabel = {
        let label = UILabel()
        label.text = "SIS"
        label.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chooseYourSecurityLabel: UILabel = {
        let label = UILabel()
        label.text = "Выбери свою безопасность"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginWithAppCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти по коду приложения", for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.addAction(UIAction { [unowned self] _ in
            loginWithAppCodeButtonTapped()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loginWithPhoneNumberButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти по номеру телефона", for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.addAction(UIAction { [unowned self] _ in
            loginWithPhoneNumberButtonTapped()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let noAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас нет аккаунта?"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(
            string: "Зарегистрируйтесь сейчас",
            attributes: attributes
        )
        button.setAttributedTitle(attributeString, for: .normal)
        
        button.addAction(UIAction { [unowned self] _ in
            loginWithPhoneNumberButtonTapped()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [noAccountLabel, registerButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupSubview(logoImageView,
                     sisLabel,
                     chooseYourSecurityLabel,
                     loginWithAppCodeButton,
                     loginWithPhoneNumberButton,
                     bottomStackView)
        determineNextScreen()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        loginWithAppCodeButton.applyGradient()
        loginWithPhoneNumberButton.applyGradient()

    }
    
    private func setupSubview(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 265),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            sisLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            sisLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            chooseYourSecurityLabel.topAnchor.constraint(equalTo: sisLabel.bottomAnchor, constant: 17),
            chooseYourSecurityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginWithAppCodeButton.widthAnchor.constraint(equalToConstant: 319),
            loginWithAppCodeButton.heightAnchor.constraint(equalToConstant: 50),
            loginWithAppCodeButton.topAnchor.constraint(equalTo: chooseYourSecurityLabel.bottomAnchor, constant: 100),
            loginWithAppCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginWithPhoneNumberButton.widthAnchor.constraint(equalToConstant: 319),
            loginWithPhoneNumberButton.heightAnchor.constraint(equalToConstant: 50),
            loginWithPhoneNumberButton.topAnchor.constraint(equalTo: chooseYourSecurityLabel.bottomAnchor, constant: 100),
            loginWithPhoneNumberButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -89),
            bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
    
    private func determineNextScreen() {
        if let appCodeExists = KeychainManager.load(key: "appCode"), !appCodeExists.isEmpty {
            // Есть сохраненный код приложения
            loginWithAppCodeButton.isHidden = false
            loginWithPhoneNumberButton.isHidden = true
        } else {
            // Нет сохраненного кода приложения
            loginWithAppCodeButton.isHidden = true
            loginWithPhoneNumberButton.isHidden = false
        }
    }
    
    private func loginWithPhoneNumberButtonTapped() {
        let phoneNumberVC = PhoneNumberViewController()
        navigationController?.pushViewController(phoneNumberVC, animated: true)
    }
    
    private func loginWithAppCodeButtonTapped() {
        let appCodeEntryVC = AppCodeEntryViewController()
        navigationController?.pushViewController(appCodeEntryVC, animated: true)
    }

}
