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
        let eKEvent = getEvent()
        let event = EventsModelWidget()
        event.startDate = eKEvent!.startDate
        event.title = eKEvent!.title
        return SimpleEntry(date: Date(), event: event, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let eKEvent = getEvent()
        let event = EventsModelWidget()
        event.startDate = eKEvent!.startDate
        event.title = eKEvent!.title
        let entry = SimpleEntry(date: Date(), event: event, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let eKEvent = getEvent()
            let event = EventsModelWidget()
            event.startDate = eKEvent!.startDate
            event.title = eKEvent!.title
            let entry = SimpleEntry(date: entryDate, event: event, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    func getEvent() -> EKEvent? {
        var result: EKEvent? = nil
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: Date()  + (86400 * 365), calendars: nil)
//        eventStore.requestAccess(to: .event) { _,_ in
            let eventArray = self.eventStore.events(matching: predicate)
            for event in eventArray {
                if event.calendar.title == "FC Barcelona" {
                    result = event
                    break
                }
            }
//        }
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
        VStack {
            Text("Calendar Title")
                .font(.footnote)
            Spacer()
            VStack(alignment: .leading) {
                Text(entry.event.dispStartDate)
                    .font(.footnote)
                Text(entry.event.title)
                    .font(.footnote)
            }
            Spacer()
        }.padding(8)
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
    var title: String = "Title"
    
    var dispStartDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = .current
        return dateFormatter.string(from: self.startDate)
    }
}
