//
//  SongDataManager.swift
//  SongStore
//
//  Created by LiZuJian on 2023/10/6.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import CoreData

class SongDataManager {
    static public let shared = SongDataManager()
    private let disposeBag = DisposeBag()
    
    var favoritesDict = [String: Favorites]() {
        didSet {
            favorites.accept(favoritesDict.map{$0.1})
        }
    }
    
    let favorites = BehaviorRelay<[Favorites]>(value: [])
    
    init() {
        fetchSong()
    }
    
    func addSong(song: Song) {
        let app
        = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        guard let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context) as? Favorites else { return }
        let id = String(song.trackId)
        favorite.id = id
        favorite.trackName = song.trackName
        favorite.artistName = song.artistName
        favorite.artworkUrl = song.artworkUrl60
        favorite.country = song.country
        favorite.collectionName = song.collectionName
        do {
            try context.save()
            favoritesDict[id] = favorite
        } catch {
            // error
        }
    }
    
    func removeSong(id: String) {
        guard let favorite = favoritesDict[id] else {
            return
        }
        let app
        = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        context.delete(favorite)
        do {
            try context.save()
            favoritesDict.removeValue(forKey: id)
        } catch {
            // error
        }
    }
    
    func removeSong(song: Song) {
        let id = String(song.trackId)
        guard let favorite = favoritesDict[id] else {
            return
        }
        let app
        = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        context.delete(favorite)
        do {
            try context.save()
            favoritesDict.removeValue(forKey: id)
        } catch {
            // error
        }
    }
    
    func fetchSong() {
        let app
        = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = Favorites.fetchRequest()
        if let fetchedObjects = try? context.fetch(fetchRequest) {
            favoritesDict = Dictionary.init(fetchedObjects.map { ($0.id!, $0) }) { $1 }
        }
    }
}
