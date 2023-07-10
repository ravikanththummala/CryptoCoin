//
//  PortfolioView.swift
//  CryptoCoin
//
//  Created by Ravikanth Thummala on 7/9/23.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm:HomeViewModel
    @State private var selectedCoin:CoinModel? = nil
    @State private var quantityText:String = ""
    @State private var showCheckMark:Bool = false
    

    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading,spacing: 0){
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil{
                        portfolioInput
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingBarButtonView
                }

            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView{
    
    private var coinLogoList: some View{
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth:1)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }

    }
    
    
    private func getCurrentValue() -> Double {
        if let quality = Double(quantityText) {
            return quality * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var portfolioInput: some View {
        VStack(spacing: 20) {
            HStack{
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? "" ):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Amount holding:")
                Spacer()
                TextField("Ex:1.4",text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                
                
            }
            Divider()
            HStack{
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none, value: 100)
        .padding()
        .font(.headline)

    }
    
    private var trailingBarButtonView: some View{
        HStack(spacing: 10){
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            
            Button {
                saveButtonPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0: 0.0)
        }
        .font(.headline)
    }
    
    private func saveButtonPressed(){
        guard let coin = selectedCoin else { return }
        
        // Save to portfolio
        
        // show checkmark
        withAnimation(.easeIn) {
            showCheckMark = true
            removedSelectedCoin()
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            showCheckMark = false
        }
    }
    
    private func removedSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
}
