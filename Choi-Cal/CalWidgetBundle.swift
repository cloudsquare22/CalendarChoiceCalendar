//
//  CalWidgetBundle.swift
//  CalendarChoiceCalendar
//
//  Created by Shin Inaba on 2023/10/04.
//

import WidgetKit
import SwiftUI

@main
struct PCWidgetBundle: WidgetBundle {
    var body: some Widget {
        Choi_Cal()
        if #available(iOSApplicationExtension 17.0, *) {
            CalWidgetAccessory()
        }
    }
}
