//
//  SettingView.swift
//  CryptoCoin
//
//  Created by Ravikanth Thummala on 7/12/23.
//

import SwiftUI

struct SettingView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com")!
    let coffeeURL = URL(string: "https://www.buymeacoffee.com")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    let personalURL = URL(string: "https://github.com/ravikanththummala")!
    
    var body: some View {
        NavigationView {
            List{
                swiftUIThinkingSection
                coinGeckoSection
                devloperSection
                appSection
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

extension SettingView {
    private var swiftUIThinkingSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following @SwiftUIThinking, course on Youtube. Its uses MVVM, Combine and CoreData")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Subscribe on Youtube 🤩", destination: youtubeURL)
            Link("Support his coffee addiction ☕️", destination: coffeeURL)

            
            
        } header: {
            Text("SwiftUI Thinking")
        }
    }
    private var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The crpto currency data that is used in this app comes from free API from Coingecko.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit CoinGeco 🤩", destination: coingeckoURL)
            
        } header: {
            Text("CoinGecko")
        }
    }
    
    private var devloperSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This App was developed my Me . Its uses SwiftUI and is written 100% in swift.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit Website 🤩", destination: personalURL)
            
        } header: {
            Text("Developer ")
        }
    }
    
    private var appSection: some View {
        Section {
            Link("Terms if Service 🤩", destination: defaultURL)
            Link("Privacy Policy 🤩", destination: defaultURL)
            Link("Company Website 🤩", destination: defaultURL)
            Link("Learn more 🤩", destination: defaultURL)


        } header: {
            Text("Developer ")
        }
    }

}
