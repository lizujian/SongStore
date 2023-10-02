//
//  SongListViewCell.swift
//  SongStore
//
//  Created by LiZuJian on 2023/10/2.
//

import UIKit

class SongListViewCell: UITableViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var des1Label: UILabel!
    @IBOutlet weak var des2Label: UILabel!
    @IBOutlet weak var des3Label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
