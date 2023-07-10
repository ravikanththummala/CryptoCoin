//
//  CryptoCoinApp.swift
//  CryptoCoin
//
//  Created by Ravikanth Thummala on 7/8/23.
//

import SwiftUI

@main
struct CryptoCoinApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .environmentObject(vm)
        }
    }
}
