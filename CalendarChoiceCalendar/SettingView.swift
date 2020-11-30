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
                    HStack {
                        Spacer()
                        VStack(){
                            Image("neCal")
                                .resizable()
                                .scaledToFit()
                            Text("neCal")
                                .font(.largeTitle)
                            Text("Version \(version)")
                        }
                        Spacer()
                    }
                }
            }
//            .padding(8)
            .navigationBarTitle("Setting", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
