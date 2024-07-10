//
//  MainViewController.swift
//  PhoneAuth
//
//  Created by Guselnikov Gordey on 25.06.24.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Private Properties
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var sisLabel: UILabel = {
        let label = UILabel()
        label.text = "SIS"
        label.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var chooseYourSecurityLabel: UILabel = {
        let label = UILabel()
        label.text = "Выбери свою безопасность"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        let title = KeychainManager.load(key: "appCode")?.isEmpty == false
            ? "Войти по коду приложения"
            : "Войти по номеру телефона"
        button.setTitle(title, for: .normal)
        button.addAction(UIAction { [unowned self] _ in
            loginButtonTapped()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var noAccountLabel: UILabel = {
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
            registerButtonTapped()
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
    
    // MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Override Methods
    override func viewDidLayoutSubviews() {
        loginButton.applyGradient()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        setupSubview(logoImageView,
                     sisLabel,
                     chooseYourSecurityLabel,
                     loginButton,
                     bottomStackView)
        setupConstraints()
        setupNavigationBar()
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
            
            sisLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 31),
            sisLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            chooseYourSecurityLabel.topAnchor.constraint(equalTo: sisLabel.bottomAnchor, constant: 17),
            chooseYourSecurityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginButton.widthAnchor.constraint(equalToConstant: 319),
            loginButton.heightAnchor.constraint(equalToConstant: 56),
            loginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 559),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -89),
            bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
    
    // MARK: - Private Methods
    private func loginButtonTapped() {
        if let appCodeExists = KeychainManager.load(key: "appCode"), !appCodeExists.isEmpty {
            let appCodeEntryVC = AppCodeEntryViewController()
            navigationController?.pushViewController(appCodeEntryVC, animated: true)
        } else {
            let phoneNumberVC = PhoneNumberViewController()
            phoneNumberVC.title = "Войти"
            navigationController?.pushViewController(phoneNumberVC, animated: true)
        }
    }
    
    private func registerButtonTapped() {
        let phoneNumberVC = PhoneNumberViewController()
        phoneNumberVC.title = "Зарегистрироваться"
        navigationController?.pushViewController(phoneNumberVC, animated: true)
    }

}

private extension MainViewController {
    func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 20)]
        navBarAppearance.setBackIndicatorImage(UIImage(named: "arrow-left"), transitionMaskImage: UIImage(named: "arrow-left"))
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .white
    }
}
