//
//  ViewController.swift
//  DelaPena_Teves
//
//  Created by Jeofferson Dela Peña on 2/8/20.
//  Copyright © 2020 Jeofferson Dela Peña. All rights reserved.
//

import AVFoundation
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate {
    

    var shouldForcePlayBecauseTheMusicChanged = false
    
    @IBOutlet weak var btnSongBgOutlet: UIButton!
    
    @IBOutlet weak var lblSongTitle: UILabel!
    @IBOutlet weak var lblSongArtist: UILabel!
    
    @IBOutlet weak var btnTraverseModeOutlet: UIButton!
    
    @IBOutlet weak var btnPlayOutlet: UIButton!
    
    @IBOutlet weak var tblviewSongs: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        
        prepareCircleImageView()
        
        Song.selectedSong = 0
        
        prepareOutletsPlaySong(selectedSong: 0, isFirstTime: true)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        shouldForcePlayBecauseTheMusicChanged = false
        
        updateOutlets()

        AudioManager.audioPlayer.delegate = self
        
        updateCurrentSong()
        
    }
    
    
    @IBAction func btnSongBg(_ sender: Any) {
        
        if Song.selectedSong != -1 {
        
            shouldForcePlayBecauseTheMusicChanged = false
            
            performSegue(withIdentifier: "toVCSong", sender: self)
            
        }
        
    }
    
    
    @IBAction func btnTraverseMode(_ sender: Any) {
        
        let traverseMode = Song.traverseMode
        
        Song.traverseMode = (traverseMode + 1) < 4 ? traverseMode + 1 : 0
        
        updateTraverseMode()
        
    }
    
    
    @IBAction func btnPlay(_ sender: UIButton) {
        
        if !AudioManager.isPlaying() {
            
            if !AudioManager.isPaused {
                
                let selectedSong = Song.selectedSong
                
                AudioManager.prepareToPlay(fileName: Song.songs[selectedSong].songFileName, fileExtension: Song.songs[selectedSong].songFileExtension)
                
                AudioManager.audioPlayer.delegate = self
                
            }
            
            AudioManager.play()
            
        } else {
            
            AudioManager.pause()
            
        }
        
        btnPlayOutlet.isSelected = AudioManager.isPlaying()
        
    }
    
    
    @IBAction func btnStepForward(_ sender: Any) {
        
        shouldForcePlayBecauseTheMusicChanged = true
        
        nextSong(isForward: true)
        
        btnPlayOutlet.isSelected = AudioManager.isPlaying()
        
    }
    
    
    @IBAction func btnStepBackward(_ sender: Any) {
        
        shouldForcePlayBecauseTheMusicChanged = true
        
        nextSong(isForward: false)
        
        btnPlayOutlet.isSelected = AudioManager.isPlaying()
        
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        nextSong(isForward: true)

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Song.songs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowNumber = indexPath.row
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.black
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rowSong", for: indexPath) as! TableViewCellSong
        
        cell.selectedBackgroundView = bgColorView
        
        cell.imgSongBg.image = UIImage(named: Song.songs[rowNumber].songBgFileName)
        
        cell.lblSongTitle.text = Song.songs[rowNumber].songTitle
        cell.lblSongArtist.text = Song.songs[rowNumber].songArtist
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
            
        case UITableViewCell.EditingStyle.delete:
            Song.songs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
            AudioManager.play()
            AudioManager.stop()
            
            Song.selectedSong = 0
            
            prepareOutletsPlaySong(selectedSong: 0, isFirstTime: true)
            
        default:
            break
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNumber = indexPath.row
        
        shouldForcePlayBecauseTheMusicChanged = Song.selectedSong != rowNumber
        
        Song.selectedSong = rowNumber
        
        performSegue(withIdentifier: "toVCSong", sender: self)
        
        tblviewSongs.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let selectedSong = Song.selectedSong
        
        let vcSong = segue.destination as! VCSong
        
        vcSong.shouldForcePlayBecauseTheMusicChanged = shouldForcePlayBecauseTheMusicChanged
        
        vcSong.songBg = Song.songs[selectedSong].songBgFileName
        
        vcSong.songTitle = Song.songs[selectedSong].songTitle
        vcSong.songArtist = Song.songs[selectedSong].songArtist
        
    }
    
    
    func prepareCircleImageView() {
        
        btnSongBgOutlet.imageView?.contentMode = .scaleAspectFill
        
        btnSongBgOutlet.imageView?.layer.borderWidth = 2.5
        btnSongBgOutlet.imageView?.layer.masksToBounds = false
        btnSongBgOutlet.imageView?.layer.borderColor = UIColor.black.cgColor
        btnSongBgOutlet.imageView?.layer.cornerRadius = btnSongBgOutlet.frame.height / 2
        btnSongBgOutlet.imageView?.clipsToBounds = true
        
    }
    
    
    func updateOutlets() {
        
        btnPlayOutlet.isSelected = AudioManager.isPlaying()
        
        updateTraverseMode()
        
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
                
                Song.selectedSong = (selectedSong - 1) >= 0 ? selectedSong - 1: songsCount - 1
                
            }
            
            updateCurrentSong()

        case 3:
            if isForward {
                
                if (selectedSong + 1) < songsCount {
                    
                    Song.selectedSong += 1
                    
                    updateCurrentSong()
                    
                } else {
                    
                    AudioManager.stop()
                    
                    btnPlayOutlet.isSelected = AudioManager.isPlaying()
                    
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
        
        if selectedSong != -1 && !AudioManager.finishedPlayingAll {
            
            prepareOutletsPlaySong(selectedSong: selectedSong, isFirstTime: false)
            
        }
        
        if AudioManager.finishedPlayingAll {
            
            prepareOutlets(selectedSong: selectedSong)
            
        }
        
    }
    
    
    func prepareOutletsPlaySong(selectedSong: Int, isFirstTime: Bool) {
        
        prepareOutlets(selectedSong: selectedSong)
        
        if (!AudioManager.isPlaying() && !AudioManager.isPaused) || shouldForcePlayBecauseTheMusicChanged {
        
            AudioManager.prepareToPlay(fileName: Song.songs[selectedSong].songFileName, fileExtension: Song.songs[selectedSong].songFileExtension)
            
            AudioManager.audioPlayer.delegate = self
            
            AudioManager.play()
            
        }
        
        if isFirstTime {
            
            AudioManager.pause()
            
        }
        
        btnPlayOutlet.isSelected = AudioManager.isPlaying()
        
    }
    
    
    func prepareOutlets(selectedSong: Int) {
        
        btnSongBgOutlet.setImage(UIImage(named: Song.songs[selectedSong].songBgFileName), for: UIControl.State.normal)
        
        lblSongTitle.text = Song.songs[selectedSong].songTitle
        lblSongArtist.text = Song.songs[selectedSong].songArtist
        
    }
    
    
}

