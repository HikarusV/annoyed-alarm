//
//  AlarmNotifLiveActivity.swift
//  AlarmNotif
//
//  Created by Nazwa Sapta Pradana on 22/03/26.
//

import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents

struct AlarmNotifLiveActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AlarmAttributesData.self) { context in
            Text("Annoyed Alarm")
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "alarm.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .symbolEffect(.pulse)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    HStack {
                        Text("Time To Challange!!")
                            .foregroundColor(.orange)
                            .bold()
                            .frame(alignment: .leading)
                            .padding(.top, 20)
                        Spacer()
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Button(intent: OpenChallengeIntent(challengeDifficulty: context.state.challengeDifficulty)) {
                        Text("GO")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .padding(16)
                            .background(Circle().fill(Color.orange))
                    }
                    .buttonStyle(.plain)
                }
            } compactLeading: {
                Image(systemName: "alarm.fill")
                    .foregroundColor(.orange)
            } compactTrailing: {
                Text("GO")
                    .foregroundColor(.orange)
            } minimal: {
                Image(systemName: "alarm.fill")
                    .foregroundColor(.orange)
            }
        }
    }
}
