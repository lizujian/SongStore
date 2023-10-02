//
//  ViewController.swift
//  SongStore
//
//  Created by LiZuJian on 2023/10/2.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate {

    private let viewModel = SongListViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }
    
    func configureUI() {
        self.setupTableView()
        self.setupRx()
    }

    func setupRx() {
        viewModel.songs.bind(to: tableView.rx.items(cellIdentifier: "SongListViewCell", cellType: SongListViewCell.self)){ (row, song, cell) in
            
            cell.nameLabel.text = song.trackName
            cell.des1Label.text = song.artistName
            cell.des2Label.text = song.collectionName
            cell.des3Label.text = song.country

            if let imageURL = URL(string: song.artworkUrl60) {
                cell.coverImageView.kf.setImage(with: imageURL)
            }
        }.disposed(by: disposeBag)
        
        viewModel.fetchSongs(for: "Jack Johnson")
    }
    
    func setupTableView() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
        
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if text.count == 0 { return }
        viewModel.fetchSongs(for: text)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

