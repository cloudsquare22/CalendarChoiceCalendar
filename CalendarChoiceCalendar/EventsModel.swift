//
//  EventsModel.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/04.
//

import SwiftUI
import EventKit
import WidgetKit

class EventsModel: ObservableObject {
    
    @Published var events: [EKEvent] = []
    @Published var nextEvents: [EventDispModel] = []
    @Published var calendarEventList: [EventDispModel] = []
    var offCalendar: [String] = []
    let eventStore = EKEventStore()
    
    init() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(EventsModel.changeEvent(_:)), name: NSNotification.Name.EKEventStoreChanged, object: eventStore)
        if EKEventStore.authorizationStatus(for: .event) != .authorized {
            eventStore.requestAccess(to: .event) { (access, _) in
                print("EKEventStore requestAccess: \(access)")
            }
        }
        self.updateNextEvents()
    }
    
    @objc func changeEvent(_ notification:Notification?) {
        print(#function)
        self.updateNextEvents()
        WidgetCenter.shared.reloadAllTimelines()
    }

    func updateNextEvents() {
        print(#function)
        
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else {
            return
        }
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
            var addEvent = EventDispModel(index: index, startDate: Date(), eventTitle: "", calendar: calendar, isOn: isOn)
            for event in events {
                if event.startDate < Date() {
                    continue
                }
                else {
                    addEvent = EventDispModel(index: index, startDate: event.startDate, eventTitle: event.title, calendar: calendar, isOn: isOn)
                    break;
                }
            }
            self.nextEvents.append(addEvent)
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
    
    func getEventList(calendar: EKCalendar) -> [EventDispModel] {
        var eventList: [EventDispModel] = []
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: Date()  + (86400 * 365), calendars: [calendar])
        let events = eventStore.events(matching: predicate)
        for event in events {
            if event.startDate < Date() {
                continue
            }
            let eventDispModel = EventDispModel(startDate: event.startDate, eventTitle: event.title, calendar: calendar, isOn: true)
            eventList.append(eventDispModel)
        }
        return eventList
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
    var index: Int = 0
    let startDate: Date
    let eventTitle: String
    let calendar: EKCalendar
    var isOn: Bool
}
