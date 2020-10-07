//
//  EventsModel.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/04.
//

import SwiftUI
import EventKit

class EventsModel: ObservableObject {
    let eventStore = EKEventStore()
    
    @Published var events: [EKEvent] = []
    
    init() {
    }
    
    func updateEvents() {
        self.events = []
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: Date()  + (86400 * 365), calendars: nil)
        eventStore.requestAccess(to: .event) { _,_ in
            let eventArray = self.eventStore.events(matching: predicate)
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
