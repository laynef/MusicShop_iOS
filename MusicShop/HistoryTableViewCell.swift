//
//  HistpryTableViewCell.swift
//  MusicShop
//
//  Created by Layne Faler on 6/25/16.
//  Copyright © 2016 Layne Faler. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var historyAlbumLebel: UILabel!
    @IBOutlet weak var historyArtistLabel: UILabel!
    @IBOutlet weak var historyAlbumImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
