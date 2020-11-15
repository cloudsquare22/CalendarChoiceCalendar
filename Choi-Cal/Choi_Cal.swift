//
//  Choi_Cal.swift
//  Choi-Cal
//
//  Created by Shin Inaba on 2020/10/07.
//

import WidgetKit
import SwiftUI
import Intents
import EventKit

struct Provider: IntentTimelineProvider {
    let eventStore = EKEventStore()
    
    func placeholder(in context: Context) -> SimpleEntry {
        print(#function)
        let event = EventsModelWidget()
        event.startDate = Date()
        event.title = "Event xxx"
        event.calenderTitle = "Calendar xxx"
        event.calendarColor = .green
        return SimpleEntry(date: Date(), event: event, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let eKEvents = getEvents(calendarName: "")
        let event = EventsModelWidget()
        if eKEvents.count > 0 {
            event.startDate = eKEvents[0].startDate
            event.title = eKEvents[0].title
            event.calenderTitle = eKEvents[0].calendar.title
            event.calendarColor = Color(eKEvents[0].calendar.cgColor)
        }

        let entry = SimpleEntry(date: Date(), event: event, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print(#function)
        
//        print(configuration.calendar?.displayString)
        
        var entries: [SimpleEntry] = []
        
        let selectCalendar = configuration.calendar?.displayString ?? ""
        let eKEvents = getEvents(calendarName: selectCalendar)
        var nextDate = Date()
        for eKEvent in eKEvents {
            let event = EventsModelWidget()
            event.startDate = eKEvent.startDate
            event.title = eKEvent.title
            event.calenderTitle = eKEvent.calendar.title
            event.calendarColor = Color(eKEvent.calendar.cgColor)
            let entry = SimpleEntry(date: nextDate, event: event, configuration: configuration)
            entries.append(entry)
            nextDate = eKEvent.startDate
            if entries.count >= 2 {
                break
            }
        }
        print(entries)
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    func getEvents(calendarName: String) -> [EKEvent] {
        let calendarAll = eventStore.calendars(for: .event)
        var selectCalendars: [EKCalendar] = []
        if calendarName.isEmpty == false {
            for calendar in calendarAll {
                if calendar.title == calendarName {
                    selectCalendars.append(calendar)
                    break
                }
            }
        }
        else {
            selectCalendars = calendarAll
        }
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: Date()  + (86400 * 365), calendars: selectCalendars)
        let events = self.eventStore.events(matching: predicate)
        var result: [EKEvent] = []
        for event in events {
            if event.isAllDay == false {
                result.append(event)
            }
        }
        return result
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let event: EventsModelWidget
    let configuration: ConfigurationIntent
}

struct Choi_CalEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text(entry.event.calenderTitle)
                        .font(.footnote)
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 3, style: .circular)
                    .fill(entry.event.calendarColor)
                    .frame(width: geometry.size.width, height: 3, alignment: .center)
                VStack(alignment: .leading, spacing: 8.0) {
                    Text(entry.event.dispStartDate)
                        .font(.footnote)
                    Text(entry.event.title)
                        .font(.footnote)
                    Text(entry.event.startDate, style: .timer)
                        .font(.footnote)
                }
            }
        }
        .padding(8)
    }
}

@main
struct Choi_Cal: Widget {
    let kind: String = "jp.cloudsquare.ios.CalendarChoiceCalendar.widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Choi_CalEntryView(entry: entry)
        }
        .configurationDisplayName("neCal")
        .description("Next Calendar Configuration.")
        .supportedFamilies([.systemSmall])
    }
}

struct Choi_Cal_Previews: PreviewProvider {
    static let event = EventsModelWidget()
    static var previews: some View {
        Choi_CalEntryView(entry: SimpleEntry(date: Date(), event: Choi_Cal_Previews.event, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
//        Choi_CalEntryView(entry: SimpleEntry(date: Date(), event: Choi_Cal_Previews.event, configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//        Choi_CalEntryView(entry: SimpleEntry(date: Date(), event: Choi_Cal_Previews.event, configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

class EventsModelWidget {
    var startDate: Date = Date()
    var title: String = "-"
    var calenderTitle: String = "-"
    var calendarColor: Color = .black
    
    var dispStartDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d H:mm〜"
//        dateFormatter.dateStyle = .short
//        dateFormatter.timeStyle = .short
        dateFormatter.locale = .current
        return dateFormatter.string(from: self.startDate)
    }
}
