//
//  SettingView.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/11/17.
//

import SwiftUI

struct SettingView: View {
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("About")) {
                    VStack {
                        HStack {
                            Spacer()
                            Image("neCal")
                                .cornerRadius(16)
                                .padding(8.0)
                            VStack(){
                                Text("neCal")
                                    .font(.largeTitle)
                                Text("Version \(version)")
                            }
                            .padding(8.0)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Image("cloudsquare")
                            Text("©️ 2021 cloudsquare.jp")
                                .font(.footnote)
                            Spacer()
                        }
                    }
                }
            }
//            .padding(8)
            .navigationTitle("Setting")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
