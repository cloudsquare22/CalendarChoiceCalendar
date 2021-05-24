//
//  NextEventView.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/19.
//

import SwiftUI
import EventKit

struct NextEventView: View {
    @EnvironmentObject var eventsModel: EventsModel
    @State var openSheet: Bool = false
    @State var sheetCalendar: EKCalendar? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(self.eventsModel.nextEvents) { event in
                    if event.isOn == true {
                        if event.eventTitle.isEmpty == false {
                            EventView(event: event)
                        }
                        else {
                            EmptyEventView(event: event)
                        }
                    }
                }
            }
            .padding(8)
            .navigationBarTitle("Next Event", displayMode: .inline)
            .navigationBarItems(trailing: Image(systemName: "arrow.triangle.2.circlepath")
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        self.eventsModel.updateNextEvents()
                                    })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onOpenURL(perform: { url in
            print(#function + ":\(url)")
            if url.absoluteString != "necal://" {
                self.sheetCalendar = self.eventsModel.getEKCakendar(calendarIdentifier: url.absoluteString.replacingOccurrences(of: "necal://", with: ""))
                self.openSheet.toggle()
            }
        })
        .sheet(isPresented: self.$openSheet, content: {
            if let calendar = self.sheetCalendar {
                NavigationView {
                    EventListView(eventList: self.eventsModel.getEventList(calendars: [calendar]), title: calendar.title)

                }
            }
        })
    }
}

struct NextEventView_Previews: PreviewProvider {
    static var previews: some View {
        NextEventView()
            .environmentObject(EventsModel())
    }
}

struct EventView: View {
    @EnvironmentObject var eventsModel: EventsModel
    let event: EventDispModel
    
    var body: some View {
        NavigationLink(
            destination: EventListView(eventList: self.eventsModel.getEventList(calendars: [self.event.calendar]), title: self.event.calendar.title)) {
            VStack(alignment: .leading, spacing: 8.0) {
                HStack {
                    Text(self.event.calendar.title)
                        .foregroundColor(Color(self.event.calendar.cgColor))
                    Spacer()
                }
                HStack {
                    Text(EventsModel.dateDisp(date: self.event.startDate, isAllDay: self.event.isAllDay))
                    Spacer()
                }
                HStack {
                    Text(self.event.eventTitle)
                    Spacer()
                }
            }
        }
    }
}

struct EmptyEventView: View {
    let event: EventDispModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack {
                Text(self.event.calendar.title)
                    .foregroundColor(Color(self.event.calendar.cgColor))
                Spacer()
            }
            HStack {
                Text("No event")
                Spacer()
            }
        }
    }
}
