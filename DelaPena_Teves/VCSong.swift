//
//  VCSong.swift
//  DelaPena_Teves
//
//  Created by Jeofferson Dela Peña on 2/8/20.
//  Copyright © 2020 Jeofferson Dela Peña. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

class VCSong: UIViewController, AVAudioPlayerDelegate {

    
    var shouldForcePlayBecauseTheMusicChanged = false
    
    var songBg = ""
    
    var songTitle = ""
    var songArtist = ""
    
    var timer = Timer()
    
    @IBOutlet weak var sliderVolumeOutlet: UISlider!
    
    @IBOutlet weak var imgSongBg: UIImageView!
    
    @IBOutlet weak var lblSongTitle: UILabel!
    @IBOutlet weak var lblSongArtist: UILabel!
    
    @IBOutlet weak var btnTraverseModeOutlet: UIButton!
    
    @IBOutlet weak var sliderSongTimeOutlet: UISlider!
    
    @IBOutlet weak var lblSongDuration: UILabel!
    @IBOutlet weak var lblSongCurrentTime: UILabel!
    
    @IBOutlet weak var btnPlayOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderVolumeOutlet.value = AudioManager.currentVolume
        
        prepareCircleImageView()

        imgSongBg.image = UIImage(named: songBg)
        
        lblSongTitle.text = songTitle
        lblSongArtist.text = songArtist
        
        updateTraverseMode()
        
        if !AudioManager.isPlaying() || shouldForcePlayBecauseTheMusicChanged {
                
            if !AudioManager.isPaused || shouldForcePlayBecauseTheMusicChanged {
                
                let selectedSong = Song.selectedSong
                
                AudioManager.prepareToPlay(fileName: Song.songs[selectedSong].songFileName, fileExtension: Song.songs[selectedSong].songFileExtension)
                
                AudioManager.audioPlayer.delegate = self
                
            }
            
            AudioManager.play()
            
        }
        
        updateOutletsSongDuration()
        
        startCounting()
        
