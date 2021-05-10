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
    @State var onEventList: Bool = false
    let event: EventDispModel
    
    var body: some View {
        NavigationLink(
            destination: EventListView(eventList: self.eventsModel.getEventList(calendars: [self.event.calendar]), title: self.event.calendar.title),
            isActive: self.$onEventList) {
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
//        .onOpenURL(perform: { url in
////            print(#function + ":\(url)")
//            let ekcalendar = self.eventsModel.getEKCakendar(calendarIdentifier: url.absoluteString.replacingOccurrences(of: "necal://", with: ""))
////            print(ekcalendar)
//            if event.calendar.calendarIdentifier == ekcalendar?.calendarIdentifier {
//                print("onOpenURL:\(event.calendar.title)")
//                self.onEventList.toggle()
//            }
//        })
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
