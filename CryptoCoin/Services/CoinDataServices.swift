//
//  CoinDataServices.swift
//  CryptoCoin
//
//  Created by Ravikanth Thummala on 7/9/23.
//

import Foundation
import Combine

class CoinDataServices{
    
    @Published var allCoins:[CoinModel] = []
    var coinSubscription: AnyCancellable?
    
    
    init(){
        getCoins()
    }
    
    private func getCoins(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {
            return
        }
        
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnCoins in
                self?.allCoins = returnCoins
                self?.coinSubscription?.cancel()
            })
    }
}
