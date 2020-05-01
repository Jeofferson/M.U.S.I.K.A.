//
//  TableViewCellSong.swift
//  DelaPena_Teves
//
//  Created by Jeofferson Dela Peña on 2/8/20.
//  Copyright © 2020 Jeofferson Dela Peña. All rights reserved.
//

import UIKit

class TableViewCellSong: UITableViewCell {

    
    @IBOutlet weak var imgSongBg: UIImageView!
    
    @IBOutlet weak var lblSongTitle: UILabel!
    @IBOutlet weak var lblSongArtist: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
