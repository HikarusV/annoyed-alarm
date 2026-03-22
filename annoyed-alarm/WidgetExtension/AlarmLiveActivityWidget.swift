//
//  AlarmLiveActivityWidget.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 20/03/26.
//


import WidgetKit
import SwiftUI
import ActivityKit

struct AlarmLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AlarmAttributes.self) { context in
            Text("⏰ \(context.attributes.alarmName)")
        } dynamicIsland: { context in
            
            DynamicIsland {
                
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "alarm.fill")
                        .foregroundColor(.orange)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text("GO")
                        .foregroundColor(.orange)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    Text("Alarm")
                }
                
            } compactLeading: {
                Image(systemName: "alarm.fill")
            } compactTrailing: {
                Text("GO")
            } minimal: {
                Image(systemName: "alarm.fill")
            }
        }
    }
}

