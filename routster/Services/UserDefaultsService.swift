//
//  UserDefaultsService.swift
//  routster
//
//  Created by codefuse on 07.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import DefaultsKit
import CryptoSwift

class UserDefaultsService {
    
    // MARK: - Keys
    private static let emailKey = Key<[UInt8]>("email")
    private static let idKey = Key<[UInt8]>("id")
    private static let passwordKey = Key<[UInt8]>("password")
    
    private static let k3y = "passwordpassword"
    private static let iv = "drowssapdrowssap"
    
    // MARK: - Properties
    public class var email: String? /* user generated */ {
        get {
            guard let cipher = Defaults.shared.get(for: UserDefaultsService.emailKey) else { return nil }
            do {
                let value = try AES(key: UserDefaultsService.k3y, iv: UserDefaultsService.iv).decrypt(cipher)
                
                return String(bytes: value, encoding: .utf8)
            } catch {
                // MARK: - error handling
            }
            
            return nil
        }
        set(newValue) {
            if let newValue = newValue {
                do {
                    let cipher = try AES(key: UserDefaultsService.k3y, iv: UserDefaultsService.iv).encrypt(Array(newValue.utf8))
                    Defaults.shared.set(cipher, for: UserDefaultsService.emailKey)
                } catch {
                    // MARK: - error handling
                }
            } else {
                Defaults.shared.clear(UserDefaultsService.emailKey)
            }
        }
    }
    
    public class var id: String? /* api generated */ {
        get {
            guard let cipher = Defaults.shared.get(for: UserDefaultsService.idKey) else { return nil }
            do {
                let value = try AES(key: UserDefaultsService.k3y, iv: UserDefaultsService.iv).decrypt(cipher)
                
                return String(bytes: value, encoding: .utf8)
            } catch {
                // MARK: - error handling
            }
            
            return nil
        }
        set(newValue) {
            if let newValue = newValue {
                do {
                    let cipher = try AES(key: UserDefaultsService.k3y, iv: UserDefaultsService.iv).encrypt(Array(newValue.utf8))
                    Defaults.shared.set(cipher, for: UserDefaultsService.idKey)
                } catch {
                    // MARK: - error handling
                }
            } else {
                Defaults.shared.clear(UserDefaultsService.idKey)
            }
        }
    }
    
    public class var password: String? /* api generated */ {
        get {
            guard let cipher = Defaults.shared.get(for: UserDefaultsService.passwordKey) else { return nil }
            do {
                let value = try AES(key: UserDefaultsService.k3y, iv: UserDefaultsService.iv).decrypt(cipher)
                
                return String(bytes: value, encoding: .utf8)
            } catch {
                // MARK: - error handling
            }
            
            return nil
        }
        set(newValue) {
            if let newValue = newValue {
                do {
                    let cipher = try AES(key: UserDefaultsService.k3y, iv: UserDefaultsService.iv).encrypt(Array(newValue.utf8))
                    Defaults.shared.set(cipher, for: UserDefaultsService.passwordKey)
                } catch {
                    // MARK: - error handling
                }
            } else {
                Defaults.shared.clear(UserDefaultsService.passwordKey)
            }
        }
    }
}
