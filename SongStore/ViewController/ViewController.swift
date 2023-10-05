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
import MJRefresh

let defaultTerm = "Jack Johnson"

class ViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UISearchBarDelegate {

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
        viewModel.term = defaultTerm
        viewModel.songs.bind(to: tableView.rx.items(cellIdentifier: "SongListViewCell", cellType: SongListViewCell.self)){ (row, song, cell) in
            
            cell.nameLabel.text = song.trackName
            cell.des1Label.text = song.artistName
            cell.des2Label.text = song.collectionName
            cell.des3Label.text = song.country

            if let imageURL = URL(string: song.artworkUrl60) {
                cell.coverImageView.kf.setImage(with: imageURL)
            }
            cell.collectBtn.rx.tap.subscribe({ [weak self]_ in
                self?.collectOrNot(cell: cell, song: song)
            }).disposed(by: cell.disposeBag)
            
        }.disposed(by: disposeBag)
        
        viewModel.refreshCompelted.subscribe { [weak self] _ in
            self?.tableView.mj_header?.endRefreshing()
        }.disposed(by: disposeBag)
        
        viewModel.loadMoreCompelted.subscribe { [weak self] isAvaliable in
            if isAvaliable {
                self?.tableView.mj_footer?.endRefreshing()
            } else {
                self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        }.disposed(by: disposeBag)
    }
    
    func setupTableView() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        search.searchBar.delegate = self
        navigationItem.searchController = search
        
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        MJRefreshNormalHeader { [weak self] in
            self?.viewModel.refreshAction.onNext(())
        }.autoChangeTransparency(true)
        .link(to: tableView)
        
        MJRefreshAutoNormalFooter { [weak self] in
            self?.viewModel.loadMoreAction.onNext(())
        }.autoChangeTransparency(true)
        .link(to: tableView)
        
        tableView.mj_header?.beginRefreshing()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if text.count == 0 {
            return
        }
        self.viewModel.term = text
        self.tableView.mj_header?.beginRefreshing()
    }
    
    func collectOrNot(cell:SongListViewCell, song: Song) {
        if cell.status == .normal {
            cell.status = .collected
        } else {
            cell.status = .normal
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.term = defaultTerm
        self.tableView.mj_header?.beginRefreshing()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

