//
//  Song.swift
//  DelaPena_Teves
//
//  Created by Jeofferson Dela Peña on 2/8/20.
//  Copyright © 2020 Jeofferson Dela Peña. All rights reserved.
//

import Foundation


class Song {
    
    
    var songTitle = ""
    var songArtist = ""
    
    var songFileName = ""
    var songFileExtension = ""
    
    var songBgFileName = ""
    
    static var traverseMode = 0
    
    static var selectedSong = -1
    static var songs: [Song] = [
        Song(songTitle: "Obsessed", songArtist: "Dan & Shay", songFileName: "obsessed", songFileExtension: "mp3", songBgFileName: "song1.jpg"),
        Song(songTitle: "Tequila", songArtist: "Dan & Shay", songFileName: "tequila", songFileExtension: "mp3", songBgFileName: "song2.jpg"),
        Song(songTitle: "Maybe the Night", songArtist: "Ben & Ben", songFileName: "maybe_the_night", songFileExtension: "mp3", songBgFileName: "song3.jpg"),
        Song(songTitle: "All to Myself", songArtist: "Dan & Shay", songFileName: "all_to_myself", songFileExtension: "mp3", songBgFileName: "song4.jpg"),
        Song(songTitle: "Mean It", songArtist: "LANY & Lauv", songFileName: "mean_it", songFileExtension: "mp3", songBgFileName: "song5.jpg"),
        Song(songTitle: "Changes", songArtist: "Lauv", songFileName: "changes", songFileExtension: "mp3", songBgFileName: "song6.jpg"),
        Song(songTitle: "Feelings", songArtist: "Lauv", songFileName: "feelings", songFileExtension: "mp3", songBgFileName: "song7.jpg"),
        Song(songTitle: "Tattoos Together", songArtist: "Lauv", songFileName: "tattoos_together", songFileExtension: "mp3", songBgFileName: "song8.jpg"),
        Song(songTitle: "10,000 Hours", songArtist: "Justin Bieber", songFileName: "10000_hours", songFileExtension: "mp3", songBgFileName: "song9.jpg"),
        Song(songTitle: "Mandy", songArtist: "Westlife", songFileName: "mandy", songFileExtension: "mp3", songBgFileName: "song0.png"),
    ]
    
    
    init(songTitle: String, songArtist: String, songFileName: String, songFileExtension: String, songBgFileName: String) {
        
        self.songTitle = songTitle
        self.songArtist = songArtist
        
        self.songFileName = songFileName
        self.songFileExtension = songFileExtension
        
        self.songBgFileName = songBgFileName
        
    }
    
    
}
