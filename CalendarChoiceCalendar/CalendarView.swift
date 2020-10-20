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
                        Toggle(isOn: $eventsModel.nextEvents[nextEvent.index].isOn, label: {
                            Text("Label")
                        })
                        .labelsHidden()
                    }
                    .onChange(of: eventsModel.nextEvents[nextEvent.index].isOn, perform: { value in
                        print("isOn Change:\(value)")
                    })
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
