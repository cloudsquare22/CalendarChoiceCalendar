//
//  CopyEventView.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2021/01/01.
//

import SwiftUI

struct CopyEventView: View {
    let event: EventDispModel
    @EnvironmentObject var eventsModel: EventsModel
    @State var selection = 0

    var body: some View {
        VStack {
            Text(self.event.calendar.title)
                .foregroundColor(Color(self.event.calendar.cgColor))
            Text(self.event.eventTitle)
            Text(EventsModel.dateDisp(date: self.event.startDate, isAllDay: self.event.isAllDay))
            Picker(selection: self.$selection, label: Text("Calendar"), content: {
                ForEach(0..<self.eventsModel.nextEvents.count) { index in
                    Text(self.eventsModel.nextEvents[index].calendar.title)
                        .tag(index)
                }
            })
//            .labelsHidden()
        }
        .padding()
    }
}

struct CopyEventView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
//        CopyEventView()
    }
}
