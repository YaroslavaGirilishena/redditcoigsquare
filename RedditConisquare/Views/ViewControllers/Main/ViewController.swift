//
//  ViewController.swift
//  RedditConisquare
//
//  Created by Yaroslava Girilishena on 2018-02-03.
//  Copyright © 2018 YG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //-----------------
    // MARK: - Veriables
    //-----------------
    
    var postTitles = [RedditPost]()
    var wasError: Bool = false
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            
            tableView.register(UINib (nibName: "ErrorTVCell", bundle: nil), forCellReuseIdentifier: "ErrorTVCell")
            
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableViewAutomaticDimension

            tableView.tableFooterView = UIView()
            tableView.refreshControl = refreshControl
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    //-----------------
    // MARK: - Methods
    //-----------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPosts()
    }
}

//-----------------
// MARK: - Teble View data source
//-----------------

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postTitles.count + (wasError ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if wasError && indexPath.row == 0 {
            // Error cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ErrorTVCell", for: indexPath) as! ErrorTVCell
            cell.delegate = self
            return cell
        } else {
            // Post cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
            cell.textLabel?.text = postTitles[indexPath.row - (wasError ? 1 : 0)].postTitle
            return cell
        }
    }
}

//-----------------
// MARK: - API requests
//-----------------

extension ViewController {
    
    func getPosts() {
        RedditAPI.shared.fetchRedditData({ [weak self] posts in
            // Success closure
            guard let `self` = self else { return }
            
            // Clean up
            if self.postTitles.count > 0 {
                self.postTitles.removeAll()
            }
            
            // Add posts' titles
            for post in posts {
                self.postTitles.append(RedditPost.init(post))
            }
            self.wasError = false
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
            
        }) { [weak self] in
            // Failure closure
            guard let `self` = self else { return }
            
            self.wasError = true
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
}

//-----------------
// MARK: - Actions
//-----------------

extension ViewController {
    @objc func refresh() {
        getPosts()
    }
}

//-----------------
// MARK: - Error Handling
//-----------------

extension ViewController: ErrorTVCellDelegate {
    
    func errorCellShouldReloadData(_ cell: ErrorTVCell) {
        refresh()
    }
}
