//
//  CoinImageViewModel.swift
//  CryptoCoin
//
//  Created by Ravikanth Thummala on 7/9/23.
//

import Foundation
import SwiftUI
import Combine


class CoinImageViewModel:ObservableObject {
    
    @Published var image:UIImage? = nil
    @Published var isLoading:Bool = false
    
    private let coin: CoinModel
    private let dataService:CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin:CoinModel){
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers(){
        dataService.$image
            .sink { [weak self](_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnImage) in
                self?.image = returnImage
            }
            .store(in: &cancellables)
    }
}
