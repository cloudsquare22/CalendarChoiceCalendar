//
//  MainView.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/04.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var eventsModel: EventsModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.eventsModel.nextEvents, id: \.self) { event in
                    VStack {
                        HStack {
                            if event.calendar != nil {
                                Text(event.calendar.title)
                            }
                            else {
                                Text("-")
                            }
                            Spacer()
                        }
                        HStack {
                            Text(EventsModel.dateDisp(date: event.startDate))
                            Spacer()
                        }
                        HStack {
                            Text(event.title)
                            Spacer()
                        }
                    }
                }
            }
//            .navigationBarItems(trailing: Button("llala", action: {
//                print("update")
//                self.eventsModel.updateNextEvents()
//            }))
            .navigationBarTitle("Next Evens", displayMode: .inline)
            .onAppear() {
                print("onApper")
                self.eventsModel.updateNextEvents()
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
