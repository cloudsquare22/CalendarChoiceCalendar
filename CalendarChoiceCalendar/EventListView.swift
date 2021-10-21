//
//  EventListView.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/24.
//

import SwiftUI

struct EventListView: View {
    @EnvironmentObject var eventsModel: EventsModel
    @State var eventList: [EventDispModel]
    @State var copyEvent = false
    let title: String

    var body: some View {
        List {
            ForEach(self.eventList) { event in
                VStack(alignment: .leading, spacing: 8.0) {
                    Button(action: {
                        self.copyEvent.toggle()
                    }, label: {
                        HStack {
                            Text(EventsModel.dateDisp(date: event.startDate, isAllDay: event.isAllDay))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        HStack {
                            Text(event.eventTitle)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                    })
                }
                .sheet(isPresented: self.$copyEvent, content: {
                    CopyEventView(event: event).environmentObject(self.eventsModel)
                })
            }
        }
        .listStyle(PlainListStyle())
//        .padding(8)
        .navigationTitle(self.title)
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView(eventList: [], title: "Calendar")
    }
}
