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
        NavigationView {
            List {
                ForEach(self.eventsModel.events, id: \.self) { event in
                    HStack {
                        Text(event.title)
                    }
                }
            }
            .navigationTitle("Choice Calendar")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(EventsModel())
    }
}
