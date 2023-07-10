//
//  HomeStatsView.swift
//  CryptoCoin
//
//  Created by Ravikanth Thummala on 7/9/23.
//

import SwiftUI

struct HomeStatsView: View {
   
    @EnvironmentObject private var vm:HomeViewModel
    
    @Binding var showPortfoilo:Bool
    
    var body: some View {
        HStack{
            ForEach(vm.statistics) { stats in
                StatisticView(stat: stats)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width,alignment: showPortfoilo ? .trailing : .leading)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortfoilo: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
