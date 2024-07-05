//
//  Extension + UIView.swift
//  PhoneAuth
//
//  Created by Guselnikov Gordey on 25.06.24.
//

import UIKit

extension UIView {
    
    func applyGradient() {
        let colors = [UIColor(red: 147/255, green: 88/255, blue: 247/255, alpha: 1),
                      UIColor(red: 123/255, green: 120/255, blue: 242/255, alpha: 1),
                      UIColor(red: 97/255, green: 151/255, blue: 238/255, alpha: 1),
                      UIColor(red: 69/255, green: 181/255, blue: 233/255, alpha: 1),
                      UIColor(red: 16/255, green: 215/255, blue: 226/255, alpha: 1),
        ]
        let startPoint = CGPoint(x: 0, y: 1)
        let endPoint = CGPoint(x: 1, y: 0)
        
        // Remove existing gradient layers
        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        // Ensure the gradient layer resizes properly with the button
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
