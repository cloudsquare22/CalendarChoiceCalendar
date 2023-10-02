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
    @Environment(\.presentationMode) var presentationMode
    @State var selection = 0

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .font(.largeTitle)
                    })
                }
                .padding(8)
                Spacer()
                VStack(spacing: 4.0) {
                    Text(self.event.calendar.title)
                        .foregroundColor(Color(self.event.calendar.cgColor))
                        .font(.title2)
                        .padding(8.0)
                    RoundedRectangle(cornerRadius: 3, style: .circular)
                        .fill(Color(self.event.calendar.cgColor))
                        .frame(width: abs(geometry.size.width - 16), height: 3, alignment: .center)
                    Text(self.event.eventTitle)
                        .font(.title3)
                        .padding(8.0)
                    Text(EventsModel.dateDisp(date: self.event.startDate, isAllDay: self.event.isAllDay))
                        .font(.title3)
                        .padding(8.0)
                }
    //            Spacer()
                Picker(selection: self.$selection, label: Text("Calendar"), content: {
                    ForEach(self.eventsModel.nextEvents) { nextEvent in
                        Text(nextEvent.calendar.title)
                            .foregroundColor(Color(nextEvent.calendar.cgColor))
                            .tag(nextEvent.index)
                            .padding()
                    }
                })
                .pickerStyle(WheelPickerStyle())
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("blackAndWhite"), lineWidth: 1)
                )
                Button(action: {
                    EventsModel.copyCalendar(eventDispModel: self.event, selectCalendar: self.eventsModel.nextEvents[self.selection].calendar)
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Copy to calendar")
                        .font(.title2)
                        .padding(8)
                })
                    .padding(8.0)
                    .buttonStyle(.borderedProminent)
                Spacer()
            }
            .padding(8)
        }
    }
}

struct CopyEventView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
//        CopyEventView()
    }
}
