//
//  UIApplication.swift
//  SwiftfulCrypto
//
//  Created by Ravikanth Thummala on 7/8/23
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
