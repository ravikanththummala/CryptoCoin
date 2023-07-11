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
    @Published var isLoading:Bool = false
    @Published var sortOption:SortOption  = .holding
    
    private let coinDataServices = CoinDataServices()
    private let marketDataServices = MarketDataService()
    private let portfolioDataServices = PortfolioDataServices()
    
    private var cancellable = Set<AnyCancellable>()
    
    enum SortOption {
        case rank,rankReversed,holding,holdingReversed,price,priceReversed
        
    }
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        // update all coins
        $searchText
            .combineLatest(coinDataServices.$allCoins,$sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self](returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellable)
        
        $allCoins
            .combineLatest(portfolioDataServices.$saveEntities)
            .map(mapAllCoinstoPortFoilioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portfoilCoins = self.portfolioIfneeded(coins: returnedCoins)
            }
            .store(in: &cancellable)
        
        // Market Data Service
        marketDataServices.$marketData
            .combineLatest($portfoilCoins)
            .map(mapGobalMarketData)
            .sink { [weak self] (returnStats) in
                self?.statistics = returnStats
                self?.isLoading = false
            }
            .store(in: &cancellable)
    }
    
    private func mapAllCoinstoPortFoilioCoins(allCoins:[CoinModel], portfolioCoins:[PortfolioEntity]) -> [CoinModel]{
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioCoins.first(where: {$0.coinID == coin.id}) else { return nil}
                return coin.updateHoldings(amount: entity.amount)
            }
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
    
    private func mapGobalMarketData( marketDataModel: MarketDataModel?,portfolioCoins:[CoinModel]) -> [StatisticModel]{
        var stats:[StatisticModel] = []
        guard let data = marketDataModel else { return stats }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap,percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btDomiance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue =
            portfolioCoins
                .map({ $0.currentHoldingsValue })
                .reduce(0, +)
        
        let previousValue =
            portfolioCoins
                .map { (coin) -> Double in
                    let currentValue = coin.currentHoldingsValue
                    let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                    let previousValue = currentValue / (1 + percentChange)
                    return previousValue
                }
                .reduce(0, +)

        let percentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange)
        stats.append(contentsOf:[
            marketCap,volume,btDomiance,portfolio
        ])
        return stats
    }
    
    func updatePortfolio(coin:CoinModel,amount:Double){
        portfolioDataServices.updatPortfolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        isLoading = true
        coinDataServices.getCoins()
        marketDataServices.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterCoins(text:String,coins:[CoinModel],sortOp:SortOption) -> [CoinModel]{
        
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sortOp, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func sortCoins(sort:SortOption, coins: inout [CoinModel]){
        switch sort {
        case .rank,.holding:
            coins.sort(by: { $0.rank < $1.rank})
        case .rankReversed,.holdingReversed:
            coins.sort(by: { $0.rank > $1.rank})
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice})
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice})
        }
    }
    
    private func portfolioIfneeded(coins:[CoinModel]) -> [CoinModel]{
        
        switch sortOption {
        case .holding:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingReversed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
}
