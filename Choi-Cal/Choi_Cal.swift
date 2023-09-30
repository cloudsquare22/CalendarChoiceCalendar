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
    
    func placeholder(in context: Context) -> NeCalTimelineEntry {
        print(#function)
        let event = EventsModelWidget()
        event.startDate = Date()
        event.title = "Event xxx"
        event.calenderTitle = "Calendar xxx"
        event.calendarColor = .red
        return NeCalTimelineEntry(date: Date(), events: [event], configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (NeCalTimelineEntry) -> ()) {
        let selectCalendar = configuration.calendar?.displayString ?? "No select"
        let selectCalendars = self.getCalendar(calendarName: selectCalendar)
        let eKEvents = getEvents(selectCalendars: selectCalendars)
        var events: [EventsModelWidget] = []
        switch(eKEvents.count) {
        case 0:
            let event = EventsModelWidget()
            event.title = "No Next Event"
            event.calenderTitle = selectCalendar
            event.isNoEvent = true
            events.append(event)
            break
        case 1:
            let event = EventsModelWidget.cretate(eKEvent: eKEvents[0])
            events.append(event)
            break
        case 2:
            events = self.createTimeEvents(range: 0...1, eKEvents: eKEvents)
            break
        default:
            events = self.createTimeEvents(range: 0...2, eKEvents: eKEvents)
        }
        let entry = NeCalTimelineEntry(date: Date(), events: events, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print(#function)
        
//        print(configuration.calendar?.displayString)
        
        var entries: [NeCalTimelineEntry] = []
        
        let selectCalendar = configuration.calendar?.displayString ?? ""
        let selectCalendars = self.getCalendar(calendarName: selectCalendar)
        let eKEvents = getEvents(selectCalendars: selectCalendars)
        let nextDate = Date()
        var timelineReloadPolicy: TimelineReloadPolicy = .atEnd

        switch(eKEvents.count) {
        case 0:
            let event = EventsModelWidget()
            event.isNoEvent = true
            event.title = "No Next Event"
            event.calenderTitle = configuration.calendar?.displayString ?? "No select"
            if selectCalendars.count > 0 {
                event.calendarColor = Color(selectCalendars[0].cgColor)
            }
            let entry = NeCalTimelineEntry(date: Date(), events: [event], configuration: configuration)
            entries.append(entry)
            timelineReloadPolicy = .after(Date() + 3600)
        case 1:
            let event1 = EventsModelWidget.cretate(eKEvent: eKEvents[0])
            entries.append(NeCalTimelineEntry(date: nextDate, events: [event1], configuration: configuration))
            if entries[entries.count - 1].date > (Date() + 3600) {
                timelineReloadPolicy = .after(Date() + 3600)
            }
        case 2:
            let time1Events = self.createTimeEvents(range: 0...1, eKEvents: eKEvents)
            let time2Events = self.createTimeEvents(range: 1...1, eKEvents: eKEvents)
            entries.append(NeCalTimelineEntry(date: nextDate, events: time1Events, configuration: configuration))
            entries.append(NeCalTimelineEntry(date: time1Events[0].startDate, events: time2Events, configuration: configuration))
            if entries[entries.count - 1].date > (Date() + 3600) {
                timelineReloadPolicy = .after(Date() + 3600)
            }
        case 3:
            let time1Events = self.createTimeEvents(range: 0...2, eKEvents: eKEvents)
            let time2Events = self.createTimeEvents(range: 1...2, eKEvents: eKEvents)
            entries.append(NeCalTimelineEntry(date: nextDate, events: time1Events, configuration: configuration))
            entries.append(NeCalTimelineEntry(date: time1Events[0].startDate, events: time2Events, configuration: configuration))
            if entries[entries.count - 1].date > (Date() + 3600) {
                timelineReloadPolicy = .after(Date() + 3600)
            }
        default:
            let time1Events = self.createTimeEvents(range: 0...2, eKEvents: eKEvents)
            let time2Events = self.createTimeEvents(range: 1...3, eKEvents: eKEvents)
            entries.append(NeCalTimelineEntry(date: nextDate, events: time1Events, configuration: configuration))
            entries.append(NeCalTimelineEntry(date: time1Events[0].startDate, events: time2Events, configuration: configuration))
            if entries[entries.count - 1].date > (Date() + 3600) {
                timelineReloadPolicy = .after(Date() + 3600)
            }
        }
                
//        if eKEvents.count > 0 {
//            for eKEvent in eKEvents {
//                let event = EventsModelWidget.cretate(eKEvent: eKEvent)
//                let entry = SimpleEntry(date: nextDate, events: [event], configuration: configuration)
//                entries.append(entry)
//                nextDate = eKEvent.startDate
//                if entries.count >= 2 {
//                    break
//                }
//            }
//            if entries[entries.count - 1].date > (Date() + 3600) {
//                timelineReloadPolicy = .after(Date() + 3600)
//            }
//        }
//        else {
//            let event = EventsModelWidget()
//            event.isNoEvent = true
//            event.title = "No Next Event"
//            event.calenderTitle = configuration.calendar?.displayString ?? "No select"
//            if selectCalendars.count > 0 {
//                event.calendarColor = Color(selectCalendars[0].cgColor)
//            }
//            let entry = SimpleEntry(date: Date(), events: [event], configuration: configuration)
//            entries.append(entry)
//            timelineReloadPolicy = .after(Date() + 3600)
//        }
        print(entries)
        let timeline = Timeline(entries: entries, policy: timelineReloadPolicy)
        completion(timeline)
    }
    
    func createTimeEvents(range: CountableClosedRange<Int>, eKEvents: [EKEvent]) -> [EventsModelWidget] {
        var result: [EventsModelWidget] = []
        for index in range {
            result.append(EventsModelWidget.cretate(eKEvent: eKEvents[index]))
        }
        return result
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

struct NeCalTimelineEntry: TimelineEntry {
    let date: Date
    let events: [EventsModelWidget]
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
                    Text(entry.events[0].calenderTitle)
                        .font(.footnote)
                        .lineLimit(1)
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 3, style: .circular)
                    .fill(entry.events[0].calendarColor)
                    .frame(width: geometry.size.width, height: 3, alignment: .center)
                    .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 4.0, trailing: 0.0))
                switch self.family {
                case .systemSmall:
                    SmallView(entry: self.entry)
                case .systemMedium:
                    MiddleView(entry: self.entry)
                case .systemLarge:
                    LargeView(entry: self.entry)
                case .systemExtraLarge:
                    Text("System Large")
                default:
                    Text("default")
                }
                
            }
            .widgetURL(self.entry.events[0].url)
        }
        .padding(8)
        .widgetBackground(Color.clear)
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
        .description(NSLocalizedString("Displays the next event for the specified calendar.", comment: ""))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

struct Choi_Cal_Previews: PreviewProvider {
    static let event = EventsModelWidget()
    static var previews: some View {
        Group {
            Choi_CalEntryView(entry: NeCalTimelineEntry(date: Date(), events: [Choi_Cal_Previews.event], configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            Choi_CalEntryView(entry: NeCalTimelineEntry(date: Date(), events: [Choi_Cal_Previews.event], configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            Choi_CalEntryView(entry: NeCalTimelineEntry(date: Date(), events: [Choi_Cal_Previews.event], configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))

            if #available(iOSApplicationExtension 15.0, *) {
                Choi_CalEntryView(entry: NeCalTimelineEntry(date: Date(), events: [Choi_Cal_Previews.event], configuration: ConfigurationIntent()))
                    .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

struct SmallView : View {
    let entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            if entry.events[0].isNoEvent == false {
                Text(entry.events[0].dispStartEndDateShort)
                    .font(.footnote)
            }
            Text(entry.events[0].title)
                .font(.footnote)
                .truncationMode(.middle)
            if entry.events[0].isNoEvent == false && Date() <= entry.events[0].startDate {
                Text(entry.events[0].startDate, style: .timer)
                    .font(.footnote)
            }
        }
    }
}

struct MiddleView : View {
    let entry: Provider.Entry

    var body: some View {
        LargeViewCell(event: entry.events[0])
    }
}

struct LargeView : View {
    let entry: Provider.Entry

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 8.0) {
                LargeViewCell(event: entry.events[0])
                if entry.events.count > 1 {
                    RoundedRectangle(cornerRadius: 3, style: .circular)
                        .fill(entry.events[1].calendarColor)
                        .frame(width: geometry.size.width, height: 1, alignment: .center)
                        .padding(EdgeInsets(top: 4.0, leading: 0.0, bottom: 4.0, trailing: 0.0))
                    LargeViewCell(event: entry.events[1])
                }
                if entry.events.count > 2 {
                    RoundedRectangle(cornerRadius: 3, style: .circular)
                        .fill(entry.events[2].calendarColor)
                        .frame(width: geometry.size.width, height: 1, alignment: .center)
                        .padding(EdgeInsets(top: 4.0, leading: 0.0, bottom: 4.0, trailing: 0.0))
                    LargeViewCell(event: entry.events[2])
                }
            }
            .onAppear() {
                print("\(geometry.size)")
            }
        }
    }
}

struct LargeViewCell : View {
    var event: EventsModelWidget
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            if event.isNoEvent == false {
                HStack {
                    Text(event.dispStartEndDate)
                        .font(.footnote)
                    if Date() <= event.startDate {
                        Text(event.startDate, style: .timer)
                            .font(.footnote)
                    }
                }
            }
            Text(event.title)
                .font(.footnote)
//                .truncationMode(.middle)
                .lineLimit(1)
            if event.location.isEmpty == false {
                HStack {
                    Image(systemName: "location")
                        .font(.footnote)
                    Text(event.location)
                        .font(.footnote)
                        .lineLimit(1)
                }
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

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
