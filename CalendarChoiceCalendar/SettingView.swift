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
        List {
            Section(header: Text("About")) {
                VStack {
                    Text("neCal")
                        .font(.title)
                    Text("Version \(version)")
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
