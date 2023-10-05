//
//  SongListViewCell.swift
//  SongStore
//
//  Created by LiZuJian on 2023/10/2.
//

import UIKit
import RxSwift
import RxCocoa

class SongListViewCell: UITableViewCell {
    
    enum Status: String {
    case normal = "收藏"
    case collected = "已收藏"
    }
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var des1Label: UILabel!
    @IBOutlet weak var des2Label: UILabel!
    @IBOutlet weak var des3Label: UILabel!
    
    @IBOutlet weak var collectBtn: UIButton!
    
    var disposeBag = DisposeBag()
    var status: Status = .normal {
        didSet {
            collectBtn.setTitle(status.rawValue, for: .normal)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
