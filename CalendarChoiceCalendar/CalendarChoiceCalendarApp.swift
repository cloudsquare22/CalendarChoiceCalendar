//
//  CalendarChoiceCalendarApp.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2020/10/04.
//

import SwiftUI
import EventKit

@main
struct CalendarChoiceCalendarApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(EventsModel())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if EKEventStore.authorizationStatus(for: .event) != .authorized {
            let eventStore = EKEventStore()
            eventStore.requestAccess(to: .event) { (access, _) in
                print("EKEventStore requestAccess: \(access)")
            }
        }
        return true
    }
}
