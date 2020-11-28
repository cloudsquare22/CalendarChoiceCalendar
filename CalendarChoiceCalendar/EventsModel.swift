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
    
    @Published var nextEvents: [EventDispModel] = []
    var offCalendar: [String] = []
    let eventStore = EKEventStore()
    static let KEY_OFFCALENDAR = "offCalendar"
    
    init() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(EventsModel.changeEvent(_:)), name: NSNotification.Name.EKEventStoreChanged, object: eventStore)
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
        if let offs = UserDefaults.standard.stringArray(forKey: EventsModel.KEY_OFFCALENDAR) {
            self.offCalendar = offs
            print("Off Calendar:\(self.offCalendar)")
        }
        
        self.nextEvents = []
        var calendars = eventStore.calendars(for: .event)
        calendars.sort() { (a,b) in
            a.title < b.title
        }
        self.nextEvents = self.getEventList(calendars: calendars, isOnce: true)
    }
    
    func updateOffCalendar() {
        offCalendar = []
        for event in nextEvents {
            if event.isOn == false {
                offCalendar.append(event.calendar.title)
            }
        }
        UserDefaults.standard.setValue(offCalendar, forKey: EventsModel.KEY_OFFCALENDAR)
    }
    
    func getEventList(calendars: [EKCalendar], isOnce: Bool = false) -> [EventDispModel] {
        var eventList: [EventDispModel] = []
        for calendar in calendars {
            let isOn = self.offCalendar.contains(calendar.title) == true ? false : true
            let predicate = eventStore.predicateForEvents(withStart: Date(), end: Date()  + (86400 * 365), calendars: [calendar])
            let events = eventStore.events(matching: predicate)
            var isAddCalendarEvent = false
            for event in events {
                if event.startDate < Date() {
                    continue
                }
                else {
                    let addEvent = EventDispModel(index: eventList.count, startDate: event.startDate, eventTitle: event.title, isAllDay: event.isAllDay, calendar: calendar, isOn: isOn)
                    eventList.append(addEvent)
                    isAddCalendarEvent = true
                    if isOnce == true {
                        break;
                    }
                }
            }
            if isAddCalendarEvent == false {
                let addEvent = EventDispModel(index: eventList.count, startDate: Date(), eventTitle: "", calendar: calendar, isOn: isOn)
                eventList.append(addEvent)
            }
        }
        return eventList
    }
    
    static func dateDisp(date: Date, isAllDay: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        var addString = ""
        if isAllDay == false {
            dateFormatter.timeStyle = .short
        }
        else {
            dateFormatter.timeStyle = .none
            addString = " Allday"
        }
        dateFormatter.locale = .current
        return dateFormatter.string(from: date) + addString
    }

}

struct EventDispModel: Identifiable {
    let id: UUID = UUID()
    var index: Int = 0
    let startDate: Date
    let eventTitle: String
    var isAllDay: Bool = false
    let calendar: EKCalendar
    var isOn: Bool
}
