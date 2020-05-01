//
//  AudioManager.swift
//  DelaPena_Teves
//
//  Created by Jeofferson Dela Peña on 2/8/20.
//  Copyright © 2020 Jeofferson Dela Peña. All rights reserved.
//

import AVFoundation
import UIKit

class AudioManager: UIViewController {

    
    static var isPaused = false
    
    static var finishedPlayingAll = false
    
    static var currentVolume: Float = 100.0
    
    static var stepInterval = 5.0
    
    static var audioPlayer = AVAudioPlayer()
    
    
    static func prepareToPlay(fileName: String, fileExtension: String) {
        
        let songUrl = Bundle.main.url(forResource: fileName, withExtension: fileExtension)!
        
        do {
            
            audioPlayer = try AVAudioPlayer.init(contentsOf: songUrl)
            
            audioPlayer.prepareToPlay()
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            
        } catch {
            
            print(error)
            
        }
        
    }
    
    
    static func play() {
        
        audioPlayer.play()
        
        isPaused = false
        
        finishedPlayingAll = false
        
    }
    
    
    static func pause() {
        
        audioPlayer.pause()
        
        isPaused = true
        
    }
    
    
    static func stop() {
        
        audioPlayer.stop()
        
    }
    
    
    static func isPlaying() -> Bool {
        
        return audioPlayer.isPlaying
        
    }
    
    
    static func songDuration() -> Double {
        
        return audioPlayer.duration
        
    }
    
    
    static func songCurrentTime() -> Double {
        
        return audioPlayer.currentTime
        
    }
    
    
    static func step(isForward: Bool) {
        
        if isForward {
            
            audioPlayer.currentTime += stepInterval
            
        } else {
            
            audioPlayer.currentTime -= stepInterval
            
        }
        
    }
    
    
    static func adjustCurrentTime(newTime: Double) {
        
        print(newTime)
            
        audioPlayer.currentTime = newTime
        
    }
    
    
    static func adjustVolume (newVolume: Float) {
        
        audioPlayer.volume = newVolume / 100.0
        
        currentVolume = newVolume
        
    }
    

}
