//
//  MainView.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/04.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var eventsModel: EventsModel
    
    var body: some View {
        TabView {
            NextEventView()
                .tabItem {
                    Image(systemName: "deskclock")
                    Text("Next Event")
                }
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            Text("Setting")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(EventsModel())
    }
}
