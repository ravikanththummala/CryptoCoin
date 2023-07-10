//
//  HomeViewModel.swift
//  CryptoCoin
//
//  Created by Ravikanth Thummala on 7/9/23.
//

import Foundation
import Combine
class HomeViewModel: ObservableObject {
    
    @Published var statistics:[StatisticModel] = []
    
    @Published var allCoins:[CoinModel] = []
    @Published var portfoilCoins:[CoinModel] = []
    @Published var searchText:String = ""
    
    private let coinDataServices = CoinDataServices()
    private let marketDataServices = MarketDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        // update all coins
        $searchText
            .combineLatest(coinDataServices.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self](returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellable)
        
        // Market Data Service
        marketDataServices.$marketData
            .map(mapGobalMarketData)
            .sink { [weak self] (returnStats) in
                self?.statistics = returnStats
            }
            .store(in: &cancellable)
    }
    
    private func filterCoins(text:String,coins:[CoinModel]) -> [CoinModel]{
        guard !text.isEmpty else { return coins}
        
        let lowerCaseText = text.lowercased()
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowerCaseText) ||
            coin.symbol.lowercased().contains(lowerCaseText) ||
            coin.id.lowercased().contains(lowerCaseText)
        }
    }
    
    private func mapGobalMarketData( marketDataModel: MarketDataModel?) -> [StatisticModel]{
        var stats:[StatisticModel] = []
        guard let data = marketDataModel else { return stats }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap,percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btDomiance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfoilo = StatisticModel(title: "Portfolio value", value: "$0.0",percentageChange: 0)
        stats.append(contentsOf:[
            marketCap,volume,btDomiance,portfoilo
        ])
        return stats
    }
}
