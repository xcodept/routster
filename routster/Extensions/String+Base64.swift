//
//  String+Base64.swift
//  routster
//
//  Created by codefuse on 06.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
