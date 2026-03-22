//
//  AlarmAttributes.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 20/03/26.
//


import ActivityKit

struct AlarmAttributes: ActivityAttributes {

    public struct ContentState: Codable, Hashable {
        var isRinging: Bool
        var label: String
        var countdown: Int? = nil
    }

    var alarmName: String
}
