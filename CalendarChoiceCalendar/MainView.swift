//
//  MainView.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/04.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var eventsModel: EventsModel
    @State var calendarsOn: [Bool] = []
    
    var body: some View {
        TabView {
            NavigationView {
                List {
                    ForEach(self.eventsModel.nextEvents) { event in
                        VStack {
                            HStack {
                                Text(event.calendar.title)
                                    .foregroundColor(Color(event.calendar.cgColor))
                                Spacer()
                            }
                            HStack {
                                if event.eventTitle != "" {
                                    Text(EventsModel.dateDisp(date: event.startDate))
                                }
                                else {
                                    Text("-")
                                }
                                Spacer()
                            }
                            HStack {
                                if event.eventTitle != "" {
                                    Text(event.eventTitle)
                                }
                                else {
                                    Text("No event.")
                                }
                                Spacer()
                            }
                        }
                    }
                }
                .navigationBarTitle("Next Events", displayMode: .inline)
                .onAppear() {
                    print("onAppear() Next Events")
                    self.eventsModel.updateNextEvents()
                }
                .onDisappear() {
                    print("onDisappear() Next Events")
                }
            }
            .tabItem {
                Text("Next Events")
            }
            NavigationView {
                List {
                    ForEach(self.eventsModel.calendars) { calendar in
                        HStack {
                            Text(calendar.calendar.title)
                                .foregroundColor(Color(calendar.calendar.cgColor))
                            Spacer()
                            Toggle(isOn: $calendarsOn[calendar.index], label: {
                                Text("Label")
                            })
                            .labelsHidden()
                        }
                    }
                }
                .navigationBarTitle("Calendars", displayMode: .inline)
                .onAppear() {
                    print("onAppear() Calendars")
                    self.eventsModel.updateCalendars()
                    for calendar in self.eventsModel.calendars {
                        self.calendarsOn.append(calendar.isOn)
                    }
                }
                .onDisappear() {
                    print("onDisappear() Calendars")
                }
                .onChange(of: self.calendarsOn, perform: { value in
                    print("Change")
                    self.eventsModel.updateCalndarsIsOn(isOns: self.calendarsOn)
                })
            }
            .tabItem {
                Text("Calendars")
            }
            Text("Setting")
                .tabItem {
                    Text("Setting")
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
