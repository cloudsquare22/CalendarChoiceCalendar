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
                EventRowView(event: event)
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

struct EventRowView: View {
    @EnvironmentObject var eventsModel: EventsModel
    let event: EventDispModel
    @State var copyEvent = false

    var body: some View {
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
                        .padding(.leading)
                        .foregroundColor(.primary)
                    Spacer()
                }
            })
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .sheet(isPresented: self.$copyEvent, content: {
            CopyEventView(event: event)
                .environmentObject(self.eventsModel)
        })
    }
}