        btnPlayOutlet.isSelected = AudioManager.isPlaying()
        
    }
    
    
    @IBAction func sliderVolume(_ sender: UISlider) {
        
        AudioManager.adjustVolume(newVolume: sender.value)
        
    }
    
    
    @IBAction func btnSound(_ sender: Any) {
        
        AudioManager.adjustVolume(newVolume: 100)
        
        sliderVolumeOutlet.value = 100
        
    }
    
    
    @IBAction func btnMute(_ sender: Any) {
        
        AudioManager.adjustVolume(newVolume: 0)
        
        sliderVolumeOutlet.value = 0
        
    }
    
    
    @IBAction func btnTraverseMode(_ sender: UIButton) {
        
        let traverseMode = Song.traverseMode
        
        Song.traverseMode = (traverseMode + 1) < 4 ? traverseMode + 1 : 0
        
        updateTraverseMode()
        
    }
    
    
    @IBAction func sliderSongTime(_ sender: UISlider) {
            
        AudioManager.adjustCurrentTime(newTime: Double(sender.value))
        
        updateOutletsSongCurrentTime()
        
    }
    
    
    @IBAction func btnPlay(_ sender: UIButton) {
        
        if !AudioManager.isPlaying() {
            
            AudioManager.play()
            
            updateOutletsSongDuration()
            
            startCounting()
            
        } else {
            
            AudioManager.pause()
            
        }
        
        btnPlayOutlet.isSelected = AudioManager.isPlaying()
        
    }
    
    
    @IBAction func btnStepForward(_ sender: Any) {
        
        AudioManager.step(isForward: true)
        
        updateOutletsSongCurrentTime()
        
    }
    
    
    @IBAction func btnStepBackward(_ sender: Any) {
        
        AudioManager.step(isForward: false)
        
        updateOutletsSongCurrentTime()
        
    }
    
    
    @IBAction func btnNext(_ sender: Any) {
        
        nextSong(isForward: true)
        
        btnPlayOutlet.isSelected = AudioManager.isPlaying()
        
        updateOutletsSongDuration()
        
    }
    
    
    @IBAction func btnPrev(_ sender: Any) {
        
        nextSong(isForward: false)
        
        btnPlayOutlet.isSelected = AudioManager.isPlaying()
        
        updateOutletsSongDuration()
        
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        nextSong(isForward: true)
        
        updateOutletsSongDuration()
        
    }
    
    
    func prepareCircleImageView() {
        
        imgSongBg.layer.borderWidth = 7.5
        imgSongBg.layer.masksToBounds = false
        imgSongBg.layer.borderColor = UIColor.black.cgColor
        imgSongBg.layer.cornerRadius = imgSongBg.frame.height / 2
        imgSongBg.clipsToBounds = true
        
    }
    
    
    func resetOutletsSongCurrentTime() {
        
        sliderSongTimeOutlet.value = 0
        
        let (m, s) = (0, 0)
        lblSongCurrentTime.text = String(format: "%02d:%02d", m, s)
        
        btnPlayOutlet.isSelected = AudioManager.isPlaying()
        
    }
    
    
    func updateOutletsSongDuration() {
        
        let songDuration = AudioManager.songDuration()
        
        sliderSongTimeOutlet.maximumValue = Float(songDuration)
        
        let (m, s) = secondsToMinutesSeconds(seconds: Int(songDuration))
        lblSongDuration.text = String(format: "%02d:%02d", m, s)
        
    }
    
    
    func startCounting() {
        
        updateOutletsSongCurrentTime()
        
        let delay = 1.0
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(updateOutletsSongCurrentTime), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func updateOutletsSongCurrentTime() {
        
        let songCurrentTime = AudioManager.songCurrentTime()
        
        if !sliderSongTimeOutlet.isTouchInside {
            
            sliderSongTimeOutlet.value = Float(songCurrentTime)
            
        }
        
        let (m, s) = secondsToMinutesSeconds(seconds: Int(songCurrentTime))
        lblSongCurrentTime.text = String(format: "%02d:%02d", m, s)
        
    }
    
    
    func secondsToMinutesSeconds(seconds : Int) -> (Int, Int) {
        
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
        
    }
    
    
    func updateTraverseMode() {
        
        switch Song.traverseMode {
            
        case 0:
            btnTraverseModeOutlet.setImage(UIImage(named: "shuffle.png"), for: UIControl.State.normal)
                
        case 1:
            btnTraverseModeOutlet.setImage(UIImage(named: "repeat_one.png"), for: UIControl.State.normal)
                    
        case 2:
            btnTraverseModeOutlet.setImage(UIImage(named: "repeat_all.png"), for: UIControl.State.normal)
                        
        case 3:
            btnTraverseModeOutlet.setImage(UIImage(named: "in_order.png"), for: UIControl.State.normal)
            
        default:
            break
            
        }
        
    }
    
    
    func nextSong(isForward: Bool) {
        
        let selectedSong = Song.selectedSong
        let songsCount = Song.songs.count
                
        switch Song.traverseMode {
            
        case 0:
            chooseRandomSong()
            
        case 1:
            updateCurrentSong()
            
        case 2:
            if isForward {
                
                Song.selectedSong = (selectedSong + 1) < songsCount ? selectedSong + 1 : 0
                
            } else {
                
                Song.selectedSong = (selectedSong - 1) >= 0 ? selectedSong - 1 : songsCount - 1
                
            }
            
            updateCurrentSong()

        case 3:
            if isForward {
                
                if (selectedSong + 1) < songsCount {
                    
                    Song.selectedSong += 1
                    
                    updateCurrentSong()
                    
                } else {
                    
                    AudioManager.stop()
                    
                    timer.invalidate()
                    
                    resetOutletsSongCurrentTime()
                    
                    btnPlayOutlet.isSelected = false
                    
                    AudioManager.finishedPlayingAll = true
                    
                }
                
            } else {
                
                Song.selectedSong = (selectedSong - 1) >= 0 ? selectedSong - 1: 0
                
                updateCurrentSong()
                
            }
            
        default:
            break
            
        }
        
    }
    
    
    func chooseRandomSong() {
        
        let selectedSong = Song.selectedSong
        
        var randomIndex = -1
        repeat {
            
            randomIndex = Int.random(in: 0..<Song.songs.count)
            
        } while randomIndex == selectedSong
        
        Song.selectedSong = randomIndex
        
        updateCurrentSong()
        
    }
    
    
    func updateCurrentSong() {
        
        let selectedSong = Song.selectedSong
        
        imgSongBg.image = UIImage(named: Song.songs[selectedSong].songBgFileName)
        
        lblSongTitle.text = Song.songs[selectedSong].songTitle
        lblSongArtist.text = Song.songs[selectedSong].songArtist
        
        AudioManager.prepareToPlay(fileName: Song.songs[selectedSong].songFileName, fileExtension: Song.songs[selectedSong].songFileExtension)
        
        AudioManager.audioPlayer.delegate = self
            
        AudioManager.play()
        
        updateOutletsSongCurrentTime()
        
    }
    
    
}
