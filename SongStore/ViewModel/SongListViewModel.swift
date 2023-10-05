//
//  SongListViewModel.swift
//  SongStore
//
//  Created by LiZuJian on 2023/10/2.
//

import Foundation
import RxSwift
import RxCocoa

class SongService {
    func fetchSongs(for searchTerm: String, offset: Int, limit: Int = 20) -> Observable<[Song]> {
        guard let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return Observable.just([])
        }
        
        guard let url = URL(string: "https://itunes.apple.com/search?media=ebook&term=\(encodedSearchTerm)&offset=\(offset)&limit=\(limit)") else {
            return Observable.just([])
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "Accept": "*/*",
            "Accept-Language": "en;q=1.0, ckb-US;q=0.9",
            "User-Agent": "Postman Runtime via BookStore",
            "X-Forwarded-For": "8.8.8.8"
        ]
        
        return URLSession.shared.rx.data(request: request)
            .map { data in
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(SearchResponse.self, from: data)
                    return response.results
                } catch {
                    print(error)
                    return []
                }
            }
    }
}

class SongListViewModel {
    private let songService = SongService()
    private let disposeBag = DisposeBag()
    var term: String?
    var offset = 0
    var limit = 20
    let songs = BehaviorRelay<[Song]>(value: [])
    let refreshCompelted = PublishSubject<Void>()
    let loadMoreCompelted = PublishSubject<Bool>()
    
    let loadMoreAction = PublishSubject<Void>()
    let refreshAction = PublishSubject<Void>()
    
    func clearSongs() {
        self.offset = 0
        self.songs.accept([])
    }
    
    init() {
        refreshAction.subscribe { [weak self] _ in
            self?.refreshTriggered()
        }.disposed(by: disposeBag)
        
        loadMoreAction.subscribe { [weak self] _ in
            self?.loadMoreTriggered()
        }.disposed(by: disposeBag)
    }
    
    private func refreshTriggered() {
        guard let term = term else {
            self.refreshCompelted.onNext(())
            return
        }
        offset = 0
        fetchSongs(for: term)
    }
    
    private func loadMoreTriggered() {
        guard let term = term else {
            self.loadMoreCompelted.onNext(false)
            return
        }
        offset += songs.value.count
        fetchSongs(for: term)
    }
    
    func fetchSongs(for searchTerm: String) {
        let newTerm = searchTerm.replacingOccurrences(of: " ", with: "+")
        songService.fetchSongs(for: newTerm, offset: offset, limit: limit)
            .subscribe(onNext: { [weak self] songs in
                if self?.offset == 0 {
                    self?.songs.accept(songs)
                    self?.refreshCompelted.onNext(())
                    if songs.isEmpty {
                        self?.loadMoreCompelted.onNext(false)
                    }
                } else {
                    if var array = self?.songs.value {
                        array.append(contentsOf: songs)
                        self?.songs.accept(array)
                    }
                    self?.loadMoreCompelted.onNext(!songs.isEmpty)
                }
            })
            .disposed(by: disposeBag)
    }
}
