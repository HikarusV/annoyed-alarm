//
//  SoundHandler.swift
//  annoyed-alarm
//
//  Created by Nazwa Sapta Pradana on 26/03/26.
//

import AVFoundation

var player: AVAudioPlayer?

func playAlarm() {
    guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else { return }
    
    do {
        player = try AVAudioPlayer(contentsOf: url)
        player?.numberOfLoops = -1 // loop terus
        player?.play()
    } catch {
        print("Error playing sound:", error)
    }
}
