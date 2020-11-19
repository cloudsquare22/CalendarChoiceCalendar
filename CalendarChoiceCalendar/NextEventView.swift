//
//  NextEventView.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/19.
//

import SwiftUI

struct NextEventView: View {
    @EnvironmentObject var eventsModel: EventsModel

    var body: some View {
        NavigationView {
            List {
                ForEach(self.eventsModel.nextEvents) { event in
                    if event.isOn == true {
                        NavigationLink(
                            destination: EventListView(eventList: self.eventsModel.getEventList(calendar: event.calendar), title: event.calendar.title)) {
                            VStack(alignment: .leading, spacing: 8.0) {
                                HStack {
                                    Text(event.calendar.title)
                                        .foregroundColor(Color(event.calendar.cgColor))
                                    Spacer()
                                }
                                HStack {
                                    if event.eventTitle != "" {
                                        Text(EventsModel.dateDisp(date: event.startDate, isAllDay: event.isAllDay))
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
                }
            }
            .padding(8)
            .navigationBarTitle("Next Event", displayMode: .inline)
            .navigationBarItems(trailing: Image(systemName: "arrow.counterclockwise")
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        self.eventsModel.updateNextEvents()
                                    })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NextEventView_Previews: PreviewProvider {
    static var previews: some View {
        NextEventView()
            .environmentObject(EventsModel())
    }
}
