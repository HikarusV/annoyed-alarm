//
//  Alarm.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 19/03/26.
//


import Foundation

struct Alarm: Identifiable, Codable {
    var id: UUID = UUID()
    var time: Date
    var isEnabled: Bool
    var label: String
    var difficulty: String
}