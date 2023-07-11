//
//  PortfolioDataServices.swift
//  CryptoCoin
//
//  Created by Ravikanth Thummala on 7/10/23.
//

import Foundation
import CoreData

class PortfolioDataServices {
    
    private let container: NSPersistentContainer
    private let containerName:String = "PortfolioContainer"
    private let entityName:String = "PortfolioEntity"
    
    @Published var saveEntities:[PortfolioEntity] = []
    
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getPortfolio()
        }
    }
    
    // MARK: PUBLIC
    
    func updatPortfolio(coin:CoinModel,amount:Double){
        if let entity = saveEntities.first(where: {$0.coinID == coin.id}){
            if amount > 0 {
                update(entity: entity, amount: amount)
            }else{
                delete(entity: entity)
            }
        }else{
            add(coin: coin, amount: amount)
        }
        
    }
    
    // MARK: Private
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            saveEntities = try container.viewContext.fetch(request)
        }catch let error{
            print("Error fetching Portfoilio Entites\(error)")
        }
    }
    
    private func add(coin:CoinModel,amount:Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChange()
    }
    
    private func update(entity:PortfolioEntity,amount:Double) {
        entity.amount = amount
        applyChange()
    }

    private func delete(entity:PortfolioEntity){
        container.viewContext.delete(entity)
        applyChange()
    }

    private func save(){
        do{
            try container.viewContext.save()
        }
        catch let error {
            print("Error saing to Core Data. \(error)")
        }
    }
    
    private func applyChange(){
        save()
        getPortfolio()
    }
}
