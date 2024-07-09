//
//  NoCodeViewController.swift
//  PhoneAuth
//
//  Created by Guselnikov Gordey on 25.06.24.
//

import UIKit

class NoCodeViewController: UIViewController {
    
    private let noCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "Не пришел код?"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contactSupportLabel: UILabel = {
        let label = UILabel()
        label.text = "Не пришел код?\nОбратитесь в чат\nподдержки"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(noCodeLabel)
        view.addSubview(contactSupportLabel)
        
        NSLayoutConstraint.activate([
            noCodeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            noCodeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            contactSupportLabel.widthAnchor.constraint(equalToConstant: 200),
            contactSupportLabel.topAnchor.constraint(equalTo: noCodeLabel.bottomAnchor, constant: 20),
            contactSupportLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
