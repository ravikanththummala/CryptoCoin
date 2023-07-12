//
//  ChartView.swift
//  CryptoCoin
//
//  Created by Ravikanth Thummala on 7/11/23.
//

import SwiftUI

struct ChartView: View {
    
    let data:[Double]
    let maxY:Double
    let minY:Double
    let lineColor:Color
    let startDate:Date
    let endDate:Date
    @State private var percentage:CGFloat = 0
    
    init(coin:CoinModel){
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startDate = endDate.addingTimeInterval(7*24*60*60)
        
    }
    
    var body: some View {
        VStack{
            chatView
                .frame(height: 200)
                .background(chartViewHstack)
                .overlay(overLayVStack,alignment: .leading)
            
            chartDate
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView {
    private var chatView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    let yPosition = (1 - (CGFloat(data[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0  ,to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2,lineCap: .round,lineJoin: .round))
            .shadow(color: lineColor, radius: 10,x: 0,y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10,x: 0,y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10,x: 0,y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10,x: 0,y: 40)
        }
    }
    private var chartViewHstack: some View {
        VStack{
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var overLayVStack : some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            let price = (maxY - minY) / 2
            Text(price.formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }.font(.caption)
        
    }
    
    private var chartDate : some View {
        HStack {
            Text(startDate.asShortDateString())
            Spacer()
            Text(endDate.asShortDateString())
        }
    }

}

