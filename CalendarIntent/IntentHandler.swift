//
//  IntentHandler.swift
//  CalendarIntent
//
//  Created by Shin Inaba on 2020/10/31.
//

import Intents
import EventKit

class IntentHandler: INExtension, ConfigurationIntentHandling {
    func provideCalendarOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<SelectCalendar>?, Error?) -> Void) {
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        var selectCalendars: [SelectCalendar] = []
        for calendar in calendars {
            let selectCalendar = SelectCalendar(identifier: calendar.calendarIdentifier, display: calendar.title)
//            selectCalendar.calendar = calendar.title
            selectCalendars.append(selectCalendar)
        }
        let collection = INObjectCollection(items: selectCalendars)
        completion(collection, nil)
    }
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}

