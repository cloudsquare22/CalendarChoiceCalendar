//
//  CalendarView.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/19.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var eventsModel: EventsModel

    var body: some View {
        NavigationView {
            List {
                ForEach(self.eventsModel.nextEvents) { nextEvent in
                    HStack {
                        Text(nextEvent.calendar.title)
                            .foregroundColor(Color(nextEvent.calendar.cgColor))
                        Spacer()
                        if nextEvent.isOn == true {
                            Image(systemName: "checkmark.square")
                                .onTapGesture {
                                    print("\(eventsModel.nextEvents[nextEvent.index].calendar.title) off")
                                    eventsModel.nextEvents[nextEvent.index].isOn = false
                                    self.eventsModel.updateOffCalendar()
                                }
                                .font(.title)
                        }
                        else {
                            Image(systemName: "square")
                                .onTapGesture {
                                    print("\(eventsModel.nextEvents[nextEvent.index].calendar.title) on")
                                    eventsModel.nextEvents[nextEvent.index].isOn = true
                                    self.eventsModel.updateOffCalendar()
                                }
                                .font(.title)
                        }
                    }
                }
            }
            .padding(8)
            .navigationBarTitle("Calendar", displayMode: .inline)
            .navigationBarItems(trailing: Image(systemName: "arrow.counterclockwise")
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
