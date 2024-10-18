//
//  PostViewModel.swift
//  EITCDuProjectAssignment
//
//  Created by Kirti Kalra on 16/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class PostViewModel {
    
    // MARK: Private Properties
    private let disposeBag = DisposeBag()
    private let serviceManager = ServiceManager()
    
    let postsRelay = BehaviorRelay<[PostDB]>(value: [])
    let favoritesRelay = BehaviorRelay<[PostDB]>(value: [])
    
    init() {
        fetchAndSavePosts()
        fetchFavoritePosts()
    }
    
    func fetchAndSavePosts() {
            self.serviceManager.fetchPostsList()
                .subscribe(onNext: {[weak self] postsAPI in
                    let realm = try! Realm()
                    let posts = postsAPI.map { postAPI in
                        PostDB(value: ["id": postAPI.id,
                                       "title": postAPI.title,
                                       "body": postAPI.body,
                                       "isFavorite": false])
                    }
                    try! realm.write {
                        realm.add(posts, update: .modified)
                        self?.postsRelay.accept(posts)
                    }
                })
                .disposed(by: disposeBag)
    }
    
    private func fetchPostsFromRealm() {
        // Fetch posts from Realm
        let realm = try! Realm()
        let posts = realm.objects(PostDB.self)
        
        // Convert Results<Post> to [Post]
        let postsArray = Array(posts)
        
        // Update BehaviorRelay
        postsRelay.accept(postsArray)
    }
    
    private func fetchFavoritePosts() {
        let realm = try! Realm()
        let favoritePosts = realm.objects(PostDB.self).filter("isFavorite == true")
        favoritesRelay.accept(Array(favoritePosts))
    }
    
    func deleteFavorite(postId: Int) {
        var favorites = favoritesRelay.value
        favorites.removeAll { $0.id == postId }
        favoritesRelay.accept(favorites) // Update the relay with the new favorites list
    }
    
    func toggleFavorite(postId: Int) {
        let realm = try! Realm()
        if let post = realm.object(ofType: PostDB.self, forPrimaryKey: postId) {
            try! realm.write {
                post.isFavorite.toggle() // Toggle the favorite status
                fetchFavoritePosts()
            }
        }
    }
}
