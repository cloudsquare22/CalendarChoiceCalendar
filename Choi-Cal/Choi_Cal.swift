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
        let eKEvents = getEvents()
        let event = EventsModelWidget()
        if eKEvents.count > 0 {
            event.startDate = eKEvents[0].startDate
            event.title = eKEvents[0].title
            event.calenderTitle = eKEvents[0].calendar.title
            event.calendarColor = Color(eKEvents[0].calendar.cgColor)
        }
        
        return SimpleEntry(date: Date(), event: event, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let eKEvents = getEvents()
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
        var entries: [SimpleEntry] = []

        let eKEvents = getEvents()
        if eKEvents.count > 1 {
            for index in 0...1 {
                let event = EventsModelWidget()
                var date = Date()
                if 0 < index {
                   date = eKEvents[index - 1].startDate
                }
                event.startDate = eKEvents[index].startDate
                event.title = eKEvents[index].title
                event.calenderTitle = eKEvents[index].calendar.title
                event.calendarColor = Color(eKEvents[index].calendar.cgColor)
                let entry = SimpleEntry(date: date, event: event, configuration: configuration)
                entries.append(entry)
            }
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    func getEvents() -> [EKEvent] {
        let calendarAll = eventStore.calendars(for: .event)
        var selectCalendars: [EKCalendar] = []
        for calendar in calendarAll {
            if calendar.title == "FC Barcelona" {
                selectCalendars.append(calendar)
                break
            }
        }
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: Date()  + (86400 * 365), calendars: selectCalendars)
        let result = self.eventStore.events(matching: predicate)
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
                }
//                HStack {
//                    Spacer()
//                    Text(entry.event.calenderTitle)
//                        .foregroundColor(.gray)
//                        .font(.custom("endline", size: 10.0))
//                        .fontWeight(.light)
//                    Spacer()
//                }
            }
        }
        .padding(8)
    }
}

@main
struct Choi_Cal: Widget {
    let kind: String = "Choi_Cal"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Choi_CalEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
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