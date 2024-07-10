//
//  SMSCodeViewController.swift
//  PhoneAuth
//
//  Created by Guselnikov Gordey on 24.06.24.
//

import UIKit

final class VerificationViewController: UIViewController {
    // MARK: - Private Properties
    private var timer: DispatchSourceTimer?
    private var remainingTime = 5 * 60
    
    private lazy var verificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Верификация"
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите код из смс,\nчто мы отправили вам\n"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countdownLabel: UILabel = {
        let label = UILabel()
        label.text = "Запросить код можно через 05:00"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var codeTextFields: [UITextField] = {
        var textFields = [UITextField]()
        for i in 0..<6 {
            let textField = createCodeTextField()
            textField.tag = i
            textField.delegate = self
            textFields.append(textField)
        }
        return textFields
    }()
    
    private lazy var verifyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.backgroundColor = .gray
        button.tintColor = .white
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addAction(UIAction { [unowned self] _ in
            verifyButtonTapped()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var noCodeButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(
            string: "Я не получил код!",
            attributes: attributes
        )
        button.setAttributedTitle(attributeString, for: .normal)
        
        button.addAction(UIAction { [unowned self] _ in
            noCodeButtonTapped()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var codeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: codeTextFields)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [verificationLabel, instructionLabel, countdownLabel, codeStackView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        codeTextFields.forEach { $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged) }
        startTimer()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        setupSubview(mainStackView, verifyButton, noCodeButton)
        setupConstraints()
        updateVerifyButtonState()
    }
    
    private func setupSubview(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 168),
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            verifyButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 28),
            verifyButton.widthAnchor.constraint(equalToConstant: 319),
            verifyButton.heightAnchor.constraint(equalToConstant: 56),
            verifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            noCodeButton.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 31),
            noCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func createCodeTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.keyboardType = .phonePad
        textField.textAlignment = .center
        textField.textColor = .white
        textField.layer.borderWidth = 0.6
        textField.layer.borderColor = UIColor.systemCyan.cgColor
        textField.layer.cornerRadius = 4
        textField.font = .systemFont(ofSize: 19)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalToConstant: 46).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 46).isActive = true
        return textField
    }
    
    // MARK: - Private Methods
    @objc private func textFieldDidChange() {
        updateVerifyButtonState()
    }
    
    private func updateVerifyButtonState() {
        let isCodeValid = codeTextFields.allSatisfy { $0.text?.count == 1 }
        verifyButton.isEnabled = isCodeValid
        if isCodeValid {
            verifyButton.applyGradient()
        } else {
            verifyButton.backgroundColor = .gray
        }
    }

    private func verifyButtonTapped() {
        let verificationCode = codeTextFields.compactMap { $0.text }.joined()
        
        AuthManager.shared.verifyCode(smsCode: verificationCode) { [weak self] success in
            guard success else {
                print("Ошибка при верификации кода")
                return
            }
            DispatchQueue.main.async {
                let appCodeVC = AppCodeViewController()
                self?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                self?.navigationController?.pushViewController(appCodeVC, animated: true)
            }
        }
    }
    
    private func noCodeButtonTapped() {
        let noCodeVC = NoCodeViewController()
        navigationController?.pushViewController(noCodeVC, animated: true)
    }
    
    // MARK: - Timer
    private func startTimer() {
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(), repeating: 1.0)
        timer?.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.updateCountdown()
            }
        }
        timer?.resume()
    }
    
    private func updateCountdown() {
        if remainingTime > 0 {
            remainingTime -= 1
            countdownLabel.text = formatTime(remainingTime)
        } else {
            timer?.cancel()
            countdownLabel.text = "Время истекло"
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "Запросить код можно\nчерез %02d:%02d\n", minutes, seconds)
    }
}

// MARK: - UITextFieldDelegate
extension VerificationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if newText.count == 1 {
            let nextTag = textField.tag + 1
            if nextTag < codeTextFields.count {
                codeTextFields[nextTag].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            textField.text = newText
            updateVerifyButtonState()
            return false
        } else if newText.isEmpty {
            let prevTag = textField.tag - 1
            if prevTag >= 0 {
                codeTextFields[prevTag].becomeFirstResponder()
            }
            textField.text = ""
            updateVerifyButtonState()
            return false
        } else {
            textField.text = String(newText.prefix(1))
            updateVerifyButtonState()
            return false
        }
    }
}
