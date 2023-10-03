//
//  CalendarView.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/19.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var eventsModel: EventsModel

    fileprivate func ForEachEventDispModel() -> ForEach<[EventDispModel], UUID, OneCalendarView> {
        return ForEach(self.eventsModel.nextEvents) { nextEvent in
            OneCalendarView(nextEvent: nextEvent)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEachEventDispModel()
            }
            .refreshable {
                self.eventsModel.updateNextEvents()
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: Image(systemName: "arrow.triangle.2.circlepath")
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                self.eventsModel.updateNextEvents()
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(EventsModel())
    }
}

struct OneCalendarView: View {
    @EnvironmentObject var eventsModel: EventsModel
    let nextEvent: EventDispModel

    var body: some View {
        HStack {
            Text(self.nextEvent.calendar.title)
                .foregroundColor(Color(self.nextEvent.calendar.cgColor))
            Spacer()
            if self.nextEvent.isOn == true {
                Image(systemName: "checkmark.square")
                    .onTapGesture {
                        print("\(eventsModel.nextEvents[self.nextEvent.index].calendar.title) off")
                        eventsModel.nextEvents[self.nextEvent.index].isOn = false
                        self.eventsModel.updateOffCalendar()
                    }
                    .font(.title)
            }
            else {
                Image(systemName: "square")
                    .onTapGesture {
                        print("\(eventsModel.nextEvents[self.nextEvent.index].calendar.title) on")
                        eventsModel.nextEvents[self.nextEvent.index].isOn = true
                        self.eventsModel.updateOffCalendar()
                    }
                    .font(.title)
            }
        }
    }
}
