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
    @Published var nextEvents: [EventDispModel] = []
    @Published var calendars: [CalendarDispModel] = []
    
    init() {
    }
    
    func updateNextEvents() {
        self.nextEvents = []
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { _,_ in
            var calendars = eventStore.calendars(for: .event)
            calendars.sort() { (a,b) in
                a.title < b.title
            }
            for calendar in calendars {
                let predicate = eventStore.predicateForEvents(withStart: Date(), end: Date()  + (86400 * 365), calendars: [calendar])
                let events = eventStore.events(matching: predicate)
                if 0 < events.count {
                    let event = EventDispModel(startDate: events[0].startDate, eventTitle: events[0].title, calendar: calendar)
                    self.nextEvents.append(event)
                }
                else {
                    let event = EventDispModel(startDate: Date(), eventTitle: "", calendar: calendar)
                    self.nextEvents.append(event)
                }
//                print(calendar)
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
    
    func updateCalendars() {
        self.calendars = []
        let eventStore = EKEventStore()
        var calendars = eventStore.calendars(for: .event)
        calendars.sort() { (a,b) in
            a.title < b.title
        }
        var index = 0
        for calendar in calendars {
            let calendarDisp = CalendarDispModel(index: index, calendar: calendar, isOn: true)
            self.calendars.append(calendarDisp)
            index = index + 1
        }
    }
    
    func updateCalndarsIsOn(isOns: [Bool]) {
        for index in 0..<isOns.count {
            self.calendars[index].isOn = isOns[index]
        }
        print(self.calendars)
    }
    
    static func dateDisp(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        dateFormatter.locale = .current
        return dateFormatter.string(from: date)
    }

}

struct EventDispModel: Identifiable {
    let id: UUID = UUID()
    let startDate: Date
    let eventTitle: String
    let calendar: EKCalendar
}

struct CalendarDispModel: Identifiable {
    let id: UUID = UUID()
    let index: Int
    let calendar: EKCalendar
    var isOn: Bool
}
