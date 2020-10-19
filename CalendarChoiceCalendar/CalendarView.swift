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
                ForEach(self.eventsModel.calendars) { calendar in
                    HStack {
                        Text(calendar.calendar.title)
                            .foregroundColor(Color(calendar.calendar.cgColor))
                        Spacer()
                        Toggle(isOn: $eventsModel.calendars[calendar.index].isOn, label: {
                            Text("Label")
                        })
                        .labelsHidden()
                    }
                }
            }
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
