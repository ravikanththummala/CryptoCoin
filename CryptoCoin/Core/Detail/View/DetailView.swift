//
//  DetailView.swift
//  CryptoCoin
//
//  Created by Ravikanth Thummala on 7/10/23.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack{
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    @State private var shoeFullDecriotion : Bool = false
    private let columns:[GridItem] = [
        
        GridItem(.flexible()),
        GridItem(.flexible())
        
    ]
    private let spacing:CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView{
            VStack{
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing: 20){
                    overViewatitle
                    Divider()
                    overViewTex
                    overgrid
                    addViewatitle
                    Divider()
                    addgrid
                    webSite
                }
            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationTralingItem
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}

extension DetailView {
    
    private var overViewatitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var addViewatitle: some View {
        Text("Addtional Deatils")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var overgrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: nil,
                  pinnedViews: []) {
            
            ForEach(vm.overviewStatistics) { stats in
                StatisticView(stat: stats)
            }
            
        }
    }
    
    private var addgrid: some View {
        
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: nil,
                  pinnedViews: []) {
            
            ForEach(vm.additionalStatistics) { addStat in
                StatisticView(stat: addStat)
            }
            
        }
    }
    
    private var navigationTralingItem: some View {
        HStack{
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overViewTex: some View {
        
        ZStack {
            if let coinDescription = vm.coinDescription,!coinDescription.isEmpty{
                VStack {
                    Text(coinDescription)
                        .lineLimit(shoeFullDecriotion ? nil: 3)
                    Button {
                        withAnimation(.easeInOut) {
                            shoeFullDecriotion.toggle()
                        }
                    } label: {
                        Text(shoeFullDecriotion ? "Less ": "Read more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical,4)
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .accentColor(.blue)
                    
                }
                .frame(width: .infinity,alignment: .leading)
                
                
            }
        }
        
    }
    
    private var webSite: some View {
        VStack(alignment: .leading,spacing: 20) {
            if let websiteString = vm.websiteURL {
                let ur = URL(string: websiteString)
                Link("Website", destination: ur!)
            }
            
            if let redditString = vm.redditURL {
                let ur = URL(string: redditString)
                Link("Reddit", destination: ur!)
            }
        }
        .accentColor(.blue)
        .frame(width: .infinity,alignment: .leading)

    }
    
}
