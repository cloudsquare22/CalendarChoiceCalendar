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
                    VStack {
                        HStack {
                            Text(event.startDate.description)
                        }
                        HStack {
                            Text(event.title)
                        }
                    }
                }
            }
            .navigationBarTitle("FC Barcelona", displayMode: .inline)
            .onAppear() {
                print("onApper")
                self.eventsModel.updateEvents()
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
