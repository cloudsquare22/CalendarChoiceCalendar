//
//  MainView.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/04.
//

import SwiftUI
import WidgetKit
import EventKit

struct MainView: View {
    @EnvironmentObject var eventsModel: EventsModel
    @State private var selection = 1
    @State var openSheet: Bool = false
    @State var sheetCalendar: EKCalendar? = nil
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        TabView(selection: $selection) {
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(0)
            NextEventView()
                .tabItem {
                    Image(systemName: "deskclock")
                    Text("Next Event")
                }
                .tag(1)
            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }
                .tag(2)
        }
        .onOpenURL(perform: { url in
            print(#function + ":\(url)")
            if url.absoluteString != "necal://" {
                self.sheetCalendar = self.eventsModel.getEKCakendar(calendarIdentifier: url.absoluteString.replacingOccurrences(of: "necal://", with: ""))
                self.openSheet.toggle()
            }
        })
        .sheet(isPresented: self.$openSheet, content: {
            if let calendar = self.sheetCalendar {
                NavigationView {
                    EventListView(eventList: self.eventsModel.getEventList(calendars: [calendar]), title: calendar.title)

                }
            }
        })
        .onChange(of: scenePhase) { phase in
            print("Scene:\(phase)")
            switch(phase) {
            case .active:
                self.eventsModel.updateNextEvents()
                WidgetCenter.shared.reloadAllTimelines()
            case .background:
                break
            case .inactive:
                break
            @unknown default:
                fatalError()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(EventsModel())
    }
}
