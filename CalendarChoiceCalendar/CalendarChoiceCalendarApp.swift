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
        print(#function)
        let authorizationStatus = EKEventStore.authorizationStatus(for: .event)
        let eventStore = EKEventStore()
        print("EKEventStore.authorizationStatus:\(authorizationStatus)")
        if #available(iOS 17.0, *) {
            if authorizationStatus == .fullAccess {
                print("iOS17*:Access OK")
            }
            else if authorizationStatus == .notDetermined {
                eventStore.requestFullAccessToEvents(completion: { (granted, error) in
                    if granted {
                        print("iOS17*:Accessible")
                    }
                    else {
                        print("iOS17*:Access denied")
                    }
                })
            }
        }
        else {
            if EKEventStore.authorizationStatus(for: .event) != .authorized {
                eventStore.requestAccess(to: .event) { (access, _) in
                    print("EKEventStore requestAccess: \(access)")
                }
            }
        }
        return true
    }
}
