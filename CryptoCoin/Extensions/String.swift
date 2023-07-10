//
//  String.swift
//  SwiftfulCrypto
//
//  Created by Ravikanth Thummala on 7/8/23 

import Foundation

extension String {
    
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
