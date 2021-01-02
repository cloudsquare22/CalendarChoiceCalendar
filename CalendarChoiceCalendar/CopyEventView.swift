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
                .font(.title3)
            Text(self.event.eventTitle)
                .font(.title3)
            Text(EventsModel.dateDisp(date: self.event.startDate, isAllDay: self.event.isAllDay))
                .font(.title3)
            Picker(selection: self.$selection, label: Text("Calendar"), content: {
                ForEach(0..<self.eventsModel.nextEvents.count) { index in
                    Text(self.eventsModel.nextEvents[index].calendar.title)
                        .tag(index)
                        .padding()
                }
            })
            Button(action: {
                EventsModel.copyCalendar(eventDispModel: self.event, selectCalendar: self.eventsModel.nextEvents[self.selection].calendar)
            }, label: {
                Text("Copy to calendar.")
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                                      .stroke(Color.blue, lineWidth: 1)
                    )
            })
            .font(.title3)
        }
        .padding(8)
    }
}

struct CopyEventView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
//        CopyEventView()
    }
}
