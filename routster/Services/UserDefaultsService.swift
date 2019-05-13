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
    private (set) class var email: String? /* user generated */ {
        get {
            guard let cipher = Defaults.shared.get(for: UserDefaultsService.emailKey) else { return nil }
            
            do {
                let value = try AES(key: UserDefaultsService.k3y, iv: UserDefaultsService.iv).decrypt(cipher)
                
                return String(bytes: value, encoding: .utf8)
            } catch {
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                Defaults.shared.clear(UserDefaultsService.emailKey)
                return
            }
            
            do {
                let cipher = try AES(key: UserDefaultsService.k3y, iv: UserDefaultsService.iv).encrypt(Array(newValue.utf8))
                Defaults.shared.set(cipher, for: UserDefaultsService.emailKey)
            } catch {
                // MARK: - error handling
            }
        }
    }
    
    private (set) class var id: String? /* api generated */ {
        get {
            guard let cipher = Defaults.shared.get(for: UserDefaultsService.idKey) else { return nil }
            
            do {
                let value = try AES(key: UserDefaultsService.k3y, iv: UserDefaultsService.iv).decrypt(cipher)
                
                return String(bytes: value, encoding: .utf8)
            } catch {
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                Defaults.shared.clear(UserDefaultsService.idKey)
                return
            }
            
            do {
                let cipher = try AES(key: UserDefaultsService.k3y, iv: UserDefaultsService.iv).encrypt(Array(newValue.utf8))
                Defaults.shared.set(cipher, for: UserDefaultsService.idKey)
            } catch {
                // MARK: - error handling
            }
        }
    }
    
    private (set) class var password: String? /* api generated */ {
        get {
            guard let cipher = Defaults.shared.get(for: UserDefaultsService.passwordKey) else { return nil }
            
            do {
                let value = try AES(key: UserDefaultsService.k3y, iv: UserDefaultsService.iv).decrypt(cipher)
                
                return String(bytes: value, encoding: .utf8)
            } catch {
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                Defaults.shared.clear(UserDefaultsService.passwordKey)
                return
            }

            do {
                let cipher = try AES(key: UserDefaultsService.k3y, iv: UserDefaultsService.iv).encrypt(Array(newValue.utf8))
                Defaults.shared.set(cipher, for: UserDefaultsService.passwordKey)
            } catch {
                // MARK: - error handling
            }
        }
    }
    
    // MARK: -
    public class func removeUserInformation() {
        UserDefaultsService.id = nil
        UserDefaultsService.password = nil
        UserDefaultsService.email = nil
    }
    
    public class func storeUserInformation(email: String, username: String, password: String) {
        UserDefaultsService.email = email
        UserDefaultsService.id = username
        UserDefaultsService.password = password
    }
}
