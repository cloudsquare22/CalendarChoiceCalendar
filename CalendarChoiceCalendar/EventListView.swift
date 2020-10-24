//
//  EventListView.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/24.
//

import SwiftUI

struct EventListView: View {
    @EnvironmentObject var eventsModel: EventsModel
    let title: String

    var body: some View {
        NavigationView {
            List {
                ForEach(self.eventsModel.calendarEventList) { event in
                    VStack {
                        HStack {
                            Text(event.calendar.title)
                                .foregroundColor(Color(event.calendar.cgColor))
                            Spacer()
                        }
                        HStack {
                            if event.eventTitle != "" {
                                Text(EventsModel.dateDisp(date: event.startDate))
                            }
                            else {
                                Text("-")
                            }
                            Spacer()
                        }
                        HStack {
                            if event.eventTitle != "" {
                                Text(event.eventTitle)
                            }
                            else {
                                Text("No event.")
                            }
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle(title, displayMode: .inline)
        }
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView(title: "Calendar")
            .environmentObject(EventsModel())
    }
}
