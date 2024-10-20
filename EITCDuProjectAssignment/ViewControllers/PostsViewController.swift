//
//  PostsViewController.swift
//  EITCDuProjectAssignment
//
//  Created by Kirti Kalra on 15/10/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PostsViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    //Dispose bag
    private let disposeBag = DisposeBag()
    private let viewModel = PostViewModel()
    private var selectedSegmentIndex: Int = 0
    var tableViewDisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableViewSetup()
        bindTableViewForPosts(to: viewModel.postsRelay)
        
        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                self?.selectedSegmentIndex = index
                if index == 0 {
                    self?.bindTableViewForPosts(to: self?.viewModel.postsRelay)
                } else {
                    self?.bindTableViewForPosts(to: self?.viewModel.favoritesRelay)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Private Methods
    
    private func setupNavigationBar() {
        // Create the button
        let rightButton = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
        
        // Assign the button to the right bar button item
        self.navigationItem.rightBarButtonItem = rightButton
        
        // Bind button tap event to an action
        rightButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleButtonTap()
            })
            .disposed(by: disposeBag)
    }
    
    private func handleButtonTap() {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        if isLoginViewControllerInStack() {
            self.navigationController?.popViewController(animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.navigationController?.setViewControllers([loginVC], animated: false)
        }
    }
    
    private func isLoginViewControllerInStack() -> Bool {
        // Check if the navigation controller exists
        guard let viewControllers = self.navigationController?.viewControllers else {
            return false
        }
        
        // Check if LoginViewController is in the stack
        return viewControllers.contains(where: { $0 is LoginViewController })
    }
}

// MARK: UITableView Delegate
extension PostsViewController: UITableViewDelegate {
    func tableViewSetup() {
        tableView.separatorStyle = .none
        
        // Registering XIB UITableViewCell
        let postTableViewCell = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(postTableViewCell, forCellReuseIdentifier: "PostTableViewCell")
    }
    
    private func bindTableViewForPosts(to relay: BehaviorRelay<[PostDB]>?) {
        tableViewDisposeBag = DisposeBag()
        guard let relay = relay else { return }
        relay
            .bind(to: tableView.rx.items(cellIdentifier: "PostTableViewCell", cellType: PostTableViewCell.self)) { [weak self] row, post, cell in
                cell.configure(for: post)
            }
            .disposed(by: tableViewDisposeBag)
        
        // Handle toggling favorites when a cell is selected
        tableView.rx.modelSelected(PostDB.self)
            .subscribe(onNext: { [weak self] post in
                self?.viewModel.toggleFavorite(postId: post.id)
                self?.tableView.reloadData()
            })
            .disposed(by: tableViewDisposeBag)
        
        // Handle swipe to delete
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self, self.segmentedControl.selectedSegmentIndex == 1 else { return }
                let favorites = viewModel.favoritesRelay.value
                let post = favorites[indexPath.row]
                self.viewModel.deleteFavorite(postId: post.id) // Call delete method in ViewModel
            })
            .disposed(by: tableViewDisposeBag)
    }
}
