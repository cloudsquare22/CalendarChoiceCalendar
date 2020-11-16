//
//  MainView.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/04.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var eventsModel: EventsModel
    @State private var selection = 1
    
    var body: some View {
        TabView(selection: $selection) {
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(0)
            NextEventView()
                .tabItem {
                    Image(systemName: "deskclock")
                    Text("Next Event")
                }
                .tag(1)
            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }
                .tag(2)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(EventsModel())
    }
}
