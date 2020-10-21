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
    var offCalendar: [String] = []
    let eventStore = EKEventStore()
    
    init() {
        eventStore.requestAccess(to: .event) { (access, _) in
            print("EKEventStore requestAccess: \(access)")
        }
        self.updateNextEvents()
    }
    
    func updateNextEvents() {
        if let offs = UserDefaults.standard.stringArray(forKey: "offCalendar") {
            offCalendar = offs
            print(offCalendar)
        }
        
        self.nextEvents = []
        var calendars = eventStore.calendars(for: .event)
        calendars.sort() { (a,b) in
            a.title < b.title
        }
        var index = 0
        for calendar in calendars {
            var isOn = true
            if self.offCalendar.contains(calendar.title) {
                isOn = false
            }
            let predicate = eventStore.predicateForEvents(withStart: Date(), end: Date()  + (86400 * 365), calendars: [calendar])
            let events = eventStore.events(matching: predicate)
            if 0 < events.count {
                let event = EventDispModel(index: index, startDate: events[0].startDate, eventTitle: events[0].title, calendar: calendar, isOn: isOn)
                self.nextEvents.append(event)
            }
            else {
                let event = EventDispModel(index: index, startDate: Date(), eventTitle: "", calendar: calendar, isOn: isOn)
                self.nextEvents.append(event)
            }
            index = index + 1
            print(calendar)
        }
    }
    
    func updateOffCalendar() {
        offCalendar = []
        for event in nextEvents {
            if event.isOn == false {
                offCalendar.append(event.calendar.title)
            }
        }
        UserDefaults.standard.setValue(offCalendar, forKey: "offCalendar")
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
    let index: Int
    let startDate: Date
    let eventTitle: String
    let calendar: EKCalendar
    var isOn: Bool
}
