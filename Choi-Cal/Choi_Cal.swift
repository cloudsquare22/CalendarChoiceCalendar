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
        event.calendarColor = .red
        return SimpleEntry(date: Date(), event: event, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let selectCalendar = configuration.calendar?.displayString ?? ""
        let selectCalendars = self.getCalendar(calendarName: selectCalendar)
        let eKEvents = getEvents(selectCalendars: selectCalendars)
        var event = EventsModelWidget()
        if eKEvents.count > 0 {
            event = EventsModelWidget.cretate(eKEvent: eKEvents[0])
        }
        let entry = SimpleEntry(date: Date(), event: event, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print(#function)
        
//        print(configuration.calendar?.displayString)
        
        var entries: [SimpleEntry] = []
        
        let selectCalendar = configuration.calendar?.displayString ?? ""
        let selectCalendars = self.getCalendar(calendarName: selectCalendar)
        let eKEvents = getEvents(selectCalendars: selectCalendars)
        var nextDate = Date()
        var timelineReloadPolicy: TimelineReloadPolicy = .atEnd
        if eKEvents.count > 0 {
            for eKEvent in eKEvents {
                let event = EventsModelWidget.cretate(eKEvent: eKEvent)
                let entry = SimpleEntry(date: nextDate, event: event, configuration: configuration)
                entries.append(entry)
                nextDate = eKEvent.startDate
                if entries.count >= 2 {
                    break
                }
            }
            if entries[entries.count - 1].date > (Date() + 3600) {
                timelineReloadPolicy = .after(Date() + 3600)
            }
        }
        else {
            let event = EventsModelWidget()
            event.isNoEvent = true
            event.title = "No Next Event"
            event.calenderTitle = configuration.calendar?.displayString ?? "No select"
            if selectCalendars.count > 0 {
                event.calendarColor = Color(selectCalendars[0].cgColor)
            }
            let entry = SimpleEntry(date: Date(), event: event, configuration: configuration)
            entries.append(entry)
            timelineReloadPolicy = .after(Date() + 3600)
        }
        print(entries)
        let timeline = Timeline(entries: entries, policy: timelineReloadPolicy)
        completion(timeline)
    }
    
    func getCalendar(calendarName: String) -> [EKCalendar] {
        let calendarAll = eventStore.calendars(for: .event)
        var result: [EKCalendar] = []
        if calendarName.isEmpty == false {
            for calendar in calendarAll {
                if calendar.title == calendarName {
                    result.append(calendar)
                    break
                }
            }
        }
        else {
            result = calendarAll
        }
        return result
    }

    func getEvents(selectCalendars: [EKCalendar]) -> [EKEvent] {
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
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text(entry.event.calenderTitle)
                        .font(.footnote)
                        .lineLimit(1)
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 3, style: .circular)
                    .fill(entry.event.calendarColor)
                    .frame(width: geometry.size.width, height: 3, alignment: .center)
                switch self.family {
                case .systemSmall:
                    SmallView(entry: self.entry)
                case .systemMedium:
                    MiddleView(entry: self.entry)
                case .systemLarge:
                    Text("Large")
                default:
                    Text("default")
                }
                
            }
            .widgetURL(self.entry.event.url)
        }
        .padding(8)
    }
}

@main
struct Choi_Cal: Widget {
    let kind: String = "jp.cloudsquare.ios.neCal.widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Choi_CalEntryView(entry: entry)
        }
        .configurationDisplayName("neCal")
        .description(NSLocalizedString("Select the calendar to display.", comment: ""))
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct Choi_Cal_Previews: PreviewProvider {
    static let event = EventsModelWidget()
    static var previews: some View {
        Group {
            Choi_CalEntryView(entry: SimpleEntry(date: Date(), event: Choi_Cal_Previews.event, configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            Choi_CalEntryView(entry: SimpleEntry(date: Date(), event: Choi_Cal_Previews.event, configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
//        Choi_CalEntryView(entry: SimpleEntry(date: Date(), event: Choi_Cal_Previews.event, configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

struct SmallView : View {
    let entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            if entry.event.isNoEvent == false {
                Text(entry.event.dispStartEndDateShort)
                    .font(.footnote)
            }
            Text(entry.event.title)
                .font(.footnote)
            if entry.event.isNoEvent == false && Date() <= entry.event.startDate {
                Text(entry.event.startDate, style: .timer)
                    .font(.footnote)
            }
        }
    }
}

struct MiddleView : View {
    let entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            if entry.event.isNoEvent == false {
                Text(entry.event.dispStartEndDate)
                    .font(.footnote)
            }
            Text(entry.event.title)
                .font(.footnote)
                .truncationMode(.middle)
                .lineLimit(1)
            if entry.event.location.isEmpty == false {
                HStack {
                    Image(systemName: "location")
                        .font(.footnote)
                    Text(entry.event.location)
                        .font(.footnote)
                }
            }
            if entry.event.isNoEvent == false && Date() <= entry.event.startDate {
                Text(entry.event.startDate, style: .timer)
                    .font(.footnote)
            }
        }
    }
}

class EventsModelWidget {
    var startDate: Date = Date()
    var endDate: Date = Date()
    var title: String = "-"
    var location: String = ""
    var calenderTitle: String = "-"
    var calendarColor: Color = .red
    var isNoEvent: Bool = false
    var calendarIdentifier: String = ""
    
    var url: URL {
        var result = URL(string: "necal://")!;
        if let url = URL(string: "necal://\(self.calendarIdentifier)") {
            result = url
        }
        return result
    }
    
    var dispStartDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d H:mm〜"
        dateFormatter.locale = .current
        return dateFormatter.string(from: self.startDate)
    }

    var dispStartEndDate: String {
        let dateFormatterEnd = DateFormatter()
        dateFormatterEnd.dateFormat = "M/d H:mm"
        dateFormatterEnd.locale = .current
        return self.dispStartDate +
            dateFormatterEnd.string(from: self.endDate)
    }

    var dispStartEndDateShort: String {
        let dateFormatterEnd = DateFormatter()
        dateFormatterEnd.dateFormat = "H:mm"
        dateFormatterEnd.locale = .current
        return self.dispStartDate +
            dateFormatterEnd.string(from: self.endDate)
    }

    static func cretate(eKEvent: EKEvent) -> EventsModelWidget {
        let event = EventsModelWidget()
        event.startDate = eKEvent.startDate
        event.endDate = eKEvent.endDate
        event.title = eKEvent.title
        if let location = eKEvent.location {
            event.location = location
        }
        event.calenderTitle = eKEvent.calendar.title
        event.calendarColor = Color(eKEvent.calendar.cgColor)
        event.calendarIdentifier = eKEvent.calendar.calendarIdentifier
        return event
    }
}
