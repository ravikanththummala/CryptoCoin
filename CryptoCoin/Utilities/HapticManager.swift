//
//  HapticManager.swift
//  CryptoCoin
//
//  Created by Ravikanth Thummala on 7/10/23.
//

import Foundation
import SwiftUI

class HapticManager{
    
    static let generator = UINotificationFeedbackGenerator()
    
    static func notification(type:UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
