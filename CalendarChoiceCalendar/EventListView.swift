//
//  EventListView.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/24.
//

import SwiftUI

struct EventListView: View {
    @State var eventList: [EventDispModel]
    let title: String

    var body: some View {
        List {
            ForEach(self.eventList) { event in
                VStack(alignment: .leading, spacing: 8.0) {
                    HStack {
                        if event.isAllDay == true {
                            Text(EventsModel.dateDisp(date: event.startDate) + " Allday")
                        }
                        else if event.eventTitle != "" {
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
        .padding(8)
        .navigationBarTitle(title, displayMode: .inline)
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView(eventList: [], title: "Calendar")
    }
}
