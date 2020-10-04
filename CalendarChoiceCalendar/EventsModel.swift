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
        var startDateComponents = Calendar.current.dateComponents(in: .current, from: Date())
        startDateComponents.hour = 0
        startDateComponents.minute = 0
        startDateComponents.second = 0
        startDateComponents.nanosecond = 0
        var endDateComponents = Calendar.current.dateComponents(in: .current, from: Date()  + (86400 * 60))
        endDateComponents.hour = 23
        endDateComponents.minute = 59
        endDateComponents.second = 59
        endDateComponents.nanosecond = 0
        let predicate = eventStore.predicateForEvents(withStart: startDateComponents.date!, end: endDateComponents.date!, calendars: nil)
        eventStore.requestAccess(to: .event) { _,_ in
            let eventArray = self.eventStore.events(matching: predicate)
            for event in eventArray {
                if event.calendar.title == "FC Barcelona" {
                    self.events.append(event)
                }
            }
        }

    }
}
