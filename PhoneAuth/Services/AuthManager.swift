//
//  AuthManager.swift
//  PhoneAuth
//
//  Created by Guselnikov Gordey on 24.06.24.
//

import FirebaseAuth
import Foundation

class AuthManager {
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    private var verificationId: String?
    
    public func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
            guard let verificationId = verificationId, error == nil else {
                completion(false)
                return
            }
            self?.verificationId = verificationId
            completion(true)
        }
    }
    
    public func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        guard let verificationId = verificationId else {
            completion(false)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: smsCode
        )
        
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func exit(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            print("Ошибка при выходе из аккаунта: \(error.localizedDescription)")
            completion(false)
        }
    }
}
