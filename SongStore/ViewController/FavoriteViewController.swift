//
//  FavoriteViewController.swift
//  SongStore
//
//  Created by LiZuJian on 2023/10/7.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class FavoriteViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = L10n("Favorite")
        self.navigationItem.rightBarButtonItem = editButtonItem
        configureUI()
    }
    
    func configureUI() {
        self.setupTableView()
        self.setupRx()
    }

    func setupRx() {
        SongDataManager.shared.favorites.bind(to: tableView.rx.items(cellIdentifier: "SongListViewCell", cellType: SongListViewCell.self)){ (row, favorite, cell) in
            
            cell.nameLabel.text = favorite.trackName
            cell.des1Label.text = favorite.artistName
            cell.des2Label.text = favorite.collectionName
            cell.des3Label.text = favorite.country
            cell.status = .collected
            if let artworkUrl = favorite.artworkUrl, let imageURL = URL(string: artworkUrl) {
                cell.coverImageView.kf.setImage(with: imageURL)
            }
            cell.collectBtn.isHidden = true
        }.disposed(by: disposeBag)
        
        tableView.rx.modelDeleted(Favorites.self).subscribe { favorite in
            SongDataManager.shared.removeSong(id: favorite.id!)
        }.disposed(by: disposeBag)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
