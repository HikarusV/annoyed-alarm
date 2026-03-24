//
//  AlarmNotifBundle.swift
//  AlarmNotif
//
//  Created by Nazwa Sapta Pradana on 22/03/26.
//

import WidgetKit
internal import SwiftUI

@main
struct AlarmNotifBundle: WidgetBundle {
    var body: some Widget {
        AlarmNotif()
        AlarmNotifControl()
        AlarmNotifLiveActivity()
    }
}
