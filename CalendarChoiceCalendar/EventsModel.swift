//
//  EventsModel.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/04.
//

import SwiftUI
import EventKit

class EventsModel: ObservableObject {
    
    @Published var events: [EKEvent] = []
    @Published var nextEvents: [EKEvent] = []
    
    init() {
    }
    
    func updateNextEvents() {
        self.nextEvents = []
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { _,_ in
            let calendars = eventStore.calendars(for: .event)
            for calendar in calendars {
                let predicate = eventStore.predicateForEvents(withStart: Date(), end: Date()  + (86400 * 365), calendars: [calendar])
                let events = eventStore.events(matching: predicate)
                if 0 < events.count {
                    self.nextEvents.append(events[0])
//                    print(events[0].calendar)
                }
            }
        }
    }
    
    func updateEvents() {
        self.events = []
        let eventStore = EKEventStore()
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: Date()  + (86400 * 365), calendars: nil)
        eventStore.requestAccess(to: .event) { _,_ in
            let eventArray = eventStore.events(matching: predicate)
            for event in eventArray {
                if event.calendar.title == "FC Barcelona" {
                    self.events.append(event)
                }
            }
        }
    }
    
    static func dateDisp(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        dateFormatter.locale = .current
        return dateFormatter.string(from: date)
    }

}
